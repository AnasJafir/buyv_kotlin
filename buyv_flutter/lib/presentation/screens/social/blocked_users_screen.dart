import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/social_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedAsync = ref.watch(blockedUsersProvider);
    final socialAction = ref.watch(socialActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs bloques')),
      body: blockedAsync.when(
        data: (blockedUsers) {
          if (blockedUsers.isEmpty) {
            return const Center(child: Text('Aucun utilisateur bloque.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: blockedUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final blocked = blockedUsers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: blocked.blockedProfileImage?.isNotEmpty == true
                        ? NetworkImage(blocked.blockedProfileImage!)
                        : null,
                    child: blocked.blockedProfileImage?.isNotEmpty == true
                        ? null
                        : const Icon(Icons.person_outline),
                  ),
                  title: Text(blocked.blockedDisplayName),
                  subtitle: Text('@${blocked.blockedUsername}'),
                  trailing: OutlinedButton(
                    onPressed: socialAction.isLoading
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(socialActionProvider.notifier)
                                  .unblock(blocked.blockedUid);
                            } catch (error) {
                              if (context.mounted) {
                                showErrorSnackbar(context, error.toString());
                              }
                            }
                          },
                    child: const Text('Debloquer'),
                  ),
                  onTap: () => context.push(
                    AppRoutes.userProfile.replaceFirst(':userId', blocked.blockedUid),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }
}

