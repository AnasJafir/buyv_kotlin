import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminAffiliateSalesScreen extends StatefulWidget {
  const AdminAffiliateSalesScreen({super.key});

  @override
  State<AdminAffiliateSalesScreen> createState() => _AdminAffiliateSalesScreenState();
}

class _AdminAffiliateSalesScreenState extends State<AdminAffiliateSalesScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getAdminAffiliateSales();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getAdminAffiliateSales();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affiliate Sales Admin')),
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
            return const Center(child: Text('Aucune vente affiliee.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final saleId = (item['id'] ?? '').toString();
                final status = (item['commission_status'] ?? item['status'] ?? 'pending').toString();

                return Card(
                  child: ListTile(
                    title: Text((item['product_name'] ?? 'Sale').toString()),
                    subtitle: Text(
                      'Promoter: ${(item['promoter_uid'] ?? item['user_id'] ?? '-')}\n'
                      'Commission: ${(item['commission_amount'] ?? 0)} | Status: $status',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (saleId.isEmpty) return;
                        try {
                          await AdminRemoteDataSource().updateAffiliateSaleStatus(
                            saleId: saleId,
                            status: value,
                          );
                          await _reload();
                        } catch (error) {
                          if (context.mounted) showErrorSnackbar(context, error.toString());
                        }
                      },
                      itemBuilder: (_) => const <PopupMenuEntry<String>>[
                        PopupMenuItem(value: 'approved', child: Text('approved')),
                        PopupMenuItem(value: 'paid', child: Text('paid')),
                      ],
                    ),
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

