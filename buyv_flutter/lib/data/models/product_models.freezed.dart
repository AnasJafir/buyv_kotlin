// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  double get commissionRate => throw _privateConstructorUsedError;
  String? get cjProductId => throw _privateConstructorUsedError;
  String? get reelUid => throw _privateConstructorUsedError;
  String? get marketplaceProductUid => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double price,
      double originalPrice,
      double discountPercent,
      String? imageUrl,
      List<String> images,
      String? categoryId,
      String? categoryName,
      String sellerId,
      bool isActive,
      int stock,
      double commissionRate,
      String? cjProductId,
      String? reelUid,
      String? marketplaceProductUid,
      String createdAt});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? originalPrice = null,
    Object? discountPercent = null,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sellerId = null,
    Object? isActive = null,
    Object? stock = null,
    Object? commissionRate = null,
    Object? cjProductId = freezed,
    Object? reelUid = freezed,
    Object? marketplaceProductUid = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      commissionRate: null == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
      cjProductId: freezed == cjProductId
          ? _value.cjProductId
          : cjProductId // ignore: cast_nullable_to_non_nullable
              as String?,
      reelUid: freezed == reelUid
          ? _value.reelUid
          : reelUid // ignore: cast_nullable_to_non_nullable
              as String?,
      marketplaceProductUid: freezed == marketplaceProductUid
          ? _value.marketplaceProductUid
          : marketplaceProductUid // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double price,
      double originalPrice,
      double discountPercent,
      String? imageUrl,
      List<String> images,
      String? categoryId,
      String? categoryName,
      String sellerId,
      bool isActive,
      int stock,
      double commissionRate,
      String? cjProductId,
      String? reelUid,
      String? marketplaceProductUid,
      String createdAt});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? originalPrice = null,
    Object? discountPercent = null,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sellerId = null,
    Object? isActive = null,
    Object? stock = null,
    Object? commissionRate = null,
    Object? cjProductId = freezed,
    Object? reelUid = freezed,
    Object? marketplaceProductUid = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      commissionRate: null == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
      cjProductId: freezed == cjProductId
          ? _value.cjProductId
          : cjProductId // ignore: cast_nullable_to_non_nullable
              as String?,
      reelUid: freezed == reelUid
          ? _value.reelUid
          : reelUid // ignore: cast_nullable_to_non_nullable
              as String?,
      marketplaceProductUid: freezed == marketplaceProductUid
          ? _value.marketplaceProductUid
          : marketplaceProductUid // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.price,
      this.originalPrice = 0.0,
      this.discountPercent = 0.0,
      this.imageUrl,
      final List<String> images = const [],
      this.categoryId,
      this.categoryName,
      required this.sellerId,
      this.isActive = true,
      this.stock = 0,
      this.commissionRate = 0.0,
      this.cjProductId,
      this.reelUid,
      this.marketplaceProductUid,
      required this.createdAt})
      : _images = images;

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  @JsonKey()
  final double originalPrice;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  final String? imageUrl;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final String sellerId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int stock;
  @override
  @JsonKey()
  final double commissionRate;
  @override
  final String? cjProductId;
  @override
  final String? reelUid;
  @override
  final String? marketplaceProductUid;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, originalPrice: $originalPrice, discountPercent: $discountPercent, imageUrl: $imageUrl, images: $images, categoryId: $categoryId, categoryName: $categoryName, sellerId: $sellerId, isActive: $isActive, stock: $stock, commissionRate: $commissionRate, cjProductId: $cjProductId, reelUid: $reelUid, marketplaceProductUid: $marketplaceProductUid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.cjProductId, cjProductId) ||
                other.cjProductId == cjProductId) &&
            (identical(other.reelUid, reelUid) || other.reelUid == reelUid) &&
            (identical(other.marketplaceProductUid, marketplaceProductUid) ||
                other.marketplaceProductUid == marketplaceProductUid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      price,
      originalPrice,
      discountPercent,
      imageUrl,
      const DeepCollectionEquality().hash(_images),
      categoryId,
      categoryName,
      sellerId,
      isActive,
      stock,
      commissionRate,
      cjProductId,
      reelUid,
      marketplaceProductUid,
      createdAt);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel(
      {required final String id,
      required final String name,
      final String? description,
      required final double price,
      final double originalPrice,
      final double discountPercent,
      final String? imageUrl,
      final List<String> images,
      final String? categoryId,
      final String? categoryName,
      required final String sellerId,
      final bool isActive,
      final int stock,
      final double commissionRate,
      final String? cjProductId,
      final String? reelUid,
      final String? marketplaceProductUid,
      required final String createdAt}) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  double get originalPrice;
  @override
  double get discountPercent;
  @override
  String? get imageUrl;
  @override
  List<String> get images;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  String get sellerId;
  @override
  bool get isActive;
  @override
  int get stock;
  @override
  double get commissionRate;
  @override
  String? get cjProductId;
  @override
  String? get reelUid;
  @override
  String? get marketplaceProductUid;
  @override
  String get createdAt;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameArabic => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) then) =
      _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? nameArabic,
      String slug,
      String? iconUrl,
      int displayOrder,
      bool isActive});
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameArabic = freezed,
    Object? slug = null,
    Object? iconUrl = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameArabic: freezed == nameArabic
          ? _value.nameArabic
          : nameArabic // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
          _$CategoryModelImpl value, $Res Function(_$CategoryModelImpl) then) =
      __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? nameArabic,
      String slug,
      String? iconUrl,
      int displayOrder,
      bool isActive});
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
      _$CategoryModelImpl _value, $Res Function(_$CategoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameArabic = freezed,
    Object? slug = null,
    Object? iconUrl = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$CategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameArabic: freezed == nameArabic
          ? _value.nameArabic
          : nameArabic // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryModelImpl implements _CategoryModel {
  const _$CategoryModelImpl(
      {required this.id,
      required this.name,
      this.nameArabic,
      required this.slug,
      this.iconUrl,
      this.displayOrder = 0,
      this.isActive = true});

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? nameArabic;
  @override
  final String slug;
  @override
  final String? iconUrl;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, nameArabic: $nameArabic, slug: $slug, iconUrl: $iconUrl, displayOrder: $displayOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameArabic, nameArabic) ||
                other.nameArabic == nameArabic) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, nameArabic, slug, iconUrl, displayOrder, isActive);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryModel implements CategoryModel {
  const factory _CategoryModel(
      {required final String id,
      required final String name,
      final String? nameArabic,
      required final String slug,
      final String? iconUrl,
      final int displayOrder,
      final bool isActive}) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get nameArabic;
  @override
  String get slug;
  @override
  String? get iconUrl;
  @override
  int get displayOrder;
  @override
  bool get isActive;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get shipping => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {int id,
      int userId,
      String orderNumber,
      List<OrderItemModel> items,
      String status,
      double subtotal,
      double shipping,
      double tax,
      double total,
      AddressModel? shippingAddress,
      String? paymentMethod,
      String createdAt,
      String updatedAt});

  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderNumber = null,
    Object? items = null,
    Object? status = null,
    Object? subtotal = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
    Object? shippingAddress = freezed,
    Object? paymentMethod = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.shippingAddress!, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      String orderNumber,
      List<OrderItemModel> items,
      String status,
      double subtotal,
      double shipping,
      double tax,
      double total,
      AddressModel? shippingAddress,
      String? paymentMethod,
      String createdAt,
      String updatedAt});

  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderNumber = null,
    Object? items = null,
    Object? status = null,
    Object? subtotal = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
    Object? shippingAddress = freezed,
    Object? paymentMethod = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {this.id = 0,
      this.userId = 0,
      required this.orderNumber,
      required final List<OrderItemModel> items,
      required this.status,
      required this.subtotal,
      required this.shipping,
      required this.tax,
      required this.total,
      this.shippingAddress,
      this.paymentMethod,
      required this.createdAt,
      required this.updatedAt})
      : _items = items;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int userId;
  @override
  final String orderNumber;
  final List<OrderItemModel> _items;
  @override
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String status;
  @override
  final double subtotal;
  @override
  final double shipping;
  @override
  final double tax;
  @override
  final double total;
  @override
  final AddressModel? shippingAddress;
  @override
  final String? paymentMethod;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, orderNumber: $orderNumber, items: $items, status: $status, subtotal: $subtotal, shipping: $shipping, tax: $tax, total: $total, shippingAddress: $shippingAddress, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      orderNumber,
      const DeepCollectionEquality().hash(_items),
      status,
      subtotal,
      shipping,
      tax,
      total,
      shippingAddress,
      paymentMethod,
      createdAt,
      updatedAt);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {final int id,
      final int userId,
      required final String orderNumber,
      required final List<OrderItemModel> items,
      required final String status,
      required final double subtotal,
      required final double shipping,
      required final double tax,
      required final double total,
      final AddressModel? shippingAddress,
      final String? paymentMethod,
      required final String createdAt,
      required final String updatedAt}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  String get orderNumber;
  @override
  List<OrderItemModel> get items;
  @override
  String get status;
  @override
  double get subtotal;
  @override
  double get shipping;
  @override
  double get tax;
  @override
  double get total;
  @override
  AddressModel? get shippingAddress;
  @override
  String? get paymentMethod;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get productImage => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) then) =
      _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String productImage,
      double price,
      int quantity,
      String? size,
      String? color});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productImage = null,
    Object? price = null,
    Object? quantity = null,
    Object? size = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(_$OrderItemModelImpl value,
          $Res Function(_$OrderItemModelImpl) then) =
      __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String productImage,
      double price,
      int quantity,
      String? size,
      String? color});
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
      _$OrderItemModelImpl _value, $Res Function(_$OrderItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productImage = null,
    Object? price = null,
    Object? quantity = null,
    Object? size = freezed,
    Object? color = freezed,
  }) {
    return _then(_$OrderItemModelImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl(
      {required this.productId,
      required this.productName,
      required this.productImage,
      required this.price,
      required this.quantity,
      this.size,
      this.color});

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String productImage;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final String? size;
  @override
  final String? color;

  @override
  String toString() {
    return 'OrderItemModel(productId: $productId, productName: $productName, productImage: $productImage, price: $price, quantity: $quantity, size: $size, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName,
      productImage, price, quantity, size, color);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel(
      {required final String productId,
      required final String productName,
      required final String productImage,
      required final double price,
      required final int quantity,
      final String? size,
      final String? color}) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String get productImage;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String? get size;
  @override
  String? get color;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  String? get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) then) =
      _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call(
      {String? id,
      String fullName,
      String address,
      String city,
      String state,
      String zipCode,
      String country,
      String phone});
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = null,
    Object? phone = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
          _$AddressModelImpl value, $Res Function(_$AddressModelImpl) then) =
      __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String fullName,
      String address,
      String city,
      String state,
      String zipCode,
      String country,
      String phone});
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
      _$AddressModelImpl _value, $Res Function(_$AddressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = null,
    Object? phone = null,
  }) {
    return _then(_$AddressModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressModelImpl implements _AddressModel {
  const _$AddressModelImpl(
      {this.id,
      this.fullName = '',
      this.address = '',
      this.city = '',
      this.state = '',
      this.zipCode = '',
      this.country = '',
      this.phone = ''});

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String zipCode;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String phone;

  @override
  String toString() {
    return 'AddressModel(id: $id, fullName: $fullName, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, fullName, address, city, state, zipCode, country, phone);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(
      this,
    );
  }
}

abstract class _AddressModel implements AddressModel {
  const factory _AddressModel(
      {final String? id,
      final String fullName,
      final String address,
      final String city,
      final String state,
      final String zipCode,
      final String country,
      final String phone}) = _$AddressModelImpl;

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get fullName;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  String get zipCode;
  @override
  String get country;
  @override
  String get phone;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get productImage => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get promoterId => throw _privateConstructorUsedError;
  bool get isPromotedProduct => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String productImage,
      double price,
      int quantity,
      String? size,
      String? color,
      String? promoterId,
      bool isPromotedProduct});
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productImage = null,
    Object? price = null,
    Object? quantity = null,
    Object? size = freezed,
    Object? color = freezed,
    Object? promoterId = freezed,
    Object? isPromotedProduct = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      promoterId: freezed == promoterId
          ? _value.promoterId
          : promoterId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPromotedProduct: null == isPromotedProduct
          ? _value.isPromotedProduct
          : isPromotedProduct // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String productImage,
      double price,
      int quantity,
      String? size,
      String? color,
      String? promoterId,
      bool isPromotedProduct});
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productImage = null,
    Object? price = null,
    Object? quantity = null,
    Object? size = freezed,
    Object? color = freezed,
    Object? promoterId = freezed,
    Object? isPromotedProduct = null,
  }) {
    return _then(_$CartItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      promoterId: freezed == promoterId
          ? _value.promoterId
          : promoterId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPromotedProduct: null == isPromotedProduct
          ? _value.isPromotedProduct
          : isPromotedProduct // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl(
      {required this.productId,
      required this.productName,
      required this.productImage,
      required this.price,
      this.quantity = 1,
      this.size,
      this.color,
      this.promoterId,
      this.isPromotedProduct = false});

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String productImage;
  @override
  final double price;
  @override
  @JsonKey()
  final int quantity;
  @override
  final String? size;
  @override
  final String? color;
  @override
  final String? promoterId;
  @override
  @JsonKey()
  final bool isPromotedProduct;

  @override
  String toString() {
    return 'CartItem(productId: $productId, productName: $productName, productImage: $productImage, price: $price, quantity: $quantity, size: $size, color: $color, promoterId: $promoterId, isPromotedProduct: $isPromotedProduct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.promoterId, promoterId) ||
                other.promoterId == promoterId) &&
            (identical(other.isPromotedProduct, isPromotedProduct) ||
                other.isPromotedProduct == isPromotedProduct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      productImage,
      price,
      quantity,
      size,
      color,
      promoterId,
      isPromotedProduct);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem implements CartItem {
  const factory _CartItem(
      {required final String productId,
      required final String productName,
      required final String productImage,
      required final double price,
      final int quantity,
      final String? size,
      final String? color,
      final String? promoterId,
      final bool isPromotedProduct}) = _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String get productImage;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String? get size;
  @override
  String? get color;
  @override
  String? get promoterId;
  @override
  bool get isPromotedProduct;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
