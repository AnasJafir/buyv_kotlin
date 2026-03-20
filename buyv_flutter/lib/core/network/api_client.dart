import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../services/token_manager.dart';

/// Dio HTTP client — replaces KMP's KtorClientConfig.
/// Includes:
///  - JWT Bearer token injection (like KMP's HttpSend.intercept)
///  - 401 → silent refresh → retry (mutex prevents concurrent refresh)
///  - Centralised error mapping to [AppException]
class ApiClient {
  ApiClient._();

  static Dio? _authenticated;
  static Dio? _public;

  static bool _isRefreshing = false;
  static final List<Function> _pendingRequests = [];

  // ── Authenticated Client ─────────────────────────────────────────
  static Dio get authenticated {
    _authenticated ??= _createAuthenticated();
    return _authenticated!;
  }

  // ── Public Client (login / register) ────────────────────────────
  static Dio get public {
    _public ??= _createPublic();
    return _public!;
  }

  // ── Factory: Authenticated ───────────────────────────────────────
  static Dio _createAuthenticated() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    if (AppConfig.enableNetworkLogs) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }

    // ── Auth Interceptor (JWT inject + 401 auto-refresh) ───────────
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenManager.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          if (_isRefreshing) {
            // Queue request to retry after refresh completes
            _pendingRequests.add(() => _retry(error.requestOptions));
            return;
          }
          _isRefreshing = true;
          try {
            final refreshed = await _refreshTokens();
            if (refreshed) {
              // Retry original + all queued
              for (final fn in _pendingRequests) {
                fn();
              }
              _pendingRequests.clear();
              final retried = await _retry(error.requestOptions);
              handler.resolve(retried);
              return;
            }
          } catch (_) {
            // Refresh failed — clear tokens, let UI handle redirect via Riverpod auth state
            await TokenManager.clearTokens();
          } finally {
            _isRefreshing = false;
          }
        }
        handler.next(_mapError(error));
      },
    ));

    return dio;
  }

  // ── Factory: Public ──────────────────────────────────────────────
  static Dio _createPublic() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    if (AppConfig.enableNetworkLogs) {
      dio.interceptors.add(PrettyDioLogger(compact: true, requestBody: true));
    }

    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) => handler.next(_mapError(error)),
    ));

    return dio;
  }

  // ── Retry After Token Refresh ────────────────────────────────────
  static Future<Response<dynamic>> _retry(RequestOptions opts) async {
    final token = await TokenManager.getAccessToken();
    opts.headers['Authorization'] = 'Bearer $token';
    return authenticated.fetch(opts);
  }

  // ── Silent Token Refresh ─────────────────────────────────────────
  static Future<bool> _refreshTokens() async {
    final refreshToken = await TokenManager.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final resp = await public.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final newAccess = resp.data['access_token'] as String?;
      final newRefresh = resp.data['refresh_token'] as String?;
      if (newAccess != null) {
        await TokenManager.saveAccessToken(newAccess);
        if (newRefresh != null) await TokenManager.saveRefreshToken(newRefresh);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Error Mapper ─────────────────────────────────────────────────
  static DioException _mapError(DioException e) {
    final code = e.response?.statusCode;
    final msg = e.response?.data?['detail'] ??
        e.response?.data?['message'] ??
        e.message ??
        'Unknown error';
    return e.copyWith(
      error: AppException.fromStatusCode(code, msg.toString()),
    );
  }

  /// Reset clients (useful for testing / logout)
  static void reset() {
    _authenticated = null;
    _public = null;
  }
}
