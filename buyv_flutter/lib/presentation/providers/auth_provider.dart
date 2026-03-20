import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/models/auth_models.dart';
import '../../core/services/token_manager.dart';
import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';

/// Auth state — replaces KMP's AuthState sealed class.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthGuest extends AuthState {
  const AuthGuest();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Auth notifier — replaces KMP's ProfileViewModel auth logic + SharedModule auth use cases.
/// Uses Riverpod AsyncNotifier for async state management.
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRemoteDataSource _dataSource;

  @override
  AuthState build() {
    _dataSource = AuthRemoteDataSource();
    _checkInitialAuth();
    return const AuthInitial();
  }

  Future<void> _checkInitialAuth() async {
    final isLoggedIn = await TokenManager.isLoggedIn();
    if (isLoggedIn) {
      try {
        final user = await _dataSource.getCurrentUser();
        state = AuthAuthenticated(user);
      } catch (_) {
        state = const AuthGuest();
      }
    } else {
      state = const AuthGuest();
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final response = await _dataSource.login(
        LoginRequest(email: email, password: password),
      );
      await _saveTokens(response);
      state = AuthAuthenticated(response.user);
      return true;
    } on AppException catch (e) {
      state = AuthError(e.message);
      return false;
    } catch (e) {
      state = AuthError('Login failed. Please try again.');
      return false;
    }
  }

  Future<bool> register(String email, String password, String username, String displayName) async {
    state = const AuthLoading();
    try {
      final response = await _dataSource.register(
        RegisterRequest(
          email: email,
          password: password,
          username: username,
          displayName: displayName,
        ),
      );
      await _saveTokens(response);
      state = AuthAuthenticated(response.user);
      return true;
    } on AppException catch (e) {
      state = AuthError(e.message);
      return false;
    } catch (e) {
      state = AuthError('Registration failed. Please try again.');
      return false;
    }
  }

  Future<bool> googleSignIn(String idToken) async {
    state = const AuthLoading();
    try {
      final response = await _dataSource.googleSignIn(idToken);
      await _saveTokens(response);
      state = AuthAuthenticated(response.user);
      return true;
    } on AppException catch (e) {
      state = AuthError(e.message);
      return false;
    } catch (e) {
      state = AuthError('Google sign-in failed.');
      return false;
    }
  }

  Future<bool> facebookSignIn(String accessToken) async {
    state = const AuthLoading();
    try {
      final response = await _dataSource.facebookSignIn(accessToken);
      await _saveTokens(response);
      state = AuthAuthenticated(response.user);
      return true;
    } on AppException catch (e) {
      state = AuthError(e.message);
      return false;
    } catch (e) {
      state = AuthError('Facebook sign-in failed.');
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = const AuthLoading();
    try {
      await _dataSource.sendPasswordReset(email);
      state = const AuthGuest();
      return true;
    } on AppException catch (e) {
      state = AuthError(e.message);
      return false;
    } catch (_) {
      state = AuthError('Failed to send reset email.');
      return false;
    }
  }

  Future<void> logout() async {
    await _dataSource.logout();
    await TokenManager.clearTokens();
    ApiClient.reset();
    state = const AuthGuest();
  }

  /// Enter guest mode — fixes AUTH-003/004 (no forced login).
  void continueAsGuest() {
    state = const AuthGuest();
  }

  Future<void> _saveTokens(AuthResponse response) async {
    await TokenManager.saveAccessToken(response.accessToken);
    await TokenManager.saveUserId(response.user.id);
    if (response.refreshToken != null) {
      await TokenManager.saveRefreshToken(response.refreshToken!);
    }
  }

  bool get isAuthenticated => state is AuthAuthenticated;
  UserModel? get currentUser =>
      state is AuthAuthenticated ? (state as AuthAuthenticated).user : null;
}

// ── Riverpod Providers ──────────────────────────────────────────────────────
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUserProvider = Provider<UserModel?>((ref) {
  final auth = ref.watch(authProvider);
  return auth is AuthAuthenticated ? auth.user : null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});
