import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_models.freezed.dart';
part 'post_models.g.dart';

// ── PostModel (maps to PostDto in KMP) ─────────────────────────────────────
@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String userId,
    required String username,
    String? displayName,
    String? userProfileImage,
    @Default(false) bool isUserVerified,
    required String type, // reel | product | photo
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int sharesCount,
    @Default(0) int viewsCount,
    required String createdAt,
    required String updatedAt,
    @Default(false) bool isLiked,
    @Default(false) bool isBookmarked,
    @Default(0.0) double duration,
    Map<String, String>? metadata,
    String? marketplaceProductUid,
    String? soundUid,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

// ── PostCreateRequest ───────────────────────────────────────────────────────
@freezed
class PostCreateRequest with _$PostCreateRequest {
  const factory PostCreateRequest({
    required String type,
    required String mediaUrl,
    String? caption,
    Map<String, String>? additionalData,
  }) = _PostCreateRequest;

  factory PostCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PostCreateRequestFromJson(json);
}

// ── Comment Model ───────────────────────────────────────────────────────────
@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required int id,
    required String userId,
    required String username,
    required String displayName,
    String? userProfileImage,
    required String postId,
    required String content,
    @Default(0) int likesCount,
    @Default(false) bool isLiked,
    required String createdAt,
    required String updatedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

// ── Sound Model ─────────────────────────────────────────────────────────────
@freezed
class SoundModel with _$SoundModel {
  const factory SoundModel({
    @Default(0) int id,
    @Default('') String uid,
    @Default('Original Sound') String title,
    @Default('Unknown') String artist,
    @Default('') String audioUrl,
    String? coverImageUrl,
    @Default(0.0) double duration,
    String? genre,
    @Default(0) int usageCount,
    @Default(false) bool isFeatured,
    @Default('') String createdAt,
  }) = _SoundModel;

  factory SoundModel.fromJson(Map<String, dynamic> json) =>
      _$SoundModelFromJson(json);
}
