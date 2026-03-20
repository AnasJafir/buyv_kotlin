import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/buyv_button.dart';
import '../../widgets/common/buyv_text_field.dart';
import '../../widgets/common/error_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passCtrl.text,
        );
    if (success && mounted) {
      context.go(AppRoutes.reels);
    } else if (!success && mounted) {
      final authState = ref.read(authProvider);
      if (authState is AuthError) {
        showErrorSnackbar(context, authState.message);
      }
    }
  }

  Future<void> _googleSignIn() async {
    try {
      final account = await GoogleSignIn().signIn();
      if (account == null) return;
      final auth = await account.authentication;
      if (auth.idToken == null) return;
      final success = await ref.read(authProvider.notifier).googleSignIn(auth.idToken!);
      if (success && mounted) context.go(AppRoutes.reels);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, 'Google sign-in failed.');
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return;
      final token = result.accessToken?.tokenString;
      if (token == null) return;
      final success = await ref.read(authProvider.notifier).facebookSignIn(token);
      if (success && mounted) context.go(AppRoutes.reels);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, 'Facebook sign-in failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Text(
                    'BuyV',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Shop. Share. Earn.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 40),

                Text('Welcome back 👋',
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text('Sign in to your account',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 32),

                // Email field
                BuyVTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) =>
                      v?.isEmpty == true ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 16),

                // Password field
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
                  validator: (v) =>
                      v?.isEmpty == true ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgetPassword),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                BuyVButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 24),

                // Divider
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Or continue with',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 20),

                // Social buttons
                Row(children: [
                  Expanded(
                    child: _SocialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata,
                      onTap: _googleSignIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      label: 'Facebook',
                      icon: Icons.facebook,
                      color: const Color(0xFF1877F2),
                      onTap: _facebookSignIn,
                    ),
                  ),
                ]),
                const SizedBox(height: 32),

                // Guest Mode — fixes AUTH-003
                Center(
                  child: TextButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).continueAsGuest();
                      context.go(AppRoutes.reels);
                    },
                    child: Text(
                      'Browse as Guest',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign up
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () => context.push(AppRoutes.createAccount),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size(0, 0),
      ),
    );
  }
}
