import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/orders_provider.dart';
import '../../router/app_router.dart';

class OrdersHistoryScreen extends ConsumerWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('Aucune commande pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(myOrdersProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                final date = DateTime.tryParse(order.createdAt);
                final dateLabel = date == null
                    ? '--'
                    : DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Text(order.orderNumber)),
                        _StatusChip(status: order.status),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 4),
                        Text('Date: $dateLabel'),
                        Text('Articles: ${order.items.length}'),
                      ],
                    ),
                    trailing: Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onTap: () => context.push('${AppRoutes.ordersHistory}/${order.id}'),
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
    final isCanceled = normalized == 'canceled';
    final isDelivered = normalized == 'delivered';
    final isShipped = normalized == 'shipped';
    final bgColor = isCanceled
        ? Colors.red.withValues(alpha: 0.12)
        : isDelivered
            ? Colors.green.withValues(alpha: 0.12)
            : isShipped
                ? Colors.blue.withValues(alpha: 0.12)
                : Colors.orange.withValues(alpha: 0.12);
    final fgColor = isCanceled
        ? Colors.red.shade700
        : isDelivered
            ? Colors.green.shade700
            : isShipped
                ? Colors.blue.shade700
                : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fgColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

