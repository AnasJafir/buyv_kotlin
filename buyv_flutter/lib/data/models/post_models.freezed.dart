// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get userProfileImage => throw _privateConstructorUsedError;
  bool get isUserVerified => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // reel | product | photo
  String? get videoUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  int get sharesCount => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  bool get isBookmarked => throw _privateConstructorUsedError;
  double get duration => throw _privateConstructorUsedError;
  Map<String, String>? get metadata => throw _privateConstructorUsedError;
  String? get marketplaceProductUid => throw _privateConstructorUsedError;
  String? get soundUid => throw _privateConstructorUsedError;

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String username,
      String? displayName,
      String? userProfileImage,
      bool isUserVerified,
      String type,
      String? videoUrl,
      String? thumbnailUrl,
      String? caption,
      int likesCount,
      int commentsCount,
      int sharesCount,
      int viewsCount,
      String createdAt,
      String updatedAt,
      bool isLiked,
      bool isBookmarked,
      double duration,
      Map<String, String>? metadata,
      String? marketplaceProductUid,
      String? soundUid});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? userProfileImage = freezed,
    Object? isUserVerified = null,
    Object? type = null,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? viewsCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLiked = null,
    Object? isBookmarked = null,
    Object? duration = null,
    Object? metadata = freezed,
    Object? marketplaceProductUid = freezed,
    Object? soundUid = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isUserVerified: null == isUserVerified
          ? _value.isUserVerified
          : isUserVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isBookmarked: null == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      marketplaceProductUid: freezed == marketplaceProductUid
          ? _value.marketplaceProductUid
          : marketplaceProductUid // ignore: cast_nullable_to_non_nullable
              as String?,
      soundUid: freezed == soundUid
          ? _value.soundUid
          : soundUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String username,
      String? displayName,
      String? userProfileImage,
      bool isUserVerified,
      String type,
      String? videoUrl,
      String? thumbnailUrl,
      String? caption,
      int likesCount,
      int commentsCount,
      int sharesCount,
      int viewsCount,
      String createdAt,
      String updatedAt,
      bool isLiked,
      bool isBookmarked,
      double duration,
      Map<String, String>? metadata,
      String? marketplaceProductUid,
      String? soundUid});
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? userProfileImage = freezed,
    Object? isUserVerified = null,
    Object? type = null,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? viewsCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLiked = null,
    Object? isBookmarked = null,
    Object? duration = null,
    Object? metadata = freezed,
    Object? marketplaceProductUid = freezed,
    Object? soundUid = freezed,
  }) {
    return _then(_$PostModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isUserVerified: null == isUserVerified
          ? _value.isUserVerified
          : isUserVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isBookmarked: null == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      marketplaceProductUid: freezed == marketplaceProductUid
          ? _value.marketplaceProductUid
          : marketplaceProductUid // ignore: cast_nullable_to_non_nullable
              as String?,
      soundUid: freezed == soundUid
          ? _value.soundUid
          : soundUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {required this.id,
      required this.userId,
      required this.username,
      this.displayName,
      this.userProfileImage,
      this.isUserVerified = false,
      required this.type,
      this.videoUrl,
      this.thumbnailUrl,
      this.caption,
      this.likesCount = 0,
      this.commentsCount = 0,
      this.sharesCount = 0,
      this.viewsCount = 0,
      required this.createdAt,
      required this.updatedAt,
      this.isLiked = false,
      this.isBookmarked = false,
      this.duration = 0.0,
      final Map<String, String>? metadata,
      this.marketplaceProductUid,
      this.soundUid})
      : _metadata = metadata;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  final String? userProfileImage;
  @override
  @JsonKey()
  final bool isUserVerified;
  @override
  final String type;
// reel | product | photo
  @override
  final String? videoUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? caption;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final int sharesCount;
  @override
  @JsonKey()
  final int viewsCount;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  @JsonKey()
  final bool isBookmarked;
  @override
  @JsonKey()
  final double duration;
  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? marketplaceProductUid;
  @override
  final String? soundUid;

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, username: $username, displayName: $displayName, userProfileImage: $userProfileImage, isUserVerified: $isUserVerified, type: $type, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, likesCount: $likesCount, commentsCount: $commentsCount, sharesCount: $sharesCount, viewsCount: $viewsCount, createdAt: $createdAt, updatedAt: $updatedAt, isLiked: $isLiked, isBookmarked: $isBookmarked, duration: $duration, metadata: $metadata, marketplaceProductUid: $marketplaceProductUid, soundUid: $soundUid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.userProfileImage, userProfileImage) ||
                other.userProfileImage == userProfileImage) &&
            (identical(other.isUserVerified, isUserVerified) ||
                other.isUserVerified == isUserVerified) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.sharesCount, sharesCount) ||
                other.sharesCount == sharesCount) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isBookmarked, isBookmarked) ||
                other.isBookmarked == isBookmarked) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.marketplaceProductUid, marketplaceProductUid) ||
                other.marketplaceProductUid == marketplaceProductUid) &&
            (identical(other.soundUid, soundUid) ||
                other.soundUid == soundUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        username,
        displayName,
        userProfileImage,
        isUserVerified,
        type,
        videoUrl,
        thumbnailUrl,
        caption,
        likesCount,
        commentsCount,
        sharesCount,
        viewsCount,
        createdAt,
        updatedAt,
        isLiked,
        isBookmarked,
        duration,
        const DeepCollectionEquality().hash(_metadata),
        marketplaceProductUid,
        soundUid
      ]);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final String id,
      required final String userId,
      required final String username,
      final String? displayName,
      final String? userProfileImage,
      final bool isUserVerified,
      required final String type,
      final String? videoUrl,
      final String? thumbnailUrl,
      final String? caption,
      final int likesCount,
      final int commentsCount,
      final int sharesCount,
      final int viewsCount,
      required final String createdAt,
      required final String updatedAt,
      final bool isLiked,
      final bool isBookmarked,
      final double duration,
      final Map<String, String>? metadata,
      final String? marketplaceProductUid,
      final String? soundUid}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get username;
  @override
  String? get displayName;
  @override
  String? get userProfileImage;
  @override
  bool get isUserVerified;
  @override
  String get type; // reel | product | photo
  @override
  String? get videoUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get caption;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  int get sharesCount;
  @override
  int get viewsCount;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  bool get isLiked;
  @override
  bool get isBookmarked;
  @override
  double get duration;
  @override
  Map<String, String>? get metadata;
  @override
  String? get marketplaceProductUid;
  @override
  String? get soundUid;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostCreateRequest _$PostCreateRequestFromJson(Map<String, dynamic> json) {
  return _PostCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$PostCreateRequest {
  String get type => throw _privateConstructorUsedError;
  String get mediaUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  Map<String, String>? get additionalData => throw _privateConstructorUsedError;

  /// Serializes this PostCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCreateRequestCopyWith<PostCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCreateRequestCopyWith<$Res> {
  factory $PostCreateRequestCopyWith(
          PostCreateRequest value, $Res Function(PostCreateRequest) then) =
      _$PostCreateRequestCopyWithImpl<$Res, PostCreateRequest>;
  @useResult
  $Res call(
      {String type,
      String mediaUrl,
      String? caption,
      Map<String, String>? additionalData});
}

/// @nodoc
class _$PostCreateRequestCopyWithImpl<$Res, $Val extends PostCreateRequest>
    implements $PostCreateRequestCopyWith<$Res> {
  _$PostCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? mediaUrl = null,
    Object? caption = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostCreateRequestImplCopyWith<$Res>
    implements $PostCreateRequestCopyWith<$Res> {
  factory _$$PostCreateRequestImplCopyWith(_$PostCreateRequestImpl value,
          $Res Function(_$PostCreateRequestImpl) then) =
      __$$PostCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String mediaUrl,
      String? caption,
      Map<String, String>? additionalData});
}

/// @nodoc
class __$$PostCreateRequestImplCopyWithImpl<$Res>
    extends _$PostCreateRequestCopyWithImpl<$Res, _$PostCreateRequestImpl>
    implements _$$PostCreateRequestImplCopyWith<$Res> {
  __$$PostCreateRequestImplCopyWithImpl(_$PostCreateRequestImpl _value,
      $Res Function(_$PostCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? mediaUrl = null,
    Object? caption = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(_$PostCreateRequestImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCreateRequestImpl implements _PostCreateRequest {
  const _$PostCreateRequestImpl(
      {required this.type,
      required this.mediaUrl,
      this.caption,
      final Map<String, String>? additionalData})
      : _additionalData = additionalData;

  factory _$PostCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCreateRequestImplFromJson(json);

  @override
  final String type;
  @override
  final String mediaUrl;
  @override
  final String? caption;
  final Map<String, String>? _additionalData;
  @override
  Map<String, String>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PostCreateRequest(type: $type, mediaUrl: $mediaUrl, caption: $caption, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCreateRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, mediaUrl, caption,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of PostCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCreateRequestImplCopyWith<_$PostCreateRequestImpl> get copyWith =>
      __$$PostCreateRequestImplCopyWithImpl<_$PostCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _PostCreateRequest implements PostCreateRequest {
  const factory _PostCreateRequest(
      {required final String type,
      required final String mediaUrl,
      final String? caption,
      final Map<String, String>? additionalData}) = _$PostCreateRequestImpl;

  factory _PostCreateRequest.fromJson(Map<String, dynamic> json) =
      _$PostCreateRequestImpl.fromJson;

  @override
  String get type;
  @override
  String get mediaUrl;
  @override
  String? get caption;
  @override
  Map<String, String>? get additionalData;

  /// Create a copy of PostCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostCreateRequestImplCopyWith<_$PostCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  int get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get userProfileImage => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
          CommentModel value, $Res Function(CommentModel) then) =
      _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call(
      {int id,
      String userId,
      String username,
      String displayName,
      String? userProfileImage,
      String postId,
      String content,
      int likesCount,
      bool isLiked,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? userProfileImage = freezed,
    Object? postId = null,
    Object? content = null,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
          _$CommentModelImpl value, $Res Function(_$CommentModelImpl) then) =
      __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String userId,
      String username,
      String displayName,
      String? userProfileImage,
      String postId,
      String content,
      int likesCount,
      bool isLiked,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
      _$CommentModelImpl _value, $Res Function(_$CommentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? userProfileImage = freezed,
    Object? postId = null,
    Object? content = null,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      userProfileImage: freezed == userProfileImage
          ? _value.userProfileImage
          : userProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl(
      {required this.id,
      required this.userId,
      required this.username,
      required this.displayName,
      this.userProfileImage,
      required this.postId,
      required this.content,
      this.likesCount = 0,
      this.isLiked = false,
      required this.createdAt,
      required this.updatedAt});

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  final int id;
  @override
  final String userId;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? userProfileImage;
  @override
  final String postId;
  @override
  final String content;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'CommentModel(id: $id, userId: $userId, username: $username, displayName: $displayName, userProfileImage: $userProfileImage, postId: $postId, content: $content, likesCount: $likesCount, isLiked: $isLiked, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.userProfileImage, userProfileImage) ||
                other.userProfileImage == userProfileImage) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      username,
      displayName,
      userProfileImage,
      postId,
      content,
      likesCount,
      isLiked,
      createdAt,
      updatedAt);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(
      this,
    );
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel(
      {required final int id,
      required final String userId,
      required final String username,
      required final String displayName,
      final String? userProfileImage,
      required final String postId,
      required final String content,
      final int likesCount,
      final bool isLiked,
      required final String createdAt,
      required final String updatedAt}) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  int get id;
  @override
  String get userId;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get userProfileImage;
  @override
  String get postId;
  @override
  String get content;
  @override
  int get likesCount;
  @override
  bool get isLiked;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SoundModel _$SoundModelFromJson(Map<String, dynamic> json) {
  return _SoundModel.fromJson(json);
}

/// @nodoc
mixin _$SoundModel {
  int get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get audioUrl => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  double get duration => throw _privateConstructorUsedError;
  String? get genre => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SoundModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SoundModelCopyWith<SoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundModelCopyWith<$Res> {
  factory $SoundModelCopyWith(
          SoundModel value, $Res Function(SoundModel) then) =
      _$SoundModelCopyWithImpl<$Res, SoundModel>;
  @useResult
  $Res call(
      {int id,
      String uid,
      String title,
      String artist,
      String audioUrl,
      String? coverImageUrl,
      double duration,
      String? genre,
      int usageCount,
      bool isFeatured,
      String createdAt});
}

/// @nodoc
class _$SoundModelCopyWithImpl<$Res, $Val extends SoundModel>
    implements $SoundModelCopyWith<$Res> {
  _$SoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? title = null,
    Object? artist = null,
    Object? audioUrl = null,
    Object? coverImageUrl = freezed,
    Object? duration = null,
    Object? genre = freezed,
    Object? usageCount = null,
    Object? isFeatured = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoundModelImplCopyWith<$Res>
    implements $SoundModelCopyWith<$Res> {
  factory _$$SoundModelImplCopyWith(
          _$SoundModelImpl value, $Res Function(_$SoundModelImpl) then) =
      __$$SoundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uid,
      String title,
      String artist,
      String audioUrl,
      String? coverImageUrl,
      double duration,
      String? genre,
      int usageCount,
      bool isFeatured,
      String createdAt});
}

/// @nodoc
class __$$SoundModelImplCopyWithImpl<$Res>
    extends _$SoundModelCopyWithImpl<$Res, _$SoundModelImpl>
    implements _$$SoundModelImplCopyWith<$Res> {
  __$$SoundModelImplCopyWithImpl(
      _$SoundModelImpl _value, $Res Function(_$SoundModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? title = null,
    Object? artist = null,
    Object? audioUrl = null,
    Object? coverImageUrl = freezed,
    Object? duration = null,
    Object? genre = freezed,
    Object? usageCount = null,
    Object? isFeatured = null,
    Object? createdAt = null,
  }) {
    return _then(_$SoundModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoundModelImpl implements _SoundModel {
  const _$SoundModelImpl(
      {this.id = 0,
      this.uid = '',
      this.title = 'Original Sound',
      this.artist = 'Unknown',
      this.audioUrl = '',
      this.coverImageUrl,
      this.duration = 0.0,
      this.genre,
      this.usageCount = 0,
      this.isFeatured = false,
      this.createdAt = ''});

  factory _$SoundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoundModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String artist;
  @override
  @JsonKey()
  final String audioUrl;
  @override
  final String? coverImageUrl;
  @override
  @JsonKey()
  final double duration;
  @override
  final String? genre;
  @override
  @JsonKey()
  final int usageCount;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final String createdAt;

  @override
  String toString() {
    return 'SoundModel(id: $id, uid: $uid, title: $title, artist: $artist, audioUrl: $audioUrl, coverImageUrl: $coverImageUrl, duration: $duration, genre: $genre, usageCount: $usageCount, isFeatured: $isFeatured, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoundModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, title, artist, audioUrl,
      coverImageUrl, duration, genre, usageCount, isFeatured, createdAt);

  /// Create a copy of SoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SoundModelImplCopyWith<_$SoundModelImpl> get copyWith =>
      __$$SoundModelImplCopyWithImpl<_$SoundModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoundModelImplToJson(
      this,
    );
  }
}

abstract class _SoundModel implements SoundModel {
  const factory _SoundModel(
      {final int id,
      final String uid,
      final String title,
      final String artist,
      final String audioUrl,
      final String? coverImageUrl,
      final double duration,
      final String? genre,
      final int usageCount,
      final bool isFeatured,
      final String createdAt}) = _$SoundModelImpl;

  factory _SoundModel.fromJson(Map<String, dynamic> json) =
      _$SoundModelImpl.fromJson;

  @override
  int get id;
  @override
  String get uid;
  @override
  String get title;
  @override
  String get artist;
  @override
  String get audioUrl;
  @override
  String? get coverImageUrl;
  @override
  double get duration;
  @override
  String? get genre;
  @override
  int get usageCount;
  @override
  bool get isFeatured;
  @override
  String get createdAt;

  /// Create a copy of SoundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SoundModelImplCopyWith<_$SoundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
