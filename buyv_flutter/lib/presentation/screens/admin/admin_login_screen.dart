import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/admin_remote_data_source.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() => _submitting = true);
      try {
        await AdminRemoteDataSource().adminLogin(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (context.mounted) {
          context.go(AppRoutes.adminDashboard);
        }
      } catch (error) {
        if (context.mounted) {
          showErrorSnackbar(context, error.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _submitting = false);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email admin'),
              validator: (value) {
                final text = value?.trim() ?? '';
                return text.contains('@') ? null : 'Email invalide';
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              validator: (value) => (value?.isNotEmpty == true) ? null : 'Mot de passe requis',
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _submitting ? null : submit,
              child: Text(_submitting ? 'Connexion...' : 'Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}

