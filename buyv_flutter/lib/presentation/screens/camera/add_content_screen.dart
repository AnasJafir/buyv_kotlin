import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/post_remote_data_source.dart';
import '../../../data/models/post_models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reels_feed_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

class AddContentScreen extends ConsumerStatefulWidget {
  const AddContentScreen({super.key});

  @override
  ConsumerState<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends ConsumerState<AddContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mediaUrlController = TextEditingController();
  final _captionController = TextEditingController();
  String _type = 'reel';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _mediaUrlController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    Future<void> submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() => _isSubmitting = true);

      try {
        final dataSource = PostRemoteDataSource();
        await dataSource.createPost(
          PostCreateRequest(
            type: _type,
            mediaUrl: _mediaUrlController.text.trim(),
            caption: _captionController.text.trim().isEmpty
                ? null
                : _captionController.text.trim(),
          ),
        );
        ref.read(reelsFeedProvider.notifier).refresh();

        if (context.mounted) {
          showSuccessSnackbar(context, 'Publication creee avec succes.');
          context.go(AppRoutes.reels);
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter du contenu')),
      body: !isAuthenticated
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Connexion requise pour publier.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type de contenu'),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: 'reel', child: Text('Reel')),
                      DropdownMenuItem(value: 'photo', child: Text('Photo')),
                      DropdownMenuItem(value: 'product', child: Text('Produit')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _type = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mediaUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL media',
                      hintText: 'https://.../video.mp4 ou image.jpg',
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'URL media requise.';
                      }
                      final uri = Uri.tryParse(text);
                      if (uri == null || !uri.hasAbsolutePath || uri.scheme.isEmpty) {
                        return 'URL invalide.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _captionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Caption (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: _isSubmitting ? null : submit,
                    icon: const Icon(Icons.publish_outlined),
                    label: Text(_isSubmitting ? 'Publication...' : 'Publier'),
                  ),
                ],
              ),
            ),
    );
  }
}

