import 'package:flutter/material.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminCommentsScreen extends StatefulWidget {
  const AdminCommentsScreen({super.key});

  @override
  State<AdminCommentsScreen> createState() => _AdminCommentsScreenState();
}

class _AdminCommentsScreenState extends State<AdminCommentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminRemoteDataSource().getAdminComments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final next = AdminRemoteDataSource().getAdminComments(search: _searchController.text.trim());
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commentaires Admin')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _reload(),
              decoration: InputDecoration(
                hintText: 'Rechercher un commentaire...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _reload),
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
                  return const Center(child: Text('Aucun commentaire.'));
                }
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final commentId = int.tryParse((item['id'] ?? '').toString());
                      return Card(
                        child: ListTile(
                          title: Text((item['content'] ?? '').toString()),
                          subtitle: Text(
                            'Auteur: ${(item['author_username'] ?? item['user_uid'] ?? '-')}\n'
                            'Post: ${(item['post_id'] ?? '-')} | Date: ${(item['created_at'] ?? '')}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              if (commentId == null) return;
                              try {
                                await AdminRemoteDataSource().deleteAdminComment(commentId);
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
          ),
        ],
      ),
    );
  }
}

