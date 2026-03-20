import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

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
}
