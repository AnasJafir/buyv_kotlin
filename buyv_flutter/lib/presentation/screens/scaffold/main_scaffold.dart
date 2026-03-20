import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/error_snackbar.dart';

/// Bottom navigation scaffold — wraps all main tabs.
/// Matches KMP's BottomNavigationBar with Reels, Products, [Buy FAB], Cart, Profile.
class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.reels)) return 0;
    if (location.startsWith(AppRoutes.products)) return 1;
    if (location.startsWith(AppRoutes.cart)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _selectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: _BuyVBottomNav(currentIndex: idx),
    );
  }
}

class _BuyVBottomNav extends ConsumerWidget {
  final int currentIndex;
  const _BuyVBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    Future<void> openAddContent() async {
      if (!isAuthenticated) {
        await showAuthRequiredSheet(context);
        return;
      }
      if (!context.mounted) {
        return;
      }
      context.push(AppRoutes.addContent);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(index: 0, current: currentIndex, icon: Icons.play_circle_outline, label: 'Reels',
                  onTap: () => context.go(AppRoutes.reels)),
              _NavItem(index: 1, current: currentIndex, icon: Icons.grid_view_outlined, label: 'Products',
                  onTap: () => context.go(AppRoutes.products)),
              // Central Buy FAB — fixes UI-001 (no border) and UPLOAD-001 (visible CTA)
                _BuyFab(onTap: openAddContent),
              _NavItem(index: 2, current: currentIndex, icon: Icons.shopping_bag_outlined, label: 'Cart',
                  onTap: () => context.go(AppRoutes.cart)),
              _NavItem(index: 3, current: currentIndex, icon: Icons.person_outline, label: 'Profile',
                  onTap: () => context.go(AppRoutes.profile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int current;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == current;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}

/// Central orange Buy/Upload FAB — replaces the '+' button, fixes UI-001 and UPLOAD-001.
class _BuyFab extends StatelessWidget {
  final VoidCallback onTap;
  const _BuyFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
