import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.total,
    this.isMockPayment = false,
  });

  final int? orderId;
  final String orderNumber;
  final double total;
  final bool isMockPayment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commande confirmee'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 52),
                ),
                const SizedBox(height: 16),
                Text(
                  'Merci, votre commande est validee',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Numero: $orderNumber',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text('Montant: \$${total.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isMockPayment
                        ? Colors.blue.withValues(alpha: 0.12)
                        : Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isMockPayment ? 'PAIEMENT TEST (MOCK)' : 'PAIEMENT STRIPE CONFIRME',
                    style: TextStyle(
                      color: isMockPayment ? Colors.blue.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: orderId == null
                        ? null
                        : () => context.go('${AppRoutes.ordersHistory}/$orderId'),
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Suivre ma commande'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.ordersHistory),
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Voir mes commandes'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go(AppRoutes.products),
                  child: const Text('Continuer mes achats'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
