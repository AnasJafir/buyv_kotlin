import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/promoter_provider.dart';

class MyCommissionsScreen extends ConsumerWidget {
  const MyCommissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissionsAsync = ref.watch(commissionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes commissions')),
      body: commissionsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucune commission pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(commissionsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final date = DateTime.tryParse(item.createdAt);
                final label = date == null
                    ? '--'
                    : DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());

                return Card(
                  child: ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Date: $label'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${item.commissionAmount.toStringAsFixed(2)} USD',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        _StatusChip(status: item.status),
                      ],
                    ),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = normalized == 'paid'
        ? Colors.green
        : normalized == 'approved'
            ? Colors.blue
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

