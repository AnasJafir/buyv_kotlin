import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../widgets/common/buyv_button.dart';
import '../../widgets/common/buyv_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _State();
}

class _State extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passCtrl.dispose(); _confirmCtrl.dispose(); _tokenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            BuyVTextField(
              controller: _tokenCtrl, label: 'Reset Code (from email)',
              prefixIcon: Icons.key_outlined,
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            BuyVTextField(
              controller: _passCtrl, label: 'New Password', obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: (v) => (v?.length ?? 0) < 8 ? 'Min 8 characters' : null,
            ),
            const SizedBox(height: 16),
            BuyVTextField(
              controller: _confirmCtrl, label: 'Confirm Password', obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: 32),
            BuyVButton(
              label: 'Reset Password',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: call API with token + new password
                  context.go(AppRoutes.passwordChanged);
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
