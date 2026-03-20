import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:go_router/go_router.dart';

import '../../../data/models/product_models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/shipping_address_provider.dart';
import '../../router/app_router.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  final _country = TextEditingController(text: 'US');
  final _phone = TextEditingController();
  bool _isProcessing = false;
  bool _didPrefill = false;

  @override
  void dispose() {
    _fullName.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    _country.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final savedAddress = ref.watch(shippingAddressProvider);
    final isLoading = checkoutState.isLoading || _isProcessing;

    if (!_didPrefill && savedAddress != null) {
      _applyAddress(savedAddress);
      _didPrefill = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text(
              'Adresse de livraison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (savedAddress != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      _applyAddress(savedAddress);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adresse enregistree appliquee.')),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Utiliser l\'adresse enregistree'),
                  ),
                ),
              ),
            TextFormField(
              controller: _fullName,
              decoration: const InputDecoration(labelText: 'Nom complet'),
              validator: _required,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Adresse'),
              validator: _required,
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'Ville'),
                    validator: _required,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _state,
                    decoration: const InputDecoration(labelText: 'Etat'),
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _zip,
                    decoration: const InputDecoration(labelText: 'Code postal'),
                    validator: _required,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _country,
                    decoration: const InputDecoration(labelText: 'Pays'),
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Telephone'),
              validator: _required,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Montant a payer', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Mode test: paiement simule via payment intent backend.'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : _submit,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock),
                label: Text(isLoading ? 'Traitement...' : 'Payer et confirmer la commande'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isProcessing = true;
      });

      final shippingAddress = AddressModel(
        fullName: _fullName.text.trim(),
        address: _address.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim(),
        zipCode: _zip.text.trim(),
        country: _country.text.trim(),
        phone: _phone.text.trim(),
      );

      await ref.read(shippingAddressProvider.notifier).save(shippingAddress);

      final total = ref.read(cartTotalProvider);
      final paymentIntent = await ref
          .read(checkoutProvider.notifier)
          .createPaymentIntent(total);

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          merchantDisplayName: 'BuyV',
          paymentIntentClientSecret: paymentIntent.clientSecret,
          customerId: paymentIntent.customerId,
          customerEphemeralKeySecret: paymentIntent.ephemeralKey,
          style: ThemeMode.light,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      final order = await ref.read(checkoutProvider.notifier).checkout(
            shippingAddress: shippingAddress,
            paymentIntentId: paymentIntent.paymentIntentId,
          );

      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(content: Text('Commande ${order.orderNumber} creee avec succes.')),
      );
      final orderQuery = Uri(
        path: AppRoutes.orderSuccess,
        queryParameters: <String, String>{
          'orderId': order.id.toString(),
          'orderNumber': order.orderNumber,
          'total': order.total.toStringAsFixed(2),
        },
      );
      context.go(orderQuery.toString());
    } on stripe.StripeException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Paiement annule ou invalide: ${error.error.localizedMessage ?? error.error.message ?? 'Stripe error'}')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Paiement/commande impossible: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _applyAddress(AddressModel address) {
    _fullName.text = address.fullName;
    _address.text = address.address;
    _city.text = address.city;
    _state.text = address.state;
    _zip.text = address.zipCode;
    _country.text = address.country.isEmpty ? 'US' : address.country;
    _phone.text = address.phone;
  }
}

