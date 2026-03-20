import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// ── AuthResponse (maps to AuthResponseDto in KMP) ──────────────────────────
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    @Default('bearer') String tokenType,
    @Default(1800) int expiresIn,
    required UserModel user,
    String? refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

// ── UserModel (maps to UserDto in KMP) ─────────────────────────────────────
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    required String displayName,
    String? profileImageUrl,
    String? bio,
    @Default('user') String role, // user | promoter | admin
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int reelsCount,
    @Default(false) bool isVerified,
    required String createdAt,
    required String updatedAt,
    @Default([]) List<String> interests,
    Map<String, String>? settings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// ── LoginRequest ────────────────────────────────────────────────────────────
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

// ── RegisterRequest (maps to UserCreateDto) ─────────────────────────────────
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

// ── PasswordResetRequest ────────────────────────────────────────────────────
@freezed
class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({
    required String email,
  }) = _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}

// ── PasswordResetConfirm ────────────────────────────────────────────────────
@freezed
class PasswordResetConfirm with _$PasswordResetConfirm {
  const factory PasswordResetConfirm({
    required String token,
    required String newPassword,
  }) = _PasswordResetConfirm;

  factory PasswordResetConfirm.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetConfirmFromJson(json);
}

// ── GoogleSignInRequest ─────────────────────────────────────────────────────
@freezed
class GoogleSignInRequest with _$GoogleSignInRequest {
  const factory GoogleSignInRequest({
    required String idToken,
  }) = _GoogleSignInRequest;

  factory GoogleSignInRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleSignInRequestFromJson(json);
}

// ── FacebookSignInRequest ───────────────────────────────────────────────────
@freezed
class FacebookSignInRequest with _$FacebookSignInRequest {
  const factory FacebookSignInRequest({
    required String accessToken,
  }) = _FacebookSignInRequest;

  factory FacebookSignInRequest.fromJson(Map<String, dynamic> json) =>
      _$FacebookSignInRequestFromJson(json);
}
