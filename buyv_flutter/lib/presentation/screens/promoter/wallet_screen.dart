import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/promoter_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon wallet')),
      body: walletAsync.when(
        data: (wallet) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(walletOverviewProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _WalletCard(
                  title: 'Disponible',
                  amount: wallet.availableAmount,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                _WalletCard(
                  title: 'En attente',
                  amount: wallet.pendingAmount,
                  color: Colors.orange,
                ),
                const SizedBox(height: 10),
                _WalletCard(
                  title: 'Total gagne',
                  amount: wallet.totalEarned,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                _WalletCard(
                  title: 'Total retire',
                  amount: wallet.withdrawnAmount,
                  color: Colors.purple,
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: const Text('Ventes total'),
                    trailing: Text('${wallet.totalSalesCount}'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          '${amount.toStringAsFixed(2)} USD',
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ),
    );
  }
}

