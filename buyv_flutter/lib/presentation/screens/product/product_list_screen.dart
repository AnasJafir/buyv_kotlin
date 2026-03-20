import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/marketplace_products_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _search;
  String? _categorySlug;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = MarketplaceProductsQuery(
      search: _search,
      categorySlug: _categorySlug,
      limit: 24,
    );
    final productsAsync = ref.watch(marketplaceProductsProvider(query));
    final categoriesAsync = ref.watch(marketplaceCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/products/search'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                setState(() {
                  _search = value.trim().isEmpty ? null : value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un produit',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      _search = _searchController.text.trim().isEmpty
                          ? null
                          : _searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 46,
            child: categoriesAsync.when(
              data: (categories) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('Tout'),
                        selected: _categorySlug == null,
                        onSelected: (_) {
                          setState(() => _categorySlug = null);
                        },
                      ),
                    ),
                    ...categories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: _categorySlug == category.slug,
                          onSelected: (_) {
                            setState(() => _categorySlug = category.slug);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (page) {
                if (page.items.isEmpty) {
                  return const Center(child: Text('Aucun produit trouve.'));
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(marketplaceProductsProvider(query).future),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: page.items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final item = page.items[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.push('/products/${item.id}'),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: item.imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: item.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                                      )
                                    : const Center(child: Icon(Icons.storefront_outlined, size: 40)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${item.price.toStringAsFixed(2)} ${item.currency}',
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rating ${item.averageRating.toStringAsFixed(1)} (${item.ratingCount})',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Chargement impossible.')),
            ),
          ),
        ],
      ),
    );
  }
}

