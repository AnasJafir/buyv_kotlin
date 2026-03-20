import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/buyv_button.dart';
import '../../widgets/common/buyv_text_field.dart';
import '../../widgets/common/error_snackbar.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).register(
          _emailCtrl.text.trim(),
          _passCtrl.text,
          _usernameCtrl.text.trim(),
          _displayNameCtrl.text.trim(),
        );
    if (success && mounted) {
      context.go(AppRoutes.reels);
    } else if (!success && mounted) {
      final s = ref.read(authProvider);
      if (s is AuthError) showErrorSnackbar(context, s.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider) is AuthLoading;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Create Account'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Join BuyV 🎉',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text('Create your account and start earning',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              BuyVTextField(
                controller: _displayNameCtrl,
                label: 'Display Name',
                prefixIcon: Icons.person_outline,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              BuyVTextField(
                controller: _usernameCtrl,
                label: 'Username',
                prefixIcon: Icons.alternate_email,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Required';
                  if (v!.length < 3) return 'Min 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BuyVTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              BuyVTextField(
                controller: _passCtrl,
                label: 'Password',
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) {
                  if (v?.isEmpty == true) return 'Required';
                  if (v!.length < 8) return 'Min 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              BuyVButton(
                label: 'Create Account',
                isLoading: isLoading,
                onPressed: _register,
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => context.pop(),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
