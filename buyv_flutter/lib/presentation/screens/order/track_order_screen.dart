import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Center(child: Text('Order #$orderId — Coming Soon')),
    );
  }
}
