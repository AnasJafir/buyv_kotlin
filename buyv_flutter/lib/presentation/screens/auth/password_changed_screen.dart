import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../router/app_router.dart';
import '../../widgets/common/buyv_button.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 56, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              Text('Password Changed!', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 12),
              Text('Your password has been reset successfully. Sign in with your new password.',
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              BuyVButton(
                label: 'Sign In',
                onPressed: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
