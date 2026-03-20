// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      sellerId: json['sellerId'] as String,
      isActive: json['isActive'] as bool? ?? true,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
      cjProductId: json['cjProductId'] as String?,
      reelUid: json['reelUid'] as String?,
      marketplaceProductUid: json['marketplaceProductUid'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'discountPercent': instance.discountPercent,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'sellerId': instance.sellerId,
      'isActive': instance.isActive,
      'stock': instance.stock,
      'commissionRate': instance.commissionRate,
      'cjProductId': instance.cjProductId,
      'reelUid': instance.reelUid,
      'marketplaceProductUid': instance.marketplaceProductUid,
      'createdAt': instance.createdAt,
    };

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameArabic: json['nameArabic'] as String?,
      slug: json['slug'] as String,
      iconUrl: json['iconUrl'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameArabic': instance.nameArabic,
      'slug': instance.slug,
      'iconUrl': instance.iconUrl,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
    };

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      orderNumber: json['orderNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      shippingAddress: json['shippingAddress'] == null
          ? null
          : AddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>),
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderNumber': instance.orderNumber,
      'items': instance.items,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'shipping': instance.shipping,
      'tax': instance.tax,
      'total': instance.total,
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      size: json['size'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
        _$OrderItemModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'price': instance.price,
      'quantity': instance.quantity,
      'size': instance.size,
      'color': instance.color,
    };

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      id: json['id'] as String?,
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zipCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'phone': instance.phone,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      size: json['size'] as String?,
      color: json['color'] as String?,
      promoterId: json['promoterId'] as String?,
      isPromotedProduct: json['isPromotedProduct'] as bool? ?? false,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'price': instance.price,
      'quantity': instance.quantity,
      'size': instance.size,
      'color': instance.color,
      'promoterId': instance.promoterId,
      'isPromotedProduct': instance.isPromotedProduct,
    };
