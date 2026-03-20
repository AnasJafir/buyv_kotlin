import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/social_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(socialUserProfileProvider(userId));
    final authUser = ref.watch(currentUserProvider);
    final followStatusAsync = ref.watch(followStatusProvider(userId));
    final blockedStatusAsync = ref.watch(blockedStatusProvider(userId));
    final socialAction = ref.watch(socialActionProvider);

    Future<void> handleFollowToggle(bool isFollowing) async {
      if (authUser == null) {
        await showAuthRequiredSheet(context);
        return;
      }
      try {
        if (isFollowing) {
          await ref.read(socialActionProvider.notifier).unfollow(userId);
        } else {
          await ref.read(socialActionProvider.notifier).follow(userId);
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      }
    }

    Future<void> handleBlockToggle(bool isBlocked) async {
      if (authUser == null) {
        await showAuthRequiredSheet(context);
        return;
      }
      try {
        if (isBlocked) {
          await ref.read(socialActionProvider.notifier).unblock(userId);
        } else {
          await ref.read(socialActionProvider.notifier).block(userId);
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        data: (user) {
          final isMe = authUser?.id == user.id;
          final followStatus = followStatusAsync.value;
          final isFollowing = followStatus?.isFollowing ?? false;
          final isBlocked = blockedStatusAsync.value ?? false;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: user.profileImageUrl?.isNotEmpty == true
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                            child: user.profileImageUrl?.isNotEmpty == true
                                ? null
                                : const Icon(Icons.person_outline),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        user.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    if (user.isVerified)
                                      const Icon(Icons.verified, color: Colors.blue),
                                  ],
                                ),
                                Text('@${user.username}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (user.bio?.trim().isNotEmpty == true) ...<Widget>[
                        const SizedBox(height: 12),
                        Text(user.bio!.trim()),
                      ],
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          _CountChip(
                            label: 'Followers',
                            value: user.followersCount,
                            onTap: () => context.push(
                              '${AppRoutes.followList.replaceFirst(':userId', user.id)}?tab=0',
                            ),
                          ),
                          _CountChip(
                            label: 'Following',
                            value: user.followingCount,
                            onTap: () => context.push(
                              '${AppRoutes.followList.replaceFirst(':userId', user.id)}?tab=1',
                            ),
                          ),
                          _CountChip(label: 'Reels', value: user.reelsCount),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (!isMe)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: isFollowing
                            ? OutlinedButton.icon(
                                key: const ValueKey<String>('following'),
                                onPressed: socialAction.isLoading
                                    ? null
                                    : () => handleFollowToggle(true),
                                icon: socialAction.isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                label: const Text('Following'),
                              )
                            : FilledButton.icon(
                                key: const ValueKey<String>('follow'),
                                onPressed: socialAction.isLoading
                                    ? null
                                    : () => handleFollowToggle(false),
                                icon: socialAction.isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.person_add),
                                label: const Text('Follow'),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: socialAction.isLoading
                            ? null
                            : () => handleBlockToggle(isBlocked),
                        icon: Icon(isBlocked ? Icons.lock_open : Icons.block),
                        label: Text(isBlocked ? 'Debloquer' : 'Bloquer'),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$value $label'),
    );

    if (onTap == null) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: child,
    );
  }
}
