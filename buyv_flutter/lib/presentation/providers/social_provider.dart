import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/social_remote_data_source.dart';
import '../../data/models/auth_models.dart';
import 'auth_provider.dart';

final socialRemoteDataSourceProvider = Provider<SocialRemoteDataSource>((ref) {
  return SocialRemoteDataSource();
});

final socialUserSearchProvider =
    FutureProvider.family<List<UserModel>, String>((ref, query) async {
  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.searchUsers(query);
});

final socialUserProfileProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.getUser(userId);
});

final followStatusProvider = FutureProvider.family<FollowStatus?, String>((ref, targetUserId) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) {
    return null;
  }
  if (currentUser.id == targetUserId) {
    return const FollowStatus(isFollowing: false, isFollowedBy: false);
  }

  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.getFollowStatus(
    currentUserId: currentUser.id,
    targetUserId: targetUserId,
  );
});

final followersProvider = FutureProvider.family<List<SocialListUser>, String>((ref, userId) async {
  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.getFollowers(userId);
});

final followingProvider = FutureProvider.family<List<SocialListUser>, String>((ref, userId) async {
  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.getFollowing(userId);
});

final blockedUsersProvider = FutureProvider<List<BlockedUserEntry>>((ref) async {
  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.getBlockedUsers();
});

final blockedStatusProvider = FutureProvider.family<bool, String>((ref, targetUserId) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null || currentUser.id == targetUserId) {
    return false;
  }

  final dataSource = ref.watch(socialRemoteDataSourceProvider);
  return dataSource.isBlocked(targetUserId);
});

class SocialActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> follow(String targetUserId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      throw StateError('User not authenticated.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(socialRemoteDataSourceProvider);

    try {
      await dataSource.follow(currentUserId: currentUser.id, targetUserId: targetUserId);
      _refreshSocialState(currentUser.id, targetUserId);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> unfollow(String targetUserId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      throw StateError('User not authenticated.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(socialRemoteDataSourceProvider);

    try {
      await dataSource.unfollow(currentUserId: currentUser.id, targetUserId: targetUserId);
      _refreshSocialState(currentUser.id, targetUserId);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> block(String targetUserId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      throw StateError('User not authenticated.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(socialRemoteDataSourceProvider);

    try {
      await dataSource.blockUser(targetUserId);
      _refreshSocialState(currentUser.id, targetUserId);
      ref.invalidate(blockedUsersProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> unblock(String targetUserId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      throw StateError('User not authenticated.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(socialRemoteDataSourceProvider);

    try {
      await dataSource.unblockUser(targetUserId);
      _refreshSocialState(currentUser.id, targetUserId);
      ref.invalidate(blockedUsersProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  void _refreshSocialState(String currentUserId, String targetUserId) {
    ref.invalidate(followStatusProvider(targetUserId));
    ref.invalidate(blockedStatusProvider(targetUserId));
    ref.invalidate(socialUserProfileProvider(targetUserId));
    ref.invalidate(followersProvider(targetUserId));
    ref.invalidate(followingProvider(targetUserId));
    ref.invalidate(followersProvider(currentUserId));
    ref.invalidate(followingProvider(currentUserId));
  }
}

final socialActionProvider = AsyncNotifierProvider<SocialActionNotifier, void>(
  SocialActionNotifier.new,
);
