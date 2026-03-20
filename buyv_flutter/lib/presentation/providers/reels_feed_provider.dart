import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/post_event_bus.dart';
import '../../data/datasources/remote/post_remote_data_source.dart';
import '../../data/models/post_models.dart';

class ReelsFeedState {
  const ReelsFeedState({
    this.posts = const <PostModel>[],
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isPaginating = false,
    this.hasMore = true,
    this.offset = 0,
    this.errorMessage,
  });

  final List<PostModel> posts;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isPaginating;
  final bool hasMore;
  final int offset;
  final String? errorMessage;

  ReelsFeedState copyWith({
    List<PostModel>? posts,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isPaginating,
    bool? hasMore,
    int? offset,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReelsFeedState(
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ReelsFeedNotifier extends Notifier<ReelsFeedState> {
  static const int _pageSize = 10;

  late final PostRemoteDataSource _dataSource;
  StreamSubscription<PostDeleted>? _postDeletedSub;

  @override
  ReelsFeedState build() {
    _dataSource = PostRemoteDataSource();
    _subscribeToPostEvents();
    Future<void>.microtask(loadInitial);
    ref.onDispose(_dispose);
    return const ReelsFeedState();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isInitialLoading: true, clearError: true);
    try {
      final posts = await _dataSource.getFeed(offset: 0, limit: _pageSize);
      state = state.copyWith(
        posts: posts,
        isInitialLoading: false,
        offset: posts.length,
        hasMore: posts.length == _pageSize,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: 'Impossible de charger le feed reels.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) {
      return;
    }

    state = state.copyWith(isRefreshing: true, clearError: true);
    try {
      final posts = await _dataSource.getFeed(offset: 0, limit: _pageSize);
      state = state.copyWith(
        posts: posts,
        isRefreshing: false,
        offset: posts.length,
        hasMore: posts.length == _pageSize,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'Echec du rafraichissement du feed reels.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isPaginating || !state.hasMore || state.posts.isEmpty) {
      return;
    }

    state = state.copyWith(isPaginating: true, clearError: true);
    try {
      final nextPosts = await _dataSource.getFeed(
        offset: state.offset,
        limit: _pageSize,
      );

      state = state.copyWith(
        posts: <PostModel>[...state.posts, ...nextPosts],
        isPaginating: false,
        offset: state.offset + nextPosts.length,
        hasMore: nextPosts.length == _pageSize,
      );
    } catch (_) {
      state = state.copyWith(
        isPaginating: false,
        errorMessage: 'Echec du chargement des reels suivants.',
      );
    }
  }

  Future<void> toggleLike(PostModel post) async {
    final index = state.posts.indexWhere((item) => item.id == post.id);
    if (index < 0) {
      return;
    }

    final updatedPosts = <PostModel>[...state.posts];
    final toggled = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    updatedPosts[index] = toggled;
    state = state.copyWith(posts: updatedPosts, clearError: true);

    try {
      if (toggled.isLiked) {
        await _dataSource.likePost(post.id);
      } else {
        await _dataSource.unlikePost(post.id);
      }
      PostEventBus.emit(PostLikeToggled(post.id, toggled.isLiked));
    } catch (_) {
      updatedPosts[index] = post;
      state = state.copyWith(
        posts: updatedPosts,
        errorMessage: 'Action like indisponible pour le moment.',
      );
    }
  }

  Future<void> deletePost(String postId) async {
    final previous = state.posts;
    state = state.copyWith(
      posts: previous.where((post) => post.id != postId).toList(growable: false),
      clearError: true,
    );

    try {
      await _dataSource.deletePost(postId);
      PostEventBus.emit(PostDeleted(postId));
    } catch (_) {
      state = state.copyWith(
        posts: previous,
        errorMessage: 'Suppression impossible pour le moment.',
      );
    }
  }

  Future<bool> updatePostCaption(String postId, String? caption) async {
    final index = state.posts.indexWhere((post) => post.id == postId);
    if (index < 0) {
      return false;
    }

    final previous = state.posts[index];
    final normalized = caption?.trim();
    final optimistic = previous.copyWith(
      caption: (normalized == null || normalized.isEmpty) ? null : normalized,
    );

    final updated = <PostModel>[...state.posts];
    updated[index] = optimistic;
    state = state.copyWith(posts: updated, clearError: true);

    try {
      final serverPost = await _dataSource.updateCaption(postId, normalized);
      final synced = <PostModel>[...state.posts];
      final syncedIndex = synced.indexWhere((post) => post.id == postId);
      if (syncedIndex >= 0) {
        synced[syncedIndex] = serverPost;
        state = state.copyWith(posts: synced, clearError: true);
      }
      return true;
    } catch (_) {
      final rollback = <PostModel>[...state.posts];
      final rollbackIndex = rollback.indexWhere((post) => post.id == postId);
      if (rollbackIndex >= 0) {
        rollback[rollbackIndex] = previous;
      }
      state = state.copyWith(
        posts: rollback,
        errorMessage: 'Edition impossible pour le moment.',
      );
      return false;
    }
  }

  void applyCommentsCountDelta(String postId, int delta) {
    if (delta == 0) {
      return;
    }

    final index = state.posts.indexWhere((post) => post.id == postId);
    if (index < 0) {
      return;
    }

    final updated = <PostModel>[...state.posts];
    final post = updated[index];
    final nextCount = post.commentsCount + delta;
    updated[index] = post.copyWith(commentsCount: nextCount < 0 ? 0 : nextCount);
    state = state.copyWith(posts: updated);
  }

  void applySharesCountDelta(String postId, int delta) {
    if (delta == 0) {
      return;
    }

    final index = state.posts.indexWhere((post) => post.id == postId);
    if (index < 0) {
      return;
    }

    final updated = <PostModel>[...state.posts];
    final post = updated[index];
    final nextCount = post.sharesCount + delta;
    updated[index] = post.copyWith(sharesCount: nextCount < 0 ? 0 : nextCount);
    state = state.copyWith(posts: updated);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _subscribeToPostEvents() {
    _postDeletedSub = PostEventBus.onDeleted.listen((event) {
      final filtered = state.posts
          .where((post) => post.id != event.postId)
          .toList(growable: false);
      if (filtered.length != state.posts.length) {
        state = state.copyWith(posts: filtered);
      }
    });
  }

  void _dispose() {
    _postDeletedSub?.cancel();
  }
}

final reelsFeedProvider = NotifierProvider<ReelsFeedNotifier, ReelsFeedState>(
  ReelsFeedNotifier.new,
);
