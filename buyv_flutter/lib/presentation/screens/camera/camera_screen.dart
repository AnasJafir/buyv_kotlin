import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    Future<bool> ensureAuthenticated() async {
      if (isAuthenticated) {
        return true;
      }
      await showAuthRequiredSheet(context);
      return false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Creer du contenu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_photo_alternate_outlined),
                title: const Text('Ajouter via URL media'),
                subtitle: const Text('Publier reel, photo ou produit a partir d une URL.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (!await ensureAuthenticated()) {
                    return;
                  }
                  if (!context.mounted) {
                    return;
                  }
                  context.push(AppRoutes.addContent);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choisir une image locale'),
                subtitle: const Text('Prepare un upload image depuis la galerie.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (!await ensureAuthenticated()) {
                    return;
                  }
                  final picker = ImagePicker();
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  if (!context.mounted) {
                    return;
                  }
                  if (file == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Aucune image selectionnee.')),
                    );
                    return;
                  }
                  context.push(AppRoutes.addContent);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: const Text('Choisir une video locale'),
                subtitle: const Text('Prepare un upload reel depuis la galerie.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (!await ensureAuthenticated()) {
                    return;
                  }
                  final picker = ImagePicker();
                  final file = await picker.pickVideo(source: ImageSource.gallery);
                  if (!context.mounted) {
                    return;
                  }
                  if (file == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Aucune video selectionnee.')),
                    );
                    return;
                  }
                  context.push(AppRoutes.addContent);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

