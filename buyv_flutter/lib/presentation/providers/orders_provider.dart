import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/orders_remote_data_source.dart';
import '../../data/models/product_models.dart';
import 'cart_provider.dart';

final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  return OrdersRemoteDataSource();
});

final paymentMockStatusProvider = FutureProvider<bool>((ref) async {
  final dataSource = ref.watch(ordersRemoteDataSourceProvider);
  return dataSource.isMockPaymentsEnabled();
});

final myOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final dataSource = ref.watch(ordersRemoteDataSourceProvider);
  return dataSource.listMyOrders();
});

final orderDetailProvider = FutureProvider.family<OrderModel?, int>((ref, orderId) async {
  final dataSource = ref.watch(ordersRemoteDataSourceProvider);
  return dataSource.getOrder(orderId);
});

class CheckoutNotifier extends AsyncNotifier<OrderModel?> {
  @override
  Future<OrderModel?> build() async => null;

  Future<PaymentIntentResult> createPaymentIntent(double totalAmount) async {
    final dataSource = ref.read(ordersRemoteDataSourceProvider);
    return dataSource.createPaymentIntent(
      amountCents: (totalAmount * 100).round(),
    );
  }

  Future<OrderModel> checkout({
    required AddressModel shippingAddress,
    String paymentMethod = 'card',
    String? paymentIntentId,
  }) async {
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      throw StateError('Cart is empty.');
    }

    state = const AsyncLoading();
    final dataSource = ref.read(ordersRemoteDataSourceProvider);

    try {
      final subtotal = ref.read(cartSubtotalProvider);
      final shipping = ref.read(cartShippingProvider);
      final tax = ref.read(cartTaxProvider);
      final total = ref.read(cartTotalProvider);

      String intentId = paymentIntentId ?? '';
      if (intentId.isEmpty) {
        final intent = await dataSource.createPaymentIntent(
          amountCents: (total * 100).round(),
        );
        intentId = intent.paymentIntentId;
      }

      final order = await dataSource.createOrder(
        items: cartItems,
        subtotal: subtotal,
        shipping: shipping,
        tax: tax,
        total: total,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        paymentIntentId: intentId,
      );

      ref.read(cartProvider.notifier).clear();
      ref.invalidate(myOrdersProvider);
      ref.invalidate(orderDetailProvider);
      state = AsyncData(order);
      return order;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final checkoutProvider = AsyncNotifierProvider<CheckoutNotifier, OrderModel?>(
  CheckoutNotifier.new,
);

class OrderActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> cancelOrder(int orderId, {String? reason}) async {
    state = const AsyncLoading();
    final dataSource = ref.read(ordersRemoteDataSourceProvider);

    try {
      await dataSource.cancelOrder(orderId, reason: reason);
      ref.invalidate(myOrdersProvider);
      ref.invalidate(orderDetailProvider(orderId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final orderActionProvider = AsyncNotifierProvider<OrderActionNotifier, void>(
  OrderActionNotifier.new,
);
