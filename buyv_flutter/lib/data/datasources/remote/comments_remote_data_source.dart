import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/post_models.dart';

class CommentsRemoteDataSource {
  CommentsRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<List<CommentModel>> getComments(
    String postId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/comments/$postId',
      queryParameters: <String, dynamic>{
        'limit': limit,
        'offset': offset,
      },
    );

    final raw = response.data;
    if (raw is! List) {
      return const <CommentModel>[];
    }

    return raw
        .whereType<Map<String, dynamic>>()
        .map(CommentModel.fromJson)
        .toList(growable: false);
  }

  Future<CommentModel> addComment(String postId, String content) async {
    final response = await _dio.post(
      '/comments/$postId',
      data: <String, dynamic>{'content': content},
    );

    return CommentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteComment(String postId, int commentId) async {
    await _dio.delete('/comments/$postId/$commentId');
  }

  Future<void> toggleLikeComment(String postId, int commentId) async {
    await _dio.post('/comments/$postId/$commentId/like');
  }
}
