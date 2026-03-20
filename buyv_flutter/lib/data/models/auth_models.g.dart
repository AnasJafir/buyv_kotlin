// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 1800,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'user': instance.user,
      'refreshToken': instance.refreshToken,
    };

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'user',
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      reelsCount: (json['reelsCount'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      settings: (json['settings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'role': instance.role,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'reelsCount': instance.reelsCount,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'interests': instance.interests,
      'settings': instance.settings,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'displayName': instance.displayName,
    };

_$PasswordResetRequestImpl _$$PasswordResetRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetRequestImpl(
      email: json['email'] as String,
    );

Map<String, dynamic> _$$PasswordResetRequestImplToJson(
        _$PasswordResetRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

_$PasswordResetConfirmImpl _$$PasswordResetConfirmImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetConfirmImpl(
      token: json['token'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$PasswordResetConfirmImplToJson(
        _$PasswordResetConfirmImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'newPassword': instance.newPassword,
    };

_$GoogleSignInRequestImpl _$$GoogleSignInRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleSignInRequestImpl(
      idToken: json['idToken'] as String,
    );

Map<String, dynamic> _$$GoogleSignInRequestImplToJson(
        _$GoogleSignInRequestImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
    };

_$FacebookSignInRequestImpl _$$FacebookSignInRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookSignInRequestImpl(
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$$FacebookSignInRequestImplToJson(
        _$FacebookSignInRequestImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
    };
