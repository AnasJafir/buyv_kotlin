import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth_models.dart';

/// Auth remote data source — replaces KMP's AuthApiService.
/// Handles all auth endpoints: login, register, Google, Facebook, password reset.
class AuthRemoteDataSource {
  final Dio _dio;
  final Dio _publicDio;

  AuthRemoteDataSource()
      : _dio = ApiClient.authenticated,
        _publicDio = ApiClient.public;

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _publicDio.post(
      '/auth/login',
      data: {
        'email': request.email,
        'password': request.password,
      },
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _publicDio.post(
      '/auth/register',
      data: {
        'email': request.email,
        'password': request.password,
        'username': request.username,
        'display_name': request.displayName,
      },
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> googleSignIn(String idToken) async {
    final response = await _publicDio.post(
      '/auth/google-signin',
      data: {'id_token': idToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> facebookSignIn(String accessToken) async {
    final response = await _publicDio.post(
      '/auth/facebook-signin',
      data: {'access_token': accessToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendPasswordReset(String email) async {
    await _publicDio.post(
      '/auth/password-reset',
      data: {'email': email},
    );
  }

  Future<void> confirmPasswordReset(PasswordResetConfirm req) async {
    await _publicDio.post(
      '/auth/password-reset/confirm',
      data: req.toJson(),
    );
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _publicDio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Always proceed with local logout even if server call fails
    }
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/users/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
