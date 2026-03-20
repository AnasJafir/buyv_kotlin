// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String tokenType,
      int expiresIn,
      UserModel user,
      String? refreshToken});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = null,
    Object? refreshToken = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String tokenType,
      int expiresIn,
      UserModel user,
      String? refreshToken});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = null,
    Object? refreshToken = freezed,
  }) {
    return _then(_$AuthResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl(
      {required this.accessToken,
      this.tokenType = 'bearer',
      this.expiresIn = 1800,
      required this.user,
      this.refreshToken});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  @JsonKey()
  final String tokenType;
  @override
  @JsonKey()
  final int expiresIn;
  @override
  final UserModel user;
  @override
  final String? refreshToken;

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, tokenType, expiresIn, user, refreshToken);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {required final String accessToken,
      final String tokenType,
      final int expiresIn,
      required final UserModel user,
      final String? refreshToken}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get tokenType;
  @override
  int get expiresIn;
  @override
  UserModel get user;
  @override
  String? get refreshToken;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // user | promoter | admin
  int get followersCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  int get reelsCount => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  List<String> get interests => throw _privateConstructorUsedError;
  Map<String, String>? get settings => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String displayName,
      String? profileImageUrl,
      String? bio,
      String role,
      int followersCount,
      int followingCount,
      int reelsCount,
      bool isVerified,
      String createdAt,
      String updatedAt,
      List<String> interests,
      Map<String, String>? settings});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? role = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? reelsCount = null,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? interests = null,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reelsCount: null == reelsCount
          ? _value.reelsCount
          : reelsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String displayName,
      String? profileImageUrl,
      String? bio,
      String role,
      int followersCount,
      int followingCount,
      int reelsCount,
      bool isVerified,
      String createdAt,
      String updatedAt,
      List<String> interests,
      Map<String, String>? settings});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? role = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? reelsCount = null,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? interests = null,
    Object? settings = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reelsCount: null == reelsCount
          ? _value.reelsCount
          : reelsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      required this.username,
      required this.displayName,
      this.profileImageUrl,
      this.bio,
      this.role = 'user',
      this.followersCount = 0,
      this.followingCount = 0,
      this.reelsCount = 0,
      this.isVerified = false,
      required this.createdAt,
      required this.updatedAt,
      final List<String> interests = const [],
      final Map<String, String>? settings})
      : _interests = interests,
        _settings = settings;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  @JsonKey()
  final String role;
// user | promoter | admin
  @override
  @JsonKey()
  final int followersCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @JsonKey()
  final int reelsCount;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  final List<String> _interests;
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  final Map<String, String>? _settings;
  @override
  Map<String, String>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, displayName: $displayName, profileImageUrl: $profileImageUrl, bio: $bio, role: $role, followersCount: $followersCount, followingCount: $followingCount, reelsCount: $reelsCount, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt, interests: $interests, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.reelsCount, reelsCount) ||
                other.reelsCount == reelsCount) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      username,
      displayName,
      profileImageUrl,
      bio,
      role,
      followersCount,
      followingCount,
      reelsCount,
      isVerified,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_interests),
      const DeepCollectionEquality().hash(_settings));

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String email,
      required final String username,
      required final String displayName,
      final String? profileImageUrl,
      final String? bio,
      final String role,
      final int followersCount,
      final int followingCount,
      final int reelsCount,
      final bool isVerified,
      required final String createdAt,
      required final String updatedAt,
      final List<String> interests,
      final Map<String, String>? settings}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  String get role; // user | promoter | admin
  @override
  int get followersCount;
  @override
  int get followingCount;
  @override
  int get reelsCount;
  @override
  bool get isVerified;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  List<String> get interests;
  @override
  Map<String, String>? get settings;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$LoginRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.email, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String email,
      required final String password}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String email, String password, String username, String displayName});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? username = null,
    Object? displayName = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email, String password, String username, String displayName});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? username = null,
    Object? displayName = null,
  }) {
    return _then(_$RegisterRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.email,
      required this.password,
      required this.username,
      required this.displayName});

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String username;
  @override
  final String displayName;

  @override
  String toString() {
    return 'RegisterRequest(email: $email, password: $password, username: $username, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, username, displayName);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String email,
      required final String password,
      required final String username,
      required final String displayName}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String get username;
  @override
  String get displayName;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PasswordResetRequest _$PasswordResetRequestFromJson(Map<String, dynamic> json) {
  return _PasswordResetRequest.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetRequest {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this PasswordResetRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordResetRequestCopyWith<PasswordResetRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetRequestCopyWith<$Res> {
  factory $PasswordResetRequestCopyWith(PasswordResetRequest value,
          $Res Function(PasswordResetRequest) then) =
      _$PasswordResetRequestCopyWithImpl<$Res, PasswordResetRequest>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$PasswordResetRequestCopyWithImpl<$Res,
        $Val extends PasswordResetRequest>
    implements $PasswordResetRequestCopyWith<$Res> {
  _$PasswordResetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetRequestImplCopyWith<$Res>
    implements $PasswordResetRequestCopyWith<$Res> {
  factory _$$PasswordResetRequestImplCopyWith(_$PasswordResetRequestImpl value,
          $Res Function(_$PasswordResetRequestImpl) then) =
      __$$PasswordResetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$PasswordResetRequestImplCopyWithImpl<$Res>
    extends _$PasswordResetRequestCopyWithImpl<$Res, _$PasswordResetRequestImpl>
    implements _$$PasswordResetRequestImplCopyWith<$Res> {
  __$$PasswordResetRequestImplCopyWithImpl(_$PasswordResetRequestImpl _value,
      $Res Function(_$PasswordResetRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$PasswordResetRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetRequestImpl implements _PasswordResetRequest {
  const _$PasswordResetRequestImpl({required this.email});

  factory _$PasswordResetRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetRequestImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'PasswordResetRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith =>
          __$$PasswordResetRequestImplCopyWithImpl<_$PasswordResetRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetRequestImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetRequest implements PasswordResetRequest {
  const factory _PasswordResetRequest({required final String email}) =
      _$PasswordResetRequestImpl;

  factory _PasswordResetRequest.fromJson(Map<String, dynamic> json) =
      _$PasswordResetRequestImpl.fromJson;

  @override
  String get email;

  /// Create a copy of PasswordResetRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PasswordResetConfirm _$PasswordResetConfirmFromJson(Map<String, dynamic> json) {
  return _PasswordResetConfirm.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetConfirm {
  String get token => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this PasswordResetConfirm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordResetConfirm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordResetConfirmCopyWith<PasswordResetConfirm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetConfirmCopyWith<$Res> {
  factory $PasswordResetConfirmCopyWith(PasswordResetConfirm value,
          $Res Function(PasswordResetConfirm) then) =
      _$PasswordResetConfirmCopyWithImpl<$Res, PasswordResetConfirm>;
  @useResult
  $Res call({String token, String newPassword});
}

/// @nodoc
class _$PasswordResetConfirmCopyWithImpl<$Res,
        $Val extends PasswordResetConfirm>
    implements $PasswordResetConfirmCopyWith<$Res> {
  _$PasswordResetConfirmCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordResetConfirm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetConfirmImplCopyWith<$Res>
    implements $PasswordResetConfirmCopyWith<$Res> {
  factory _$$PasswordResetConfirmImplCopyWith(_$PasswordResetConfirmImpl value,
          $Res Function(_$PasswordResetConfirmImpl) then) =
      __$$PasswordResetConfirmImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String newPassword});
}

/// @nodoc
class __$$PasswordResetConfirmImplCopyWithImpl<$Res>
    extends _$PasswordResetConfirmCopyWithImpl<$Res, _$PasswordResetConfirmImpl>
    implements _$$PasswordResetConfirmImplCopyWith<$Res> {
  __$$PasswordResetConfirmImplCopyWithImpl(_$PasswordResetConfirmImpl _value,
      $Res Function(_$PasswordResetConfirmImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordResetConfirm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? newPassword = null,
  }) {
    return _then(_$PasswordResetConfirmImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetConfirmImpl implements _PasswordResetConfirm {
  const _$PasswordResetConfirmImpl(
      {required this.token, required this.newPassword});

  factory _$PasswordResetConfirmImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetConfirmImplFromJson(json);

  @override
  final String token;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'PasswordResetConfirm(token: $token, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetConfirmImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, newPassword);

  /// Create a copy of PasswordResetConfirm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetConfirmImplCopyWith<_$PasswordResetConfirmImpl>
      get copyWith =>
          __$$PasswordResetConfirmImplCopyWithImpl<_$PasswordResetConfirmImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetConfirmImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetConfirm implements PasswordResetConfirm {
  const factory _PasswordResetConfirm(
      {required final String token,
      required final String newPassword}) = _$PasswordResetConfirmImpl;

  factory _PasswordResetConfirm.fromJson(Map<String, dynamic> json) =
      _$PasswordResetConfirmImpl.fromJson;

  @override
  String get token;
  @override
  String get newPassword;

  /// Create a copy of PasswordResetConfirm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordResetConfirmImplCopyWith<_$PasswordResetConfirmImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GoogleSignInRequest _$GoogleSignInRequestFromJson(Map<String, dynamic> json) {
  return _GoogleSignInRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleSignInRequest {
  String get idToken => throw _privateConstructorUsedError;

  /// Serializes this GoogleSignInRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleSignInRequestCopyWith<GoogleSignInRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleSignInRequestCopyWith<$Res> {
  factory $GoogleSignInRequestCopyWith(
          GoogleSignInRequest value, $Res Function(GoogleSignInRequest) then) =
      _$GoogleSignInRequestCopyWithImpl<$Res, GoogleSignInRequest>;
  @useResult
  $Res call({String idToken});
}

/// @nodoc
class _$GoogleSignInRequestCopyWithImpl<$Res, $Val extends GoogleSignInRequest>
    implements $GoogleSignInRequestCopyWith<$Res> {
  _$GoogleSignInRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
  }) {
    return _then(_value.copyWith(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleSignInRequestImplCopyWith<$Res>
    implements $GoogleSignInRequestCopyWith<$Res> {
  factory _$$GoogleSignInRequestImplCopyWith(_$GoogleSignInRequestImpl value,
          $Res Function(_$GoogleSignInRequestImpl) then) =
      __$$GoogleSignInRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String idToken});
}

/// @nodoc
class __$$GoogleSignInRequestImplCopyWithImpl<$Res>
    extends _$GoogleSignInRequestCopyWithImpl<$Res, _$GoogleSignInRequestImpl>
    implements _$$GoogleSignInRequestImplCopyWith<$Res> {
  __$$GoogleSignInRequestImplCopyWithImpl(_$GoogleSignInRequestImpl _value,
      $Res Function(_$GoogleSignInRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoogleSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
  }) {
    return _then(_$GoogleSignInRequestImpl(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleSignInRequestImpl implements _GoogleSignInRequest {
  const _$GoogleSignInRequestImpl({required this.idToken});

  factory _$GoogleSignInRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleSignInRequestImplFromJson(json);

  @override
  final String idToken;

  @override
  String toString() {
    return 'GoogleSignInRequest(idToken: $idToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleSignInRequestImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idToken);

  /// Create a copy of GoogleSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleSignInRequestImplCopyWith<_$GoogleSignInRequestImpl> get copyWith =>
      __$$GoogleSignInRequestImplCopyWithImpl<_$GoogleSignInRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleSignInRequestImplToJson(
      this,
    );
  }
}

abstract class _GoogleSignInRequest implements GoogleSignInRequest {
  const factory _GoogleSignInRequest({required final String idToken}) =
      _$GoogleSignInRequestImpl;

  factory _GoogleSignInRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleSignInRequestImpl.fromJson;

  @override
  String get idToken;

  /// Create a copy of GoogleSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleSignInRequestImplCopyWith<_$GoogleSignInRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FacebookSignInRequest _$FacebookSignInRequestFromJson(
    Map<String, dynamic> json) {
  return _FacebookSignInRequest.fromJson(json);
}

/// @nodoc
mixin _$FacebookSignInRequest {
  String get accessToken => throw _privateConstructorUsedError;

  /// Serializes this FacebookSignInRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacebookSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacebookSignInRequestCopyWith<FacebookSignInRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookSignInRequestCopyWith<$Res> {
  factory $FacebookSignInRequestCopyWith(FacebookSignInRequest value,
          $Res Function(FacebookSignInRequest) then) =
      _$FacebookSignInRequestCopyWithImpl<$Res, FacebookSignInRequest>;
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class _$FacebookSignInRequestCopyWithImpl<$Res,
        $Val extends FacebookSignInRequest>
    implements $FacebookSignInRequestCopyWith<$Res> {
  _$FacebookSignInRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacebookSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FacebookSignInRequestImplCopyWith<$Res>
    implements $FacebookSignInRequestCopyWith<$Res> {
  factory _$$FacebookSignInRequestImplCopyWith(
          _$FacebookSignInRequestImpl value,
          $Res Function(_$FacebookSignInRequestImpl) then) =
      __$$FacebookSignInRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken});
}

/// @nodoc
class __$$FacebookSignInRequestImplCopyWithImpl<$Res>
    extends _$FacebookSignInRequestCopyWithImpl<$Res,
        _$FacebookSignInRequestImpl>
    implements _$$FacebookSignInRequestImplCopyWith<$Res> {
  __$$FacebookSignInRequestImplCopyWithImpl(_$FacebookSignInRequestImpl _value,
      $Res Function(_$FacebookSignInRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacebookSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
  }) {
    return _then(_$FacebookSignInRequestImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FacebookSignInRequestImpl implements _FacebookSignInRequest {
  const _$FacebookSignInRequestImpl({required this.accessToken});

  factory _$FacebookSignInRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookSignInRequestImplFromJson(json);

  @override
  final String accessToken;

  @override
  String toString() {
    return 'FacebookSignInRequest(accessToken: $accessToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookSignInRequestImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken);

  /// Create a copy of FacebookSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacebookSignInRequestImplCopyWith<_$FacebookSignInRequestImpl>
      get copyWith => __$$FacebookSignInRequestImplCopyWithImpl<
          _$FacebookSignInRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookSignInRequestImplToJson(
      this,
    );
  }
}

abstract class _FacebookSignInRequest implements FacebookSignInRequest {
  const factory _FacebookSignInRequest({required final String accessToken}) =
      _$FacebookSignInRequestImpl;

  factory _FacebookSignInRequest.fromJson(Map<String, dynamic> json) =
      _$FacebookSignInRequestImpl.fromJson;

  @override
  String get accessToken;

  /// Create a copy of FacebookSignInRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacebookSignInRequestImplCopyWith<_$FacebookSignInRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
