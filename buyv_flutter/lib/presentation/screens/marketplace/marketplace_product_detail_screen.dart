import 'package:flutter/material.dart';

import '../product/product_detail_screen.dart';

class MarketplaceProductDetailScreen extends StatelessWidget {
  final String productId;
  const MarketplaceProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ProductDetailScreen(productId: productId);
  }
}
