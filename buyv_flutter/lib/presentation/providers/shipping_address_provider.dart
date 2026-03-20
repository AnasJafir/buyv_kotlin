import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/config/app_config.dart';
import '../../data/models/product_models.dart';

class ShippingAddressNotifier extends Notifier<AddressModel?> {
  static const String _addressKey = 'default_shipping_address';

  @override
  AddressModel? build() {
    final box = Hive.box(AppConfig.prefsBoxName);
    final raw = box.get(_addressKey);
    if (raw is! Map) {
      return null;
    }

    try {
      return AddressModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AddressModel address) async {
    state = address;
    final box = Hive.box(AppConfig.prefsBoxName);
    await box.put(_addressKey, address.toJson());
  }

  Future<void> clear() async {
    state = null;
    final box = Hive.box(AppConfig.prefsBoxName);
    await box.delete(_addressKey);
  }
}

final shippingAddressProvider =
    NotifierProvider<ShippingAddressNotifier, AddressModel?>(
  ShippingAddressNotifier.new,
);
