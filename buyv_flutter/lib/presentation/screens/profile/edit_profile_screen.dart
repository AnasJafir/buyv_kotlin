import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/error_snackbar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final action = ref.watch(profileActionProvider);

    if (!_initialized && user != null) {
      _displayNameController.text = user.displayName;
      _bioController.text = user.bio ?? '';
      _imageUrlController.text = user.profileImageUrl ?? '';
      _initialized = true;
    }

    Future<void> save() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        await ref.read(profileActionProvider.notifier).updateProfile(
              displayName: _displayNameController.text.trim(),
              bio: _bioController.text.trim(),
              profileImageUrl: _imageUrlController.text.trim().isEmpty
                  ? null
                  : _imageUrlController.text.trim(),
            );
        if (context.mounted) {
          showSuccessSnackbar(context, 'Profil mis a jour.');
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editer mon profil')),
      body: user == null
          ? const Center(child: Text('Connexion requise.'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(labelText: 'Nom affiche'),
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.length < 2) {
                        return 'Minimum 2 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Bio'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: 'URL photo profil'),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: action.isLoading ? null : save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
                  ),
                ],
              ),
            ),
    );
  }
}

