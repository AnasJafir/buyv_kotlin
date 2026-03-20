import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';

class AdminPromoterWalletsScreen extends StatefulWidget {
  const AdminPromoterWalletsScreen({super.key});

  @override
  State<AdminPromoterWalletsScreen> createState() => _AdminPromoterWalletsScreenState();
}

class _AdminPromoterWalletsScreenState extends State<AdminPromoterWalletsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadWalletSummary();
  }

  Future<List<Map<String, dynamic>>> _loadWalletSummary() async {
    final sales = await AdminRemoteDataSource().getAdminAffiliateSales();
    final Map<String, _WalletAgg> byPromoter = <String, _WalletAgg>{};

    for (final sale in sales) {
      final key = (sale['promoter_uid'] ?? sale['user_id'] ?? 'unknown').toString();
      final amount = _toDouble(sale['commission_amount']);
      final status = (sale['commission_status'] ?? sale['status'] ?? 'pending').toString();
      final agg = byPromoter.putIfAbsent(key, () => _WalletAgg());
      agg.total += amount;
      if (status == 'paid') {
        agg.paid += amount;
      } else {
        agg.pending += amount;
      }
      agg.sales += 1;
    }

    return byPromoter.entries
        .map(
          (entry) => <String, dynamic>{
            'promoter': entry.key,
            'sales': entry.value.sales,
            'total': entry.value.total,
            'paid': entry.value.paid,
            'pending': entry.value.pending,
          },
        )
        .toList(growable: false);
  }

  Future<void> _reload() async {
    final next = _loadWalletSummary();
    setState(() => _future = next);
    await next;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promoter Wallets')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Chargement impossible: ${snapshot.error}'));
          }
          final items = snapshot.data ?? const <Map<String, dynamic>>[];
          if (items.isEmpty) {
            return const Center(child: Text('Aucun wallet a afficher.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text((item['promoter'] ?? '-').toString()),
                    subtitle: Text(
                      'Sales: ${(item['sales'] ?? 0)}\n'
                      'Total: ${(item['total'] ?? 0)} | Paid: ${(item['paid'] ?? 0)} | Pending: ${(item['pending'] ?? 0)}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WalletAgg {
  int sales = 0;
  double total = 0;
  double paid = 0;
  double pending = 0;
}

