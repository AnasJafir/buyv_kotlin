import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getMarketplaceCategories();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getMarketplaceCategories();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories Marketplace')),
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
            return const Center(child: Text('Aucune categorie.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final id = (item['id'] ?? '').toString();
                return Card(
                  child: ListTile(
                    title: Text((item['name'] ?? 'Categorie').toString()),
                    subtitle: Text((item['description'] ?? '').toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        if (id.isEmpty) return;
                        try {
                          await AdminRemoteDataSource().deleteMarketplaceCategory(id);
                          await _reload();
                        } catch (error) {
                          if (context.mounted) showErrorSnackbar(context, error.toString());
                        }
                      },
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

