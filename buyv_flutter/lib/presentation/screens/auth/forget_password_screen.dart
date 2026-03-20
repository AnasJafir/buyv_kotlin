import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/buyv_button.dart';
import '../../widgets/common/buyv_text_field.dart';
import '../../widgets/common/error_snackbar.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _State();
}

class _State extends ConsumerState<ForgetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ok = await ref.read(authProvider.notifier).sendPasswordReset(_emailCtrl.text.trim());
    if (ok && mounted) {
      context.push(AppRoutes.resetPassword);
    } else if (mounted) {
      final s = ref.read(authProvider);
      if (s is AuthError) showErrorSnackbar(context, s.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider) is AuthLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_reset, size: 56, color: Color(0xFFF4A032)),
              const SizedBox(height: 16),
              Text('Reset your password', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("Enter your email and we'll send you a reset link.",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              BuyVTextField(
                controller: _emailCtrl,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (v) => v?.isEmpty == true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 24),
              BuyVButton(label: 'Send Reset Link', isLoading: isLoading, onPressed: _send),
            ],
          ),
        ),
      ),
    );
  }
}
