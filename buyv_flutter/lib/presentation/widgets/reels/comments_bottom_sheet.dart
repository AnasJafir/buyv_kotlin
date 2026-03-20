import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/post_models.dart';
import '../../router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/marketplace_rating_provider.dart';
import '../../providers/reel_comments_provider.dart';

Future<int?> showCommentsBottomSheet(
  BuildContext context, {
  required PostModel post,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CommentsBottomSheet(post: post),
  );
}

class _CommentsBottomSheet extends ConsumerStatefulWidget {
  const _CommentsBottomSheet({required this.post});

  final PostModel post;

  @override
  ConsumerState<_CommentsBottomSheet> createState() =>
      _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends ConsumerState<_CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  int _commentsDelta = 0;
  int _selectedTab = 0;

  Map<int, int> _estimatedDistribution(double average, int count) {
    final distribution = <int, int>{
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };

    if (count <= 0) {
      return distribution;
    }

    final clampedAverage = average.clamp(1.0, 5.0);
    final lower = clampedAverage.floor();
    final upper = clampedAverage.ceil();

    if (lower == upper) {
      distribution[lower] = count;
      return distribution;
    }

    final ratioUpper = clampedAverage - lower;
    final upperCount = (count * ratioUpper).round();
    final lowerCount = count - upperCount;

    distribution[lower] = lowerCount;
    distribution[upper] = upperCount;
    return distribution;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelCommentsProvider(widget.post.id));
    final notifier = ref.read(reelCommentsProvider(widget.post.id).notifier);

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _selectedTab == 0 ? 'Commentaires' : 'Ratings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(_commentsDelta),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SegmentedButton<int>(
                    segments: const <ButtonSegment<int>>[
                      ButtonSegment<int>(
                        value: 0,
                        icon: Icon(Icons.comment_outlined),
                        label: Text('Commentaires'),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        icon: Icon(Icons.star_outline),
                        label: Text('Ratings'),
                      ),
                    ],
                    selected: <int>{_selectedTab},
                    onSelectionChanged: (Set<int> next) {
                      if (next.isNotEmpty) {
                        setState(() {
                          _selectedTab = next.first;
                        });
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _selectedTab == 0
                      ? _buildCommentsTab(
                          state: state,
                          notifier: notifier,
                          scrollController: scrollController,
                        )
                      : _buildRatingsTab(context, scrollController),
                ),
                if (_selectedTab == 0 && state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                if (_selectedTab == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 8,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Ajouter un commentaire...',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () async {
                                  final ok = await notifier.addComment(_controller.text);
                                  if (ok && mounted) {
                                    _controller.clear();
                                    setState(() {
                                      _commentsDelta += 1;
                                    });
                                  }
                                },
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Envoyer'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentsTab({
    required ReelCommentsState state,
    required ReelCommentsNotifier notifier,
    required ScrollController scrollController,
  }) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.comments.isEmpty) {
      return const Center(
        child: Text(
          'Aucun commentaire pour le moment.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        final comment = state.comments[index];
        final currentUserId = ref.watch(currentUserProvider)?.id;
        final canDelete = currentUserId != null && currentUserId == comment.userId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: comment.userProfileImage?.isNotEmpty == true
                ? NetworkImage(comment.userProfileImage!)
                : null,
            child: comment.userProfileImage?.isNotEmpty == true
                ? null
                : const Icon(Icons.person_outline),
          ),
          title: Text(
            comment.displayName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(comment.content),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => notifier.toggleLike(comment),
                icon: Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: comment.isLiked ? Colors.redAccent : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              Text(
                '${comment.likesCount}',
                style: const TextStyle(fontSize: 11),
              ),
              if (canDelete)
                InkWell(
                  onTap: () async {
                    final ok = await notifier.deleteComment(comment);
                    if (ok && mounted) {
                      setState(() {
                        _commentsDelta -= 1;
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Supprimer',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: state.comments.length,
    );
  }

  Widget _buildRatingsTab(BuildContext context, ScrollController scrollController) {
    final hasLinkedProduct = widget.post.marketplaceProductUid?.isNotEmpty == true;
    final productUid = widget.post.marketplaceProductUid;
    final ratingsAsync = hasLinkedProduct
        ? ref.watch(marketplaceRatingSummaryProvider(productUid!))
        : const AsyncData(null);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.info_outline, color: Colors.amber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasLinkedProduct
                      ? 'Les ratings sont charges depuis le produit lie quand les donnees sont disponibles.'
                      : 'Aucun produit lie a ce reel. Le panneau ratings reste disponible en mode informatif.',
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ratingsAsync.when(
          data: (summary) {
            final average = summary?.averageRating ?? 0.0;
            final count = summary?.ratingCount ?? 0;
            final rounded = average.clamp(0.0, 5.0);
            final distribution = _estimatedDistribution(rounded, count);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Apercu Ratings',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List<Widget>.generate(5, (index) {
                        final starPosition = index + 1;
                        final icon = rounded >= starPosition
                            ? Icons.star
                            : (rounded >= starPosition - 0.5
                                ? Icons.star_half
                                : Icons.star_border);
                        return Icon(
                          icon,
                          color: Colors.amber.shade600,
                          size: 22,
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      count > 0
                          ? 'Note moyenne: ${rounded.toStringAsFixed(1)}/5 sur $count avis.'
                          : 'Aucun avis disponible pour le moment.',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (count > 0) ...<Widget>[
                      const SizedBox(height: 14),
                      const Text(
                        'Distribution estimee',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List<Widget>.generate(5, (index) {
                        final star = 5 - index;
                        final value = distribution[star] ?? 0;
                        final ratio = count > 0 ? (value / count) : 0.0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 42,
                                child: Text('$star etoiles'),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: ratio,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber.shade600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '$value',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      const Text(
                        'Estimation calculee a partir de la note moyenne (pas encore d\'endpoint backend de details par avis).',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Chargement des ratings...'),
                ],
              ),
            ),
          ),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Impossible de recuperer les ratings pour le moment.',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (hasLinkedProduct)
          FilledButton.icon(
            onPressed: () {
              final productUid = widget.post.marketplaceProductUid!;
              Navigator.of(context).pop(_commentsDelta);
              context.push('/marketplace/$productUid');
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Voir le produit lie'),
          )
        else
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(_commentsDelta);
              context.push(AppRoutes.marketplace);
            },
            icon: const Icon(Icons.storefront_outlined),
            label: const Text('Explorer le marketplace'),
          ),
      ],
    );
  }
}
