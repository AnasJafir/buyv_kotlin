import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/marketplace_products_provider.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(marketplaceFeaturedProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.push('/products/all'),
            child: const Text('Tout voir'),
          ),
        ],
      ),
      body: featuredAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucun produit mis en avant.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.local_offer_outlined),
                  title: Text(item.name),
                  subtitle: Text('Commission ${item.commissionRate.toStringAsFixed(1)}%'),
                  trailing: Text('${item.price.toStringAsFixed(2)} ${item.currency}'),
                  onTap: () => context.push('/marketplace/${item.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Marketplace indisponible.')),
      ),
    );
  }
}

