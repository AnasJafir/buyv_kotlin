import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminCommissionScreen extends StatefulWidget {
  const AdminCommissionScreen({super.key});

  @override
  State<AdminCommissionScreen> createState() => _AdminCommissionScreenState();
}

class _AdminCommissionScreenState extends State<AdminCommissionScreen> {
  String _status = 'all';
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getAdminCommissions();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getAdminCommissions(
      status: _status == 'all' ? null : _status,
    );
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commissions Admin')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Filtrer par statut'),
              items: const <String>['all', 'pending', 'approved', 'paid', 'canceled']
                  .map((value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _status = value);
                _reload();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                  return const Center(child: Text('Aucune commission.'));
                }

                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final idText = (item['id'] ?? '').toString();
                      final id = int.tryParse(idText);
                      final status = (item['status'] ?? 'pending').toString();

                      return Card(
                        child: ListTile(
                          title: Text((item['productName'] ?? item['product_name'] ?? 'Commission').toString()),
                          subtitle: Text(
                            'User: ${(item['userId'] ?? item['user_uid'] ?? '-')}\n'
                            'Amount: ${(item['commissionAmount'] ?? item['commission_amount'] ?? 0)} | Status: $status',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (id == null) return;
                              try {
                                await AdminRemoteDataSource().updateCommissionStatus(id, value);
                                await _reload();
                              } catch (error) {
                                if (context.mounted) showErrorSnackbar(context, error.toString());
                              }
                            },
                            itemBuilder: (_) => const <PopupMenuEntry<String>>[
                              PopupMenuItem(value: 'approved', child: Text('approved')),
                              PopupMenuItem(value: 'paid', child: Text('paid')),
                              PopupMenuItem(value: 'canceled', child: Text('canceled')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

