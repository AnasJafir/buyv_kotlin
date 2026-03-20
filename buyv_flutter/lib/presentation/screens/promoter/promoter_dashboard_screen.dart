import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/promoter_provider.dart';
import '../../router/app_router.dart';

class PromoterDashboardScreen extends ConsumerWidget {
  const PromoterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(promoterStatusProvider);
    final withdrawalStatsAsync = ref.watch(withdrawalStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Espace Promoteur')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(promoterStatusProvider);
          ref.invalidate(withdrawalStatsProvider);
          await Future.wait(<Future<void>>[
            ref.read(promoterStatusProvider.future),
            ref.read(withdrawalStatsProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            statusAsync.when(
              data: (status) => _SummaryCard(
                title: status.isPromoter ? 'Compte promoteur actif' : 'Compte non actif',
                rows: <String>[
                  'Total gagne: ${status.totalEarned.toStringAsFixed(2)} USD',
                  'Disponible: ${status.availableBalance.toStringAsFixed(2)} USD',
                  'En attente: ${status.pendingAmount.toStringAsFixed(2)} USD',
                  'Retire: ${status.totalWithdrawn.toStringAsFixed(2)} USD',
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Chargement impossible: $error'),
            ),
            const SizedBox(height: 12),
            withdrawalStatsAsync.when(
              data: (stats) => _SummaryCard(
                title: 'Statistiques retraits',
                rows: <String>[
                  'Demandes en attente: ${stats.pendingRequestsCount}',
                  'Demandes approuvees: ${stats.approvedRequestsCount}',
                  'Demandes totales: ${stats.totalRequestsCount}',
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),
            _NavTile(
              title: 'Mes commissions',
              icon: Icons.payments_outlined,
              onTap: () => context.push(AppRoutes.myCommissions),
            ),
            _NavTile(
              title: 'Mes promotions',
              icon: Icons.campaign_outlined,
              onTap: () => context.push(AppRoutes.myPromotions),
            ),
            _NavTile(
              title: 'Mon wallet',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => context.push(AppRoutes.wallet),
            ),
            _NavTile(
              title: 'Ventes affiliees',
              icon: Icons.sell_outlined,
              onTap: () => context.push(AppRoutes.affiliateSales),
            ),
            _NavTile(
              title: 'Retraits',
              icon: Icons.request_quote_outlined,
              onTap: () => context.push(AppRoutes.withdrawal),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.rows});

  final String title;
  final List<String> rows;

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
            ...rows.map(Text.new),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
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

