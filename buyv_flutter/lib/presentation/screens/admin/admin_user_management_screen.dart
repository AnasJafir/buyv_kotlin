import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload({String? search}) async {
    final next = AdminRemoteDataSource().getUsers(search: search);
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion Utilisateurs')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _reload(search: value.trim()),
              decoration: InputDecoration(
                hintText: 'Rechercher username/email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _reload(search: _searchController.text.trim()),
                ),
              ),
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
                  return const Center(child: Text('Aucun utilisateur.'));
                }

                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final uid = (item['id'] ?? '').toString();
                      final verified = item['is_verified'] == true;

                      return Card(
                        child: ListTile(
                          title: Text((item['display_name'] ?? item['username'] ?? 'User').toString()),
                          subtitle: Text(
                            '@${(item['username'] ?? '').toString()}\n${(item['email'] ?? '').toString()}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              try {
                                final dataSource = AdminRemoteDataSource();
                                if (value == 'verify') {
                                  await dataSource.verifyUsers(<String>[uid]);
                                } else if (value == 'unverify') {
                                  await dataSource.unverifyUsers(<String>[uid]);
                                } else if (value == 'delete') {
                                  await dataSource.deleteUser(uid);
                                }
                                await _reload(search: _searchController.text.trim());
                              } catch (error) {
                                if (context.mounted) {
                                  showErrorSnackbar(context, error.toString());
                                }
                              }
                            },
                            itemBuilder: (_) => <PopupMenuEntry<String>>[
                              if (!verified)
                                const PopupMenuItem(value: 'verify', child: Text('Verifier')),
                              if (verified)
                                const PopupMenuItem(value: 'unverify', child: Text('Retirer verification')),
                              const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
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

