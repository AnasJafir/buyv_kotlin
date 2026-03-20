import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global post event bus — replaces KMP's PostEventBus (PostEvent sealed class).
/// Used to sync post deletions/creations across screens (fixes Ghost Reels bug #12).
sealed class PostEvent {
  const PostEvent();
}

class PostDeleted extends PostEvent {
  final String postId;
  const PostDeleted(this.postId);
}

class PostCreated extends PostEvent {
  final String postId;
  const PostCreated(this.postId);
}

class PostLikeToggled extends PostEvent {
  final String postId;
  final bool isLiked;
  const PostLikeToggled(this.postId, this.isLiked);
}

// ── Global StreamController ─────────────────────────────────────────────────
final _postEventController = StreamController<PostEvent>.broadcast();

class PostEventBus {
  PostEventBus._();

  static Stream<PostEvent> get stream => _postEventController.stream;

  static void emit(PostEvent event) => _postEventController.add(event);

  static Stream<PostDeleted> get onDeleted =>
      stream.where((event) => event is PostDeleted).cast<PostDeleted>();

  static Stream<PostCreated> get onCreated =>
      stream.where((event) => event is PostCreated).cast<PostCreated>();
}

// Riverpod provider for listening to post events
final postEventBusProvider = StreamProvider<PostEvent>((ref) {
  return PostEventBus.stream;
});
