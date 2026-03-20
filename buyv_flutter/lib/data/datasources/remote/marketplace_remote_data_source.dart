import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class MarketplaceProductItem {
  const MarketplaceProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    this.imageUrl,
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.commissionRate = 0.0,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final double price;
  final String currency;
  final String? imageUrl;
  final double averageRating;
  final int ratingCount;
  final double commissionRate;
  final bool isFeatured;
}

class MarketplaceProductDetail {
  const MarketplaceProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    this.description,
    this.mainImageUrl,
    this.images = const <String>[],
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.commissionRate = 0.0,
    this.postLikesCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  final String id;
  final String name;
  final double price;
  final String currency;
  final String? description;
  final String? mainImageUrl;
  final List<String> images;
  final double averageRating;
  final int ratingCount;
  final double commissionRate;
  final int postLikesCount;
  final bool isLiked;
  final bool isBookmarked;
}

class MarketplaceProductPage {
  const MarketplaceProductPage({
    required this.items,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  final List<MarketplaceProductItem> items;
  final int total;
  final int page;
  final int totalPages;
}

class MarketplaceRatingSummary {
  const MarketplaceRatingSummary({
    required this.averageRating,
    required this.ratingCount,
  });

  final double averageRating;
  final int ratingCount;
}

class MarketplaceProductPreview {
  const MarketplaceProductPreview({
    required this.name,
    required this.price,
    this.currency,
    this.imageUrl,
  });

  final String name;
  final double price;
  final String? currency;
  final String? imageUrl;
}

class MarketplaceRemoteDataSource {
  MarketplaceRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.public;

  final Dio _dio;

  Future<MarketplaceProductPage> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String sortBy = 'relevance',
  }) async {
    final response = await _dio.get(
      '/marketplace/products',
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
        'search': search?.trim().isNotEmpty == true ? search!.trim() : null,
        'sort_by': sortBy,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const MarketplaceProductPage(
        items: <MarketplaceProductItem>[],
        total: 0,
        page: 1,
        totalPages: 1,
      );
    }

    final rawItems = data['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(_mapProductItem)
            .toList(growable: false)
        : const <MarketplaceProductItem>[];

    return MarketplaceProductPage(
      items: items,
      total: _asInt(data['total']),
      page: _asInt(data['page'], fallback: page),
      totalPages: _asInt(data['total_pages'], fallback: 1),
    );
  }

  Future<List<MarketplaceProductItem>> getFeaturedProducts({int limit = 10}) async {
    final response = await _dio.get(
      '/marketplace/products/featured',
      queryParameters: <String, dynamic>{'limit': limit},
    );

    final data = response.data;
    if (data is! List) {
      return const <MarketplaceProductItem>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(_mapProductItem)
        .toList(growable: false);
  }

  Future<MarketplaceProductDetail?> getProduct(String productId) async {
    final trimmedId = productId.trim();
    if (trimmedId.isEmpty) {
      return null;
    }

    final response = await _dio.get('/marketplace/products/$trimmedId');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final name = _asString(data['name']);
    if (name.isEmpty) {
      return null;
    }

    final imagesRaw = data['images'];
    final images = imagesRaw is List
        ? imagesRaw.map((item) => item.toString().trim()).where((url) => url.isNotEmpty).toList(growable: false)
        : const <String>[];

    return MarketplaceProductDetail(
      id: _asString(data['id']),
      name: name,
      price: _asDouble(data['selling_price']),
      currency: _asString(data['currency'], fallback: 'USD'),
      description: _nullableString(data['description']) ?? _nullableString(data['short_description']),
      mainImageUrl: _nullableString(data['main_image_url']),
      images: images,
      averageRating: _asDouble(data['average_rating']),
      ratingCount: _asInt(data['rating_count']),
      commissionRate: _asDouble(data['commission_rate']),
      postLikesCount: _asInt(data['post_likes_count']),
      isLiked: _asBool(data['is_liked']),
      isBookmarked: _asBool(data['is_bookmarked']),
    );
  }

  Future<MarketplaceRatingSummary?> getProductRatingSummary(String productUid) async {
    final trimmedUid = productUid.trim();
    if (trimmedUid.isEmpty) {
      return null;
    }

    final response = await _dio.get('/marketplace/products/$trimmedUid');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final avgRaw = data['average_rating'] ?? data['averageRating'];
    final countRaw = data['rating_count'] ?? data['ratingCount'];

    final averageRating = (avgRaw as num?)?.toDouble() ??
        double.tryParse(avgRaw?.toString() ?? '') ??
        0.0;
    final ratingCount = (countRaw as num?)?.toInt() ??
        int.tryParse(countRaw?.toString() ?? '') ??
        0;

    return MarketplaceRatingSummary(
      averageRating: averageRating,
      ratingCount: ratingCount,
    );
  }

  Future<MarketplaceProductPreview?> getProductPreview(String productUid) async {
    final trimmedUid = productUid.trim();
    if (trimmedUid.isEmpty) {
      return null;
    }

    final response = await _dio.get('/marketplace/products/$trimmedUid');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final nameRaw = data['name'];
    final priceRaw = data['selling_price'] ?? data['sellingPrice'];
    final currencyRaw = data['currency'];
    final imageRaw = data['main_image_url'] ?? data['mainImageUrl'];

    final name = (nameRaw?.toString() ?? '').trim();
    final price = (priceRaw as num?)?.toDouble() ??
        double.tryParse(priceRaw?.toString() ?? '') ??
        0.0;
    final currency = (currencyRaw?.toString() ?? '').trim();
    final imageUrl = (imageRaw?.toString() ?? '').trim();

    if (name.isEmpty && price <= 0) {
      return null;
    }

    return MarketplaceProductPreview(
      name: name.isEmpty ? 'Produit' : name,
      price: price,
      currency: currency.isEmpty ? null : currency,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
    );
  }

  MarketplaceProductItem _mapProductItem(Map<String, dynamic> json) {
    final name = _asString(json['name'], fallback: 'Produit');
    return MarketplaceProductItem(
      id: _asString(json['id']),
      name: name,
      price: _asDouble(json['selling_price']),
      currency: _asString(json['currency'], fallback: 'USD'),
      imageUrl: _nullableString(json['main_image_url']) ?? _nullableString(json['thumbnail_url']),
      averageRating: _asDouble(json['average_rating']),
      ratingCount: _asInt(json['rating_count']),
      commissionRate: _asDouble(json['commission_rate']),
      isFeatured: _asBool(json['is_featured']),
    );
  }

  String _asString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String? _nullableString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  double _asDouble(dynamic value, {double fallback = 0.0}) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1';
  }
}
