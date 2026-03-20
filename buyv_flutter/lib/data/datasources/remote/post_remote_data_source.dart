import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/post_models.dart';

/// Remote data source for posts/reels.
/// Mirrors the KMP PostApiService endpoints used by the feed.
class PostRemoteDataSource {
  PostRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<List<PostModel>> getFeed({int offset = 0, int limit = 20}) async {
    final response = await _dio.get(
      '/posts/feed',
      queryParameters: <String, dynamic>{
        'offset': offset,
        'limit': limit,
      },
    );

    final raw = response.data;
    if (raw is! List) {
      return const <PostModel>[];
    }

    return raw
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList(growable: false);
  }

  Future<void> likePost(String postId) async {
    await _dio.post('/posts/$postId/like');
  }

  Future<void> unlikePost(String postId) async {
    await _dio.delete('/posts/$postId/like');
  }

  Future<void> deletePost(String postId) async {
    await _dio.delete('/posts/$postId');
  }

  Future<PostModel> updateCaption(String postId, String? caption) async {
    final response = await _dio.patch(
      '/posts/$postId',
      data: <String, dynamic>{'caption': caption},
    );
    return PostModel.fromJson(response.data as Map<String, dynamic>);
  }
}
