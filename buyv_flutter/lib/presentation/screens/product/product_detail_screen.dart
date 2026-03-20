import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/product_models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/marketplace_products_provider.dart';
import '../../providers/recently_viewed_provider.dart';
import '../../router/app_router.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _recentlyTracked = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(marketplaceProductDetailProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produit')),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Produit introuvable.'));
          }

          if (!_recentlyTracked) {
            _recentlyTracked = true;
            final image = (detail.mainImageUrl ?? '').trim().isNotEmpty
                ? detail.mainImageUrl!.trim()
                : (detail.images.isNotEmpty ? detail.images.first : null);
            ref.read(recentlyViewedProvider.notifier).addOrUpdate(
                  productId: detail.id,
                  name: detail.name,
                  price: detail.price,
                  currency: detail.currency,
                  imageUrl: image,
                );
          }

          final gallery = {
            if (detail.mainImageUrl != null) detail.mainImageUrl!,
            ...detail.images,
          }.toList(growable: false);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: <Widget>[
              if (gallery.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: gallery.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final imageUrl = gallery[index];
                      return AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(
                  height: 220,
                  child: Card(child: Center(child: Icon(Icons.storefront_outlined, size: 64))),
                ),
              const SizedBox(height: 14),
              Text(
                detail.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${detail.price.toStringAsFixed(2)} ${detail.currency}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Rating ${detail.averageRating.toStringAsFixed(1)} (${detail.ratingCount} avis)',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                'Commission ${detail.commissionRate.toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Text(
                detail.description?.trim().isNotEmpty == true
                    ? detail.description!.trim()
                    : 'Aucune description disponible.',
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  final image = (detail.mainImageUrl ?? '').trim().isNotEmpty
                      ? detail.mainImageUrl!.trim()
                      : (detail.images.isNotEmpty ? detail.images.first : '');

                  ref.read(cartProvider.notifier).addItem(
                        CartItem(
                          productId: detail.id,
                          productName: detail.name,
                          productImage: image,
                          price: detail.price,
                        ),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Produit ajoute au panier.'),
                      action: SnackBarAction(
                        label: 'Voir',
                        onPressed: () => context.go(AppRoutes.cart),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Ajouter au panier'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Chargement du produit impossible.')),
      ),
    );
  }
}
