import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';

class AdminFollowsScreen extends StatefulWidget {
  const AdminFollowsScreen({super.key});

  @override
  State<AdminFollowsScreen> createState() => _AdminFollowsScreenState();
}

class _AdminFollowsScreenState extends State<AdminFollowsScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getFollowStats();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getFollowStats();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Follows Admin')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Chargement impossible: ${snapshot.error}'));
          }
          final stats = snapshot.data ?? const <String, dynamic>{};
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _StatsTile(label: 'Total follows', value: (stats['total_follows'] ?? 0).toString()),
                _StatsTile(label: 'Total followers', value: (stats['total_followers'] ?? 0).toString()),
                _StatsTile(label: 'Total following', value: (stats['total_following'] ?? 0).toString()),
                _StatsTile(label: 'Mutual follows', value: (stats['mutual_follows'] ?? 0).toString()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsTile extends StatelessWidget {
  const _StatsTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

