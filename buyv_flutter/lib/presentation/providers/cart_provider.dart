import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/config/app_config.dart';
import '../../data/models/product_models.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  static const String _itemsKey = 'items';

  @override
  List<CartItem> build() {
    final box = Hive.box(AppConfig.cartBoxName);
    final stored = box.get(_itemsKey, defaultValue: const <dynamic>[]);
    if (stored is! List) {
      return const <CartItem>[];
    }

    return stored
        .whereType<Map>()
        .map((raw) => Map<String, dynamic>.from(raw))
        .map(_safeCartItem)
        .whereType<CartItem>()
        .toList(growable: false);
  }

  void addItem(CartItem item) {
    final list = [...state];
    final index = list.indexWhere(
      (entry) =>
          entry.productId == item.productId &&
          entry.size == item.size &&
          entry.color == item.color &&
          entry.promoterId == item.promoterId,
    );

    if (index >= 0) {
      final existing = list[index];
      list[index] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      list.add(item);
    }

    _persist(list);
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final list = [...state]..removeAt(index);
    _persist(list);
  }

  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= state.length) {
      return;
    }

    final clamped = quantity < 1 ? 1 : quantity;
    final list = [...state];
    list[index] = list[index].copyWith(quantity: clamped);
    _persist(list);
  }

  void clear() {
    _persist(const <CartItem>[]);
  }

  void _persist(List<CartItem> items) {
    state = items;
    final box = Hive.box(AppConfig.cartBoxName);
    box.put(
      _itemsKey,
      items.map((item) => item.toJson()).toList(growable: false),
    );
  }

  CartItem? _safeCartItem(Map<String, dynamic> json) {
    try {
      return CartItem.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold<int>(0, (sum, item) => sum + item.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref
      .watch(cartProvider)
      .fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));
});

final cartShippingProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  if (subtotal <= 0) {
    return 0.0;
  }
  return subtotal >= 80 ? 0.0 : 5.99;
});

final cartTaxProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  return subtotal * 0.08;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartSubtotalProvider) +
      ref.watch(cartShippingProvider) +
      ref.watch(cartTaxProvider);
});
