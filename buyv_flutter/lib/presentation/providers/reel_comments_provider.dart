import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/comments_remote_data_source.dart';
import '../../data/models/post_models.dart';

class ReelCommentsState {
  const ReelCommentsState({
    this.comments = const <CommentModel>[],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<CommentModel> comments;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  ReelCommentsState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReelCommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ReelCommentsNotifier extends FamilyNotifier<ReelCommentsState, String> {
  late final CommentsRemoteDataSource _dataSource;

  @override
  ReelCommentsState build(String postId) {
    _dataSource = CommentsRemoteDataSource();
    Future<void>.microtask(load);
    return const ReelCommentsState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final comments = await _dataSource.getComments(arg, limit: 50, offset: 0);
      state = state.copyWith(
        comments: comments,
        isLoading: false,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger les commentaires.',
      );
    }
  }

  Future<bool> addComment(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final created = await _dataSource.addComment(arg, trimmed);
      state = state.copyWith(
        comments: <CommentModel>[created, ...state.comments],
        isSubmitting: false,
        clearError: true,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Impossible d\'ajouter le commentaire.',
      );
      return false;
    }
  }

  Future<void> toggleLike(CommentModel comment) async {
    final index = state.comments.indexWhere((c) => c.id == comment.id);
    if (index < 0) {
      return;
    }

    final updated = <CommentModel>[...state.comments];
    final toggled = comment.copyWith(
      isLiked: !comment.isLiked,
      likesCount: comment.isLiked ? comment.likesCount - 1 : comment.likesCount + 1,
    );
    updated[index] = toggled;
    state = state.copyWith(comments: updated, clearError: true);

    try {
      await _dataSource.toggleLikeComment(arg, comment.id);
    } catch (_) {
      updated[index] = comment;
      state = state.copyWith(
        comments: updated,
        errorMessage: 'Action indisponible pour le moment.',
      );
    }
  }

  Future<bool> deleteComment(CommentModel comment) async {
    final index = state.comments.indexWhere((c) => c.id == comment.id);
    if (index < 0) {
      return false;
    }

    final updated = <CommentModel>[...state.comments]..removeAt(index);
    state = state.copyWith(comments: updated, clearError: true);

    try {
      await _dataSource.deleteComment(arg, comment.id);
      return true;
    } catch (_) {
      final rollback = <CommentModel>[...updated]..insert(index, comment);
      state = state.copyWith(
        comments: rollback,
        errorMessage: 'Impossible de supprimer le commentaire.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final reelCommentsProvider = NotifierProvider.family<
    ReelCommentsNotifier,
    ReelCommentsState,
    String>(
  ReelCommentsNotifier.new,
);
