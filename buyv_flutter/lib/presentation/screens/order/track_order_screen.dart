import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/orders_provider.dart';

class TrackOrderScreen extends ConsumerWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) {
      return const Scaffold(
        body: Center(child: Text('Identifiant de commande invalide.')),
      );
    }

    final orderAsync = ref.watch(orderDetailProvider(parsedId));
    final actionState = ref.watch(orderActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Commande introuvable.'));
          }

          final createdAt = DateTime.tryParse(order.createdAt);
          final updatedAt = DateTime.tryParse(order.updatedAt);
          final canCancel = order.status == 'pending' || order.status == 'processing';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Creee: ${_formatDate(createdAt)}'),
              Text('Maj: ${_formatDate(updatedAt)}'),
              if ((order.paymentMethod ?? '').trim().isNotEmpty)
                Text('Paiement: ${order.paymentMethod}'),
              const SizedBox(height: 14),
              _OrderTimeline(status: order.status),
              const SizedBox(height: 10),
              Text(
                'Total: \$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              const Text(
                'Articles',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Qte: ${item.quantity}'),
                    trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (canCancel)
                FilledButton.tonal(
                  onPressed: actionState.isLoading
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            await ref
                                .read(orderActionProvider.notifier)
                                .cancelOrder(parsedId, reason: 'Canceled by customer');
                            if (!context.mounted) {
                              return;
                            }
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Commande annulee.')),
                            );
                            ref.invalidate(orderDetailProvider(parsedId));
                          } catch (error) {
                            messenger.showSnackBar(
                              SnackBar(content: Text('Annulation impossible: $error')),
                            );
                          }
                        },
                  child: Text(actionState.isLoading ? 'Annulation...' : 'Annuler la commande'),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '--';
    }
    return DateFormat('dd/MM/yyyy HH:mm').format(value.toLocal());
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    final steps = <_TimelineStepData>[
      const _TimelineStepData('Commande creee', 'pending'),
      const _TimelineStepData('Preparation', 'processing'),
      const _TimelineStepData('Expediee', 'shipped'),
      const _TimelineStepData('Livree', 'delivered'),
    ];

    if (normalized == 'canceled') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text('Suivi', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          _TimelineRow(
            title: 'Commande annulee',
            isDone: true,
            isLast: true,
            color: Colors.red,
          ),
        ],
      );
    }

    final statusOrder = <String, int>{
      'pending': 0,
      'processing': 1,
      'shipped': 2,
      'delivered': 3,
    };
    final currentIndex = statusOrder[normalized] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Suivi', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...List<Widget>.generate(steps.length, (index) {
          final step = steps[index];
          return _TimelineRow(
            title: step.label,
            isDone: index <= currentIndex,
            isLast: index == steps.length - 1,
          );
        }),
      ],
    );
  }
}

class _TimelineStepData {
  const _TimelineStepData(this.label, this.status);

  final String label;
  final String status;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.title,
    required this.isDone,
    required this.isLast,
    this.color,
  });

  final String title;
  final bool isDone;
  final bool isLast;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? (isDone ? Colors.green : Colors.black26);
    return SizedBox(
      height: 46,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
            child: Column(
              children: <Widget>[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDone ? dotColor.withValues(alpha: 0.5) : Colors.black12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                color: isDone ? Colors.black87 : Colors.black54,
              ),
            ),
          ),
        ],
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
          fontSize: 11,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
