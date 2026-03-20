import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_models.freezed.dart';
part 'product_models.g.dart';

// ── MarketplaceProduct ──────────────────────────────────────────────────────
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    String? description,
    required double price,
    @Default(0.0) double originalPrice,
    @Default(0.0) double discountPercent,
    String? imageUrl,
    @Default([]) List<String> images,
    String? categoryId,
    String? categoryName,
    required String sellerId,
    @Default(true) bool isActive,
    @Default(0) int stock,
    @Default(0.0) double commissionRate,
    String? cjProductId,
    String? reelUid,
    String? marketplaceProductUid,
    required String createdAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

// ── Category ────────────────────────────────────────────────────────────────
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? nameArabic,
    required String slug,
    String? iconUrl,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

// ── Order ───────────────────────────────────────────────────────────────────
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    @Default(0) int id,
    @Default(0) int userId,
    required String orderNumber,
    required List<OrderItemModel> items,
    required String status,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    AddressModel? shippingAddress,
    String? paymentMethod,
    required String createdAt,
    required String updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
    String? size,
    String? color,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    String? id,
    @Default('') String fullName,
    @Default('') String address,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zipCode,
    @Default('') String country,
    @Default('') String phone,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

// ── Cart Item (local Hive model) ────────────────────────────────────────────
@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    @Default(1) int quantity,
    String? size,
    String? color,
    String? promoterId,
    @Default(false) bool isPromotedProduct,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
