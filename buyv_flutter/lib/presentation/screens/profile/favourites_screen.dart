import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/common/error_snackbar.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkedPostsProvider);
    final action = ref.watch(profileActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: bookmarksAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('Aucun favori pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(bookmarkedPostsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: (post.thumbnailUrl?.isNotEmpty == true || post.videoUrl?.isNotEmpty == true)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post.thumbnailUrl?.isNotEmpty == true
                                  ? post.thumbnailUrl!
                                  : post.videoUrl!,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.bookmark),
                    title: Text(post.caption?.trim().isNotEmpty == true
                        ? post.caption!.trim()
                        : 'Post favori'),
                    subtitle: Text('@${post.username} • ${post.type}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove_outlined),
                      onPressed: action.isLoading
                          ? null
                          : () async {
                              try {
                                await ref.read(profileActionProvider.notifier).removeBookmark(post.id);
                              } catch (error) {
                                if (context.mounted) {
                                  showErrorSnackbar(context, error.toString());
                                }
                              }
                            },
                    ),
                    onTap: () {
                      if (post.marketplaceProductUid?.isNotEmpty == true) {
                        context.push('/marketplace/${post.marketplaceProductUid!}');
                      } else {
                        context.push('/social/user/${post.userId}');
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }
}

