import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/marketplace_remote_data_source.dart';

class MarketplaceProductsQuery {
  const MarketplaceProductsQuery({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.categorySlug,
    this.sortBy = 'relevance',
  });

  final int page;
  final int limit;
  final String? search;
  final String? categorySlug;
  final String sortBy;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarketplaceProductsQuery &&
        other.page == page &&
        other.limit == limit &&
        other.search == search &&
          other.categorySlug == categorySlug &&
        other.sortBy == sortBy;
  }

  @override
        int get hashCode => Object.hash(page, limit, search, categorySlug, sortBy);
}

final marketplaceProductsProvider =
    FutureProvider.family<MarketplaceProductPage, MarketplaceProductsQuery>((ref, query) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getProducts(
    page: query.page,
    limit: query.limit,
    search: query.search,
    categorySlug: query.categorySlug,
    sortBy: query.sortBy,
  );
});

final marketplaceCategoriesProvider = FutureProvider<List<MarketplaceCategoryItem>>((ref) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getCategories();
});

final marketplaceFeaturedProductsProvider = FutureProvider<List<MarketplaceProductItem>>((ref) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getFeaturedProducts(limit: 12);
});

final marketplaceProductDetailProvider =
    FutureProvider.family<MarketplaceProductDetail?, String>((ref, productId) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getProduct(productId);
});
