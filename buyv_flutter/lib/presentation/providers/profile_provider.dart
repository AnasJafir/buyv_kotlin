import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/profile_remote_data_source.dart';
import '../../data/models/post_models.dart';
import 'auth_provider.dart';
import 'social_provider.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource();
});

final bookmarkedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return dataSource.getBookmarkedPosts();
});

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return dataSource.getMyNotifications();
});

class ProfileActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateProfile({
    required String displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw StateError('User not authenticated.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(profileRemoteDataSourceProvider);

    try {
      await dataSource.updateProfile(
        userId: user.id,
        displayName: displayName,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );
      ref.invalidate(authProvider);
      ref.invalidate(socialUserProfileProvider(user.id));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> removeBookmark(String postId) async {
    state = const AsyncLoading();
    final dataSource = ref.read(profileRemoteDataSourceProvider);

    try {
      await dataSource.unbookmarkPost(postId);
      ref.invalidate(bookmarkedPostsProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    state = const AsyncLoading();
    final dataSource = ref.read(profileRemoteDataSourceProvider);

    try {
      await dataSource.markNotificationAsRead(notificationId);
      ref.invalidate(notificationsProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    state = const AsyncLoading();
    final dataSource = ref.read(profileRemoteDataSourceProvider);

    try {
      await dataSource.deleteNotification(notificationId);
      ref.invalidate(notificationsProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> clearNotifications() async {
    state = const AsyncLoading();
    final dataSource = ref.read(profileRemoteDataSourceProvider);

    try {
      await dataSource.clearNotifications();
      ref.invalidate(notificationsProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final profileActionProvider = AsyncNotifierProvider<ProfileActionNotifier, void>(
  ProfileActionNotifier.new,
);
