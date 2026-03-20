import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../router/app_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getDashboardStats();
  }

  Future<void> _refresh() async {
    final next = AdminRemoteDataSource().getDashboardStats();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Chargement impossible: ${snapshot.error}'));
          }

          final stats = snapshot.data ?? const <String, dynamic>{};
          String num(String key) => (stats[key] ?? 0).toString();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _StatCard(
                  title: 'Vue globale',
                  lines: <String>[
                    'Utilisateurs: ${num('total_users')}',
                    'Posts: ${num('total_posts')}',
                    'Commandes: ${num('total_orders')}',
                    'Revenu: ${num('total_revenue')}',
                  ],
                ),
                const SizedBox(height: 12),
                _NavTile(
                  title: 'Utilisateurs',
                  route: AppRoutes.adminUserManagement,
                ),
                _NavTile(title: 'Produits', route: AppRoutes.adminProductManagement),
                _NavTile(title: 'Commandes', route: AppRoutes.adminOrders),
                _NavTile(title: 'Commissions', route: AppRoutes.adminCommissions),
                _NavTile(title: 'Posts', route: AppRoutes.adminPosts),
                _NavTile(title: 'Commentaires', route: AppRoutes.adminComments),
                _NavTile(title: 'Notifications', route: AppRoutes.adminNotifications),
                _NavTile(title: 'Follows', route: AppRoutes.adminFollows),
                _NavTile(title: 'Categories', route: AppRoutes.adminCategories),
                _NavTile(title: 'CJ Import', route: AppRoutes.adminCjImport),
                _NavTile(title: 'Affiliate Sales', route: AppRoutes.adminAffiliateSales),
                _NavTile(title: 'Promoter Wallets', route: AppRoutes.adminPromoterWallets),
                _NavTile(title: 'Withdrawals', route: AppRoutes.adminWithdrawal),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...lines.map(Text.new),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.title, required this.route});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(route),
      ),
    );
  }
}

