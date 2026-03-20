import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/promoter_provider.dart';

class MyPromotionsScreen extends ConsumerWidget {
  const MyPromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(promotionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes promotions')),
      body: promotionsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucune promotion active.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(promotionsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final date = DateTime.tryParse(item.createdAt);
                final label = date == null
                    ? '--'
                    : DateFormat('dd/MM/yyyy').format(date.toLocal());

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Post: ${item.postId}', maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            _Metric(label: 'Vues', value: item.viewsCount.toString()),
                            _Metric(label: 'Clics', value: item.clicksCount.toString()),
                            _Metric(label: 'Ventes', value: item.salesCount.toString()),
                            _Metric(
                              label: 'Commission',
                              value: '${item.totalCommissionEarned.toStringAsFixed(2)} USD',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Cree le $label'),
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

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value'),
    );
  }
}

