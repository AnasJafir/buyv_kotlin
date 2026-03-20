import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/recently_viewed_provider.dart';

class RecentlyViewedScreen extends ConsumerWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recentlyViewedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recemment consultes'),
        actions: <Widget>[
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(recentlyViewedProvider.notifier).clear(),
              child: const Text('Vider'),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('Aucun produit consulte pour le moment.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: item.imageUrl?.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item.imageUrl!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.history),
                    title: Text(item.name),
                    subtitle: Text(
                      '\$${item.price.toStringAsFixed(2)} ${item.currency} • ${item.viewedAt.day}/${item.viewedAt.month}/${item.viewedAt.year}',
                    ),
                    onTap: () => context.push('/products/${item.productId}'),
                  ),
                );
              },
            ),
    );
  }
}

