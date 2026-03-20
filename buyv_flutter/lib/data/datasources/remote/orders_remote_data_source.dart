import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/product_models.dart';

class PaymentIntentResult {
  const PaymentIntentResult({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.customerId,
    required this.ephemeralKey,
  });

  final String clientSecret;
  final String paymentIntentId;
  final String customerId;
  final String ephemeralKey;
}

class OrdersRemoteDataSource {
  OrdersRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<PaymentIntentResult> createPaymentIntent({
    required int amountCents,
    String currency = 'usd',
  }) async {
    final response = await _dio.post(
      '/payments/create-payment-intent',
      data: <String, dynamic>{
        'amount': amountCents,
        'currency': currency,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid payment intent response.');
    }

    final clientSecret = _asString(data['clientSecret']);
    final paymentIntentId = _asString(data['paymentIntentId']);
    final customerId = _asString(data['customer']);
    final ephemeralKey = _asString(data['ephemeralKey']);
    if (clientSecret.isEmpty || paymentIntentId.isEmpty || customerId.isEmpty || ephemeralKey.isEmpty) {
      throw const FormatException('Missing payment intent fields.');
    }

    return PaymentIntentResult(
      clientSecret: clientSecret,
      paymentIntentId: paymentIntentId,
      customerId: customerId,
      ephemeralKey: ephemeralKey,
    );
  }

  Future<OrderModel> createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required AddressModel shippingAddress,
    required String paymentMethod,
    String? paymentIntentId,
  }) async {
    final response = await _dio.post(
      '/orders',
      data: <String, dynamic>{
        'items': items
            .map(
              (item) => <String, dynamic>{
                'product_id': item.productId,
                'product_name': item.productName,
                'product_image': item.productImage,
                'price': item.price,
                'quantity': item.quantity,
                'size': item.size,
                'color': item.color,
                'attributes': <String, String>{},
                'is_promoted_product': item.isPromotedProduct,
                'promoter_id': item.promoterId,
              },
            )
            .toList(growable: false),
        'status': 'pending',
        'subtotal': subtotal,
        'shipping': shipping,
        'tax': tax,
        'total': total,
        'shipping_address': <String, dynamic>{
          'fullName': shippingAddress.fullName,
          'address': shippingAddress.address,
          'city': shippingAddress.city,
          'state': shippingAddress.state,
          'zipCode': shippingAddress.zipCode,
          'country': shippingAddress.country,
          'phone': shippingAddress.phone,
          'isDefault': false,
        },
        'payment_method': paymentMethod,
        'payment_intent_id': paymentIntentId,
      },
    );

    return _mapOrder(response.data);
  }

  Future<List<OrderModel>> listMyOrders() async {
    final response = await _dio.get('/orders/me');
    final data = response.data;
    if (data is! List) {
      return const <OrderModel>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(_mapOrder)
        .toList(growable: false);
  }

  Future<OrderModel?> getOrder(int orderId) async {
    final response = await _dio.get('/orders/$orderId');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return _mapOrder(data);
  }

  Future<void> cancelOrder(int orderId, {String? reason}) async {
    await _dio.post(
      '/orders/$orderId/cancel',
      data: <String, dynamic>{
        'reason': reason?.trim().isNotEmpty == true ? reason!.trim() : null,
      },
    );
  }

  OrderModel _mapOrder(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid order payload.');
    }

    final itemsRaw = raw['items'];
    final mappedItems = itemsRaw is List
        ? itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => <String, dynamic>{
                'productId': _asString(item['product_id']),
                'productName': _asString(item['product_name']),
                'productImage': _asString(item['product_image']),
                'price': _asDouble(item['price']),
                'quantity': _asInt(item['quantity'], fallback: 1),
                'size': _nullableString(item['size']),
                'color': _nullableString(item['color']),
              },
            )
            .toList(growable: false)
        : const <Map<String, dynamic>>[];

    final shippingRaw = raw['shipping_address'];
    final shipping = shippingRaw is Map<String, dynamic>
        ? <String, dynamic>{
            'id': _nullableString(shippingRaw['id']),
            'fullName': _asString(shippingRaw['fullName'],
                fallback: _asString(shippingRaw['full_name'])),
            'address': _asString(shippingRaw['address']),
            'city': _asString(shippingRaw['city']),
            'state': _asString(shippingRaw['state']),
            'zipCode': _asString(shippingRaw['zipCode'],
                fallback: _asString(shippingRaw['zip_code'])),
            'country': _asString(shippingRaw['country']),
            'phone': _asString(shippingRaw['phone']),
          }
        : null;

    final paymentInfoRaw = raw['payment_info'];
    final paymentMethod = paymentInfoRaw is Map<String, dynamic>
        ? _nullableString(paymentInfoRaw['method'])
        : _nullableString(raw['payment_method']);

    return OrderModel.fromJson(<String, dynamic>{
      'id': _asInt(raw['id']),
      'userId': _asInt(raw['user_id']),
      'orderNumber': _asString(raw['order_number']),
      'items': mappedItems,
      'status': _asString(raw['status']),
      'subtotal': _asDouble(raw['subtotal']),
      'shipping': _asDouble(raw['shipping']),
      'tax': _asDouble(raw['tax']),
      'total': _asDouble(raw['total_amount'], fallback: _asDouble(raw['total'])),
      'shippingAddress': shipping,
      'paymentMethod': paymentMethod,
      'createdAt': _asString(raw['created_at']),
      'updatedAt': _asString(raw['updated_at']),
    });
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static String? _nullableString(dynamic value) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? null : result;
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double _asDouble(dynamic value, {double fallback = 0.0}) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
