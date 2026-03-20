import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/config/app_config.dart';

class RecentlyViewedItem {
  const RecentlyViewedItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.currency,
    required this.viewedAt,
    this.imageUrl,
  });

  final String productId;
  final String name;
  final double price;
  final String currency;
  final String? imageUrl;
  final DateTime viewedAt;

  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedItem(
      productId: (json['productId']?.toString() ?? '').trim(),
      name: (json['name']?.toString() ?? '').trim(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      currency: (json['currency']?.toString() ?? 'USD').trim(),
      imageUrl: (json['imageUrl']?.toString().trim().isNotEmpty ?? false)
          ? json['imageUrl'].toString().trim()
          : null,
      viewedAt: DateTime.tryParse(json['viewedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }
}

class RecentlyViewedNotifier extends Notifier<List<RecentlyViewedItem>> {
  static const String _itemsKey = 'items';

  @override
  List<RecentlyViewedItem> build() {
    final box = Hive.box(AppConfig.recentlyViewedBoxName);
    final raw = box.get(_itemsKey, defaultValue: const <dynamic>[]);
    if (raw is! List) {
      return const <RecentlyViewedItem>[];
    }

    return raw
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .map(RecentlyViewedItem.fromJson)
        .where((item) => item.productId.isNotEmpty)
        .toList(growable: false);
  }

  void addOrUpdate({
    required String productId,
    required String name,
    required double price,
    required String currency,
    String? imageUrl,
  }) {
    final trimmedId = productId.trim();
    if (trimmedId.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final updated = [
      RecentlyViewedItem(
        productId: trimmedId,
        name: name.trim().isEmpty ? 'Produit' : name.trim(),
        price: price,
        currency: currency.trim().isEmpty ? 'USD' : currency.trim(),
        imageUrl: imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : null,
        viewedAt: now,
      ),
      ...state.where((item) => item.productId != trimmedId),
    ];

    const maxItems = 30;
    final nextState = updated.take(maxItems).toList(growable: false);
    _persist(nextState);
  }

  void clear() {
    _persist(const <RecentlyViewedItem>[]);
  }

  void _persist(List<RecentlyViewedItem> items) {
    state = items;
    final box = Hive.box(AppConfig.recentlyViewedBoxName);
    box.put(_itemsKey, items.map((item) => item.toJson()).toList(growable: false));
  }
}

final recentlyViewedProvider =
    NotifierProvider<RecentlyViewedNotifier, List<RecentlyViewedItem>>(
  RecentlyViewedNotifier.new,
);
