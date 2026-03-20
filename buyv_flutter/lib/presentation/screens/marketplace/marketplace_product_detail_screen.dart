import 'package:flutter/material.dart';

class MarketplaceProductDetailScreen extends StatelessWidget {
  final String productId;
  const MarketplaceProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Product')),
      body: Center(child: Text('Product #$productId — Coming Soon')),
    );
  }
}
