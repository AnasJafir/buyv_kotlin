// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      userProfileImage: json['userProfileImage'] as String?,
      isUserVerified: json['isUserVerified'] as bool? ?? false,
      type: json['type'] as String,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      marketplaceProductUid: json['marketplaceProductUid'] as String?,
      soundUid: json['soundUid'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'userProfileImage': instance.userProfileImage,
      'isUserVerified': instance.isUserVerified,
      'type': instance.type,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'sharesCount': instance.sharesCount,
      'viewsCount': instance.viewsCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
      'duration': instance.duration,
      'metadata': instance.metadata,
      'marketplaceProductUid': instance.marketplaceProductUid,
      'soundUid': instance.soundUid,
    };

_$PostCreateRequestImpl _$$PostCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCreateRequestImpl(
      type: json['type'] as String,
      mediaUrl: json['mediaUrl'] as String,
      caption: json['caption'] as String?,
      additionalData: (json['additionalData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$PostCreateRequestImplToJson(
        _$PostCreateRequestImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'mediaUrl': instance.mediaUrl,
      'caption': instance.caption,
      'additionalData': instance.additionalData,
    };

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      userProfileImage: json['userProfileImage'] as String?,
      postId: json['postId'] as String,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'userProfileImage': instance.userProfileImage,
      'postId': instance.postId,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$SoundModelImpl _$$SoundModelImplFromJson(Map<String, dynamic> json) =>
    _$SoundModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? 'Original Sound',
      artist: json['artist'] as String? ?? 'Unknown',
      audioUrl: json['audioUrl'] as String? ?? '',
      coverImageUrl: json['coverImageUrl'] as String?,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      genre: json['genre'] as String?,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$SoundModelImplToJson(_$SoundModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'artist': instance.artist,
      'audioUrl': instance.audioUrl,
      'coverImageUrl': instance.coverImageUrl,
      'duration': instance.duration,
      'genre': instance.genre,
      'usageCount': instance.usageCount,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt,
    };
