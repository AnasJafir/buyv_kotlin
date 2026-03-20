import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/social_provider.dart';
import '../../router/app_router.dart';

class UserSearchScreen extends ConsumerStatefulWidget {
  const UserSearchScreen({super.key});

  @override
  ConsumerState<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends ConsumerState<UserSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = _query.trim();
    final usersAsync = ref.watch(socialUserSearchProvider(trimmed));

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche utilisateurs')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Nom, pseudo, mot-cle...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => setState(() => _query = _queryController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (trimmed.isEmpty) {
                  return const Center(
                    child: Text('Saisis un nom ou pseudo pour rechercher.'),
                  );
                }
                if (users.isEmpty) {
                  return const Center(child: Text('Aucun utilisateur trouve.'));
                }

                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profileImageUrl?.isNotEmpty == true
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl?.isNotEmpty == true
                            ? null
                            : const Icon(Icons.person_outline),
                      ),
                      title: Text(user.displayName),
                      subtitle: Text('@${user.username}'),
                      trailing: user.isVerified
                          ? const Icon(Icons.verified, color: Colors.blue)
                          : null,
                      onTap: () => context.push(
                        AppRoutes.userProfile.replaceFirst(':userId', user.id),
                      ),
                    );
                  },
                );
              },
              loading: () => trimmed.isEmpty
                  ? const SizedBox.shrink()
                  : const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Recherche impossible: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

