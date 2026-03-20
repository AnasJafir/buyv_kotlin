import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/cart_provider.dart';
import '../../router/app_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final shipping = ref.watch(cartShippingProvider);
    final tax = ref.watch(cartTaxProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Panier (${ref.watch(cartItemCountProvider)})'),
        actions: <Widget>[
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              child: const Text('Vider'),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('Votre panier est vide.'))
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: item.productImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.productImage,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                        ),
                                      )
                                    : const Icon(Icons.shopping_bag_outlined),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.productName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('\$${item.price.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .updateQuantity(index, item.quantity - 1);
                                        },
                                        icon: const Icon(Icons.remove_circle_outline),
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .updateQuantity(index, item.quantity + 1);
                                        },
                                        icon: const Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => ref.read(cartProvider.notifier).removeAt(index),
                                    child: const Text('Supprimer'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12)),
                  ),
                  child: Column(
                    children: <Widget>[
                      _PriceLine(label: 'Sous-total', value: subtotal),
                      _PriceLine(label: 'Livraison', value: shipping),
                      _PriceLine(label: 'Taxe', value: tax),
                      const SizedBox(height: 6),
                      _PriceLine(label: 'Total', value: total, isEmphasis: true),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => context.push(AppRoutes.payment),
                          child: const Text('Passer au paiement'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  final String label;
  final double value;
  final bool isEmphasis;

  @override
  Widget build(BuildContext context) {
    final style = isEmphasis
        ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}

