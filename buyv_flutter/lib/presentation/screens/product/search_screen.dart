import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/marketplace_products_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _query.trim();
    final asyncPage = ref.watch(
      marketplaceProductsProvider(
        MarketplaceProductsQuery(search: search.isEmpty ? null : search, limit: 30),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche Produits')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Nom, tag, mot-cle...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => setState(() => _query = _queryController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: asyncPage.when(
              data: (page) {
                if (search.isEmpty) {
                  return const Center(child: Text('Saisis un mot-cle pour lancer la recherche.'));
                }
                if (page.items.isEmpty) {
                  return const Center(child: Text('Aucun resultat.'));
                }
                return ListView.separated(
                  itemCount: page.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = page.items[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(item.name),
                      subtitle: Text('Rating ${item.averageRating.toStringAsFixed(1)} • ${item.ratingCount} avis'),
                      trailing: Text('${item.price.toStringAsFixed(2)} ${item.currency}'),
                      onTap: () => context.push('/products/${item.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Erreur de recherche.')),
            ),
          ),
        ],
      ),
    );
  }
}

