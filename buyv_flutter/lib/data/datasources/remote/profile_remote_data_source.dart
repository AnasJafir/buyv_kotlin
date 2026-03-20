import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/auth_models.dart';
import '../../models/post_models.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final String createdAt;
}

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<UserModel> updateProfile({
    required String userId,
    required String displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    final response = await _dio.put(
      '/users/$userId',
      data: <String, dynamic>{
        'displayName': displayName,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile update response.');
    }
    return UserModel.fromJson(data);
  }

  Future<List<PostModel>> getBookmarkedPosts() async {
    final response = await _dio.get('/posts/bookmarks');
    final data = response.data;
    if (data is! List) {
      return const <PostModel>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList(growable: false);
  }

  Future<void> unbookmarkPost(String postId) async {
    await _dio.delete('/posts/$postId/bookmark');
  }

  Future<List<AppNotification>> getMyNotifications() async {
    final response = await _dio.get('/notifications/me');
    final data = response.data;
    if (data is! List) {
      return const <AppNotification>[];
    }

    return data.whereType<Map<String, dynamic>>().map((item) {
      return AppNotification(
        id: _asInt(item['id']),
        title: _asString(item['title']),
        body: _asString(item['body']),
        type: _asString(item['type']),
        isRead: _asBool(item['isRead'] ?? item['is_read']),
        createdAt: _asString(item['createdAt'] ?? item['created_at']),
      );
    }).toList(growable: false);
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    await _dio.post('/notifications/$notificationId/read');
  }

  Future<void> deleteNotification(int notificationId) async {
    await _dio.delete('/notifications/$notificationId');
  }

  Future<void> clearNotifications() async {
    await _dio.delete('/notifications');
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().toLowerCase().trim();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
}
