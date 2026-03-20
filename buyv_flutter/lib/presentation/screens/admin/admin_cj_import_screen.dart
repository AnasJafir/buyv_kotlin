import 'package:flutter/material.dart';

import '../../../core/utils/html_sanitizer.dart';
import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminCjImportScreen extends StatefulWidget {
  const AdminCjImportScreen({super.key});

  @override
  State<AdminCjImportScreen> createState() => _AdminCjImportScreenState();
}

class _AdminCjImportScreenState extends State<AdminCjImportScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<Map<String, dynamic>> _results = const <Map<String, dynamic>>[];
  bool _loading = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      showErrorSnackbar(context, 'Requete requise.');
      return;
    }

    setState(() => _loading = true);
    try {
      final items = await AdminRemoteDataSource().searchCjProducts(query);
      setState(() => _results = items);
    } catch (error) {
      if (mounted) showErrorSnackbar(context, error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _importProduct(Map<String, dynamic> item) async {
    final productId = (item['product_id'] ?? item['id'] ?? item['pid'] ?? '').toString();
    if (productId.isEmpty) {
      showErrorSnackbar(context, 'Produit CJ invalide.');
      return;
    }
    try {
      await AdminRemoteDataSource().importCjProduct(cjProductId: productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit importe.')),
        );
      }
    } catch (error) {
      if (mounted) showErrorSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CJ Import Admin')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(hintText: 'Rechercher sur CJ...'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _search, child: const Text('Search')),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text('Aucun resultat.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          final title = HtmlSanitizer.stripTags(
                            HtmlSanitizer.removeObjectReplacementChars(
                              (item['name'] ?? item['product_name'] ?? 'Produit CJ').toString(),
                            ),
                          );
                          final description = HtmlSanitizer.stripTags(
                            HtmlSanitizer.removeObjectReplacementChars(
                              (item['description'] ?? '').toString(),
                            ),
                          );
                          return Card(
                            child: ListTile(
                              title: Text(title.isEmpty ? 'Produit CJ' : title),
                              subtitle: Text(description),
                              trailing: FilledButton(
                                onPressed: () => _importProduct(item),
                                child: const Text('Import'),
                              ),
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

