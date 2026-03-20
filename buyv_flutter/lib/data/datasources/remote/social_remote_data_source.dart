import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/auth_models.dart';

class SocialListUser {
  const SocialListUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profileImageUrl,
    required this.isVerified,
  });

  final String id;
  final String username;
  final String displayName;
  final String? profileImageUrl;
  final bool isVerified;
}

class FollowStatus {
  const FollowStatus({
    required this.isFollowing,
    required this.isFollowedBy,
  });

  final bool isFollowing;
  final bool isFollowedBy;
}

class BlockedUserEntry {
  const BlockedUserEntry({
    required this.id,
    required this.blockedUid,
    required this.blockedUsername,
    required this.blockedDisplayName,
    required this.blockedProfileImage,
    required this.createdAt,
  });

  final int id;
  final String blockedUid;
  final String blockedUsername;
  final String blockedDisplayName;
  final String? blockedProfileImage;
  final String createdAt;
}

class SocialRemoteDataSource {
  SocialRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<List<UserModel>> searchUsers(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const <UserModel>[];
    }

    final response = await _dio.get(
      '/users/search',
      queryParameters: <String, dynamic>{
        'q': trimmed,
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data;
    if (data is! List) {
      return const <UserModel>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(_mapUser)
        .toList(growable: false);
  }

  Future<UserModel> getUser(String userId) async {
    final response = await _dio.get('/users/$userId');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid user response.');
    }
    return _mapUser(data);
  }

  Future<FollowStatus> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final response = await _dio.get('/users/$currentUserId/follow-status/$targetUserId');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const FollowStatus(isFollowing: false, isFollowedBy: false);
    }
    return FollowStatus(
      isFollowing: _asBool(data['isFollowing']),
      isFollowedBy: _asBool(data['isFollowedBy']),
    );
  }

  Future<void> follow({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await _dio.post('/users/$currentUserId/follow/$targetUserId');
  }

  Future<void> unfollow({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await _dio.delete('/users/$currentUserId/unfollow/$targetUserId');
  }

  Future<List<SocialListUser>> getFollowers(String userId) async {
    final response = await _dio.get('/users/$userId/followers');
    return _mapSocialListUsers(response.data);
  }

  Future<List<SocialListUser>> getFollowing(String userId) async {
    final response = await _dio.get('/users/$userId/following');
    return _mapSocialListUsers(response.data);
  }

  Future<List<BlockedUserEntry>> getBlockedUsers() async {
    final response = await _dio.get('/api/users/me/blocked');
    final data = response.data;
    if (data is! List) {
      return const <BlockedUserEntry>[];
    }

    return data.whereType<Map<String, dynamic>>().map((item) {
      return BlockedUserEntry(
        id: _asInt(item['id']),
        blockedUid: _asString(item['blockedUid'], fallback: _asString(item['blocked_uid'])),
        blockedUsername: _asString(
          item['blockedUsername'],
          fallback: _asString(item['blocked_username']),
        ),
        blockedDisplayName: _asString(
          item['blockedDisplayName'],
          fallback: _asString(item['blocked_display_name']),
        ),
        blockedProfileImage: _nullableString(
          item['blockedProfileImage'] ?? item['blocked_profile_image'],
        ),
        createdAt: _asString(item['createdAt'], fallback: _asString(item['created_at'])),
      );
    }).toList(growable: false);
  }

  Future<void> blockUser(String userId) async {
    await _dio.post(
      '/api/users/me/blocked',
      data: <String, dynamic>{'userId': userId},
    );
  }

  Future<void> unblockUser(String userId) async {
    await _dio.delete('/api/users/me/blocked/$userId');
  }

  Future<bool> isBlocked(String userId) async {
    final response = await _dio.get('/api/users/me/blocked/$userId/status');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return false;
    }
    return _asBool(data['is_blocked'] ?? data['isBlocked']);
  }

  List<SocialListUser> _mapSocialListUsers(dynamic raw) {
    if (raw is! List) {
      return const <SocialListUser>[];
    }

    return raw.whereType<Map<String, dynamic>>().map((item) {
      return SocialListUser(
        id: _asString(item['id']),
        username: _asString(item['username']),
        displayName: _asString(item['displayName'], fallback: _asString(item['display_name'])),
        profileImageUrl: _nullableString(item['profileImageUrl'] ?? item['profile_image_url']),
        isVerified: _asBool(item['isVerified'] ?? item['is_verified']),
      );
    }).toList(growable: false);
  }

  UserModel _mapUser(Map<String, dynamic> raw) {
    return UserModel.fromJson(<String, dynamic>{
      'id': _asString(raw['id']),
      'email': _asString(raw['email']),
      'username': _asString(raw['username']),
      'displayName': _asString(raw['displayName'], fallback: _asString(raw['display_name'])),
      'profileImageUrl': _nullableString(raw['profileImageUrl'] ?? raw['profile_image_url']),
      'bio': _nullableString(raw['bio']),
      'role': _asString(raw['role'], fallback: 'user'),
      'followersCount': _asInt(raw['followersCount'], fallback: _asInt(raw['followers_count'])),
      'followingCount': _asInt(raw['followingCount'], fallback: _asInt(raw['following_count'])),
      'reelsCount': _asInt(raw['reelsCount'], fallback: _asInt(raw['reels_count'])),
      'isVerified': _asBool(raw['isVerified'] ?? raw['is_verified']),
      'createdAt': _asString(raw['createdAt'], fallback: _asString(raw['created_at'])),
      'updatedAt': _asString(raw['updatedAt'], fallback: _asString(raw['updated_at'])),
      'interests': _mapStringList(raw['interests']),
      'settings': _mapStringMap(raw['settings']),
    });
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static String? _nullableString(dynamic value) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? null : result;
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

  static List<String> _mapStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList(growable: false);
    }
    return const <String>[];
  }

  static Map<String, String>? _mapStringMap(dynamic value) {
    if (value is! Map) {
      return null;
    }
    final result = <String, String>{};
    for (final entry in value.entries) {
      result[entry.key.toString()] = entry.value?.toString() ?? '';
    }
    return result;
  }
}
