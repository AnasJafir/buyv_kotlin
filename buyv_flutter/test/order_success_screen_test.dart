import 'package:buyv/presentation/screens/order/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OrderSuccessScreen shows mock payment badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderSuccessScreen(
          orderId: 123,
          orderNumber: 'ORD-123',
          total: 49.99,
          isMockPayment: true,
        ),
      ),
    );

    expect(find.text('PAIEMENT TEST (MOCK)'), findsOneWidget);
    expect(find.text('Numero de commande: ORD-123'), findsOneWidget);
    expect(find.text('Retour aux Reels'), findsOneWidget);
  });

  testWidgets('OrderSuccessScreen shows live payment badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderSuccessScreen(
          orderId: 456,
          orderNumber: 'ORD-456',
          total: 89.50,
          isMockPayment: false,
        ),
      ),
    );

    expect(find.text('PAIEMENT STRIPE CONFIRME'), findsOneWidget);
    expect(find.text('Montant: \$89.50'), findsOneWidget);
  });
}
