import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class ReportRemoteDataSource {
  ReportRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<void> createPostReport({
    required String postId,
    required String reason,
    String? description,
  }) async {
    await _dio.post(
      '/api/reports',
      data: <String, dynamic>{
        'target_type': 'post',
        'target_id': postId,
        'reason': reason,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
      },
    );
  }
}
