import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminWithdrawalScreen extends StatefulWidget {
  const AdminWithdrawalScreen({super.key});

  @override
  State<AdminWithdrawalScreen> createState() => _AdminWithdrawalScreenState();
}

class _AdminWithdrawalScreenState extends State<AdminWithdrawalScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getAdminWithdrawals();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getAdminWithdrawals();
    setState(() => _future = next);
    await next;
  }

  Future<void> _process(Map<String, dynamic> item, String action) async {
    final id = int.tryParse((item['id'] ?? '').toString());
    if (id == null) return;

    try {
      final ds = AdminRemoteDataSource();
      if (action == 'approve') {
        await ds.approveWithdrawal(id);
      } else if (action == 'reject') {
        await ds.rejectWithdrawal(id, reason: 'Rejected by admin');
      } else if (action == 'complete') {
        await ds.completeWithdrawal(id, transactionId: 'admin-manual-$id');
      }
      await _reload();
    } catch (error) {
      if (mounted) showErrorSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdrawals Admin')),
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
            return const Center(child: Text('Aucun retrait.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final status = (item['status'] ?? 'pending').toString();
                return Card(
                  child: ListTile(
                    title: Text('Retrait #${item['id'] ?? '-'}'),
                    subtitle: Text(
                      'User: ${(item['user_id'] ?? '-')}\n'
                      'Amount: ${(item['amount'] ?? 0)} | Status: $status',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _process(item, value),
                      itemBuilder: (_) => const <PopupMenuEntry<String>>[
                        PopupMenuItem(value: 'approve', child: Text('approve')),
                        PopupMenuItem(value: 'reject', child: Text('reject')),
                        PopupMenuItem(value: 'complete', child: Text('complete')),
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

