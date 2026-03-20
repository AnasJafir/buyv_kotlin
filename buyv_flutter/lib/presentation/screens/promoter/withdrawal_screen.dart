import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/promoter_provider.dart';
import '../../widgets/common/error_snackbar.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _paymentMethod = 'paypal';

  @override
  void dispose() {
    _amountController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(withdrawalStatsProvider);
    final historyAsync = ref.watch(withdrawalHistoryProvider);
    final action = ref.watch(promoterActionProvider);

    Future<void> submitRequest() async {
      final amount = double.tryParse(_amountController.text.trim());
      if (amount == null || amount <= 0) {
        showErrorSnackbar(context, 'Montant invalide.');
        return;
      }

      if (_paymentMethod == 'paypal' && _emailController.text.trim().isEmpty) {
        showErrorSnackbar(context, 'Email PayPal requis.');
        return;
      }

      final paymentDetails = <String, dynamic>{
        if (_paymentMethod == 'paypal') 'email': _emailController.text.trim(),
      };

      try {
        await ref.read(promoterActionProvider.notifier).requestWithdrawal(
              amount: amount,
              paymentMethod: _paymentMethod,
              paymentDetails: paymentDetails,
            );
        if (context.mounted) {
          showSuccessSnackbar(context, 'Demande de retrait envoyee.');
          _amountController.clear();
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Retraits')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(withdrawalStatsProvider);
          ref.invalidate(withdrawalHistoryProvider);
          await Future.wait(<Future<void>>[
            ref.read(withdrawalStatsProvider.future),
            ref.read(withdrawalHistoryProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            statsAsync.when(
              data: (stats) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Disponible: ${stats.availableBalance.toStringAsFixed(2)} USD'),
                      Text('En attente: ${stats.pendingBalance.toStringAsFixed(2)} USD'),
                      Text('Retire: ${stats.totalWithdrawn.toStringAsFixed(2)} USD'),
                      Text('Demandes: ${stats.totalRequestsCount}'),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Chargement impossible: $error'),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Nouvelle demande', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Montant USD (min 50)'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _paymentMethod,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'paypal', child: Text('PayPal')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _paymentMethod = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Methode de paiement'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email PayPal'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: action.isLoading ? null : submitRequest,
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Envoyer la demande'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Historique', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            historyAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Text('Aucun retrait enregistre.');
                }
                return Column(
                  children: items.map((item) {
                    final date = DateTime.tryParse(item.createdAt);
                    final label = date == null
                        ? '--'
                        : DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());

                    return Card(
                      child: ListTile(
                        title: Text('${item.amount.toStringAsFixed(2)} USD'),
                        subtitle: Text('${item.paymentMethod} • $label'),
                        trailing: Text(item.status.toUpperCase()),
                      ),
                    );
                  }).toList(growable: false),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Historique indisponible: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

