import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/promoter_provider.dart';

class AffiliateSalesScreen extends ConsumerWidget {
  const AffiliateSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(affiliateSalesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ventes affiliees')),
      body: salesAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucune vente affiliatee.'));
          }

          final totalSales = items.fold<double>(0, (sum, item) => sum + item.saleAmount);
          final totalCommissions =
              items.fold<double>(0, (sum, item) => sum + item.commissionAmount);

          return RefreshIndicator(
            onRefresh: () => ref.refresh(affiliateSalesProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Chiffre ventes: ${totalSales.toStringAsFixed(2)} USD'),
                        Text('Commissions: ${totalCommissions.toStringAsFixed(2)} USD'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...items.map((item) {
                  final date = DateTime.tryParse(item.createdAt);
                  final label = date == null
                      ? '--'
                      : DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());

                  return Card(
                    child: ListTile(
                      title: Text('Vente ${item.id}'),
                      subtitle: Text('Date: $label'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${item.saleAmount.toStringAsFixed(2)} USD',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '+ ${item.commissionAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text(item.commissionStatus.toUpperCase(), style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                }),
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

