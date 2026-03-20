import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  String _status = 'all';
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getAdminOrders();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getAdminOrders(status: _status == 'all' ? null : _status);
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commandes Admin')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Filtrer par statut'),
              items: const <String>['all', 'pending', 'processing', 'shipped', 'delivered', 'cancelled']
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
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
                  return const Center(child: Text('Aucune commande.'));
                }

                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final idText = (item['id'] ?? item['order_id'] ?? '').toString();
                      final orderId = int.tryParse(idText);
                      final status = (item['status'] ?? 'pending').toString();

                      return Card(
                        child: ListTile(
                          title: Text((item['order_number'] ?? 'Commande #$idText').toString()),
                          subtitle: Text(
                            'User: ${(item['user_email'] ?? item['user_id'] ?? '-')}\n'
                            'Total: ${(item['total_amount'] ?? 0)} | Status: $status',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (orderId == null) return;
                              try {
                                await AdminRemoteDataSource().updateOrderStatus(orderId, value);
                                await _reload();
                              } catch (error) {
                                if (context.mounted) showErrorSnackbar(context, error.toString());
                              }
                            },
                            itemBuilder: (_) => const <PopupMenuEntry<String>>[
                              PopupMenuItem(value: 'processing', child: Text('processing')),
                              PopupMenuItem(value: 'shipped', child: Text('shipped')),
                              PopupMenuItem(value: 'delivered', child: Text('delivered')),
                              PopupMenuItem(value: 'cancelled', child: Text('cancelled')),
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

