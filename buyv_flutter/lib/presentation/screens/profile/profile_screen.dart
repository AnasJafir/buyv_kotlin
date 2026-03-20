import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user?.displayName ?? user?.username ?? 'Invité',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(user?.email ?? 'Mode non authentifie'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _ProfileNavTile(
            title: 'Mes commandes',
            icon: Icons.receipt_long,
            onTap: () => context.push(AppRoutes.ordersHistory),
          ),
          _ProfileNavTile(
            title: 'Recemment consultes',
            icon: Icons.history,
            onTap: () => context.push(AppRoutes.recentlyViewed),
          ),
          _ProfileNavTile(
            title: 'Favoris',
            icon: Icons.favorite_border,
            onTap: () => context.push(AppRoutes.favourites),
          ),
          _ProfileNavTile(
            title: 'Notifications',
            icon: Icons.notifications_none,
            onTap: () => context.push(AppRoutes.notifications),
          ),
          _ProfileNavTile(
            title: 'Parametres',
            icon: Icons.settings,
            onTap: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(height: 14),
          if (authState is AuthAuthenticated)
            FilledButton.tonalIcon(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se deconnecter'),
            ),
          if (authState is! AuthAuthenticated)
            OutlinedButton.icon(
              onPressed: () => context.go(AppRoutes.login),
              icon: const Icon(Icons.login),
              label: const Text('Se connecter'),
            ),
        ],
      ),
    );
  }
}

class _ProfileNavTile extends StatelessWidget {
  const _ProfileNavTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

