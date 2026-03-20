import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/token_manager.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/create_account_screen.dart';
import '../screens/auth/forget_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/password_changed_screen.dart';
import '../screens/reels/reels_feed_screen.dart';
import '../screens/reels/explore_screen.dart';
import '../screens/reels/search_reels_screen.dart';
import '../screens/reels/sound_page_screen.dart';
import '../screens/product/product_list_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/product/search_screen.dart';
import '../screens/product/all_products_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/cart/payment_screen.dart';
import '../screens/order/orders_history_screen.dart';
import '../screens/order/order_success_screen.dart';
import '../screens/order/track_order_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/social/user_profile_screen.dart';
import '../screens/social/follow_list_screen.dart';
import '../screens/social/user_search_screen.dart';
import '../screens/social/blocked_users_screen.dart';
import '../screens/profile/favourites_screen.dart';
import '../screens/profile/recently_viewed_screen.dart';
import '../screens/profile/notifications_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/camera/add_content_screen.dart';
import '../screens/marketplace/marketplace_screen.dart';
import '../screens/marketplace/marketplace_product_detail_screen.dart';
import '../screens/promoter/promoter_dashboard_screen.dart';
import '../screens/promoter/my_commissions_screen.dart';
import '../screens/promoter/my_promotions_screen.dart';
import '../screens/promoter/wallet_screen.dart';
import '../screens/promoter/affiliate_sales_screen.dart';
import '../screens/promoter/withdrawal_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_withdrawal_screen.dart';
import '../screens/admin/admin_user_management_screen.dart';
import '../screens/admin/admin_product_management_screen.dart';
import '../screens/admin/admin_order_screen.dart';
import '../screens/admin/admin_commission_screen.dart';
import '../screens/admin/admin_cj_import_screen.dart';
import '../screens/admin/admin_follows_screen.dart';
import '../screens/admin/admin_posts_screen.dart';
import '../screens/admin/admin_comments_screen.dart';
import '../screens/admin/admin_categories_screen.dart';
import '../screens/admin/admin_affiliate_sales_screen.dart';
import '../screens/admin/admin_promoter_wallets_screen.dart';
import '../screens/admin/admin_notifications_screen.dart';
import '../screens/scaffold/main_scaffold.dart';

/// Route name constants — mirrors KMP's Screens.kt sealed class.
abstract class AppRoutes {
  // Auth
  static const login = '/login';
  static const createAccount = '/create-account';
  static const forgetPassword = '/forget-password';
  static const resetPassword = '/reset-password';
  static const passwordChanged = '/password-changed';

  // Main (shell)
  static const home = '/';
  static const reels = '/reels';
  static const explore = '/reels/explore';
  static const searchReels = '/reels/search';
  static const soundPage = '/reels/sound';
  static const products = '/products';
  static const productDetail = '/products/:productId';
  static const searchProducts = '/products/search';
  static const allProducts = '/products/all';
  static const cart = '/cart';
  static const payment = '/cart/payment';
  static const orderSuccess = '/cart/success';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const ordersHistory = '/profile/orders';
  static const trackOrder = '/profile/orders/:orderId';
  static const settings = '/profile/settings';
  static const notifications = '/profile/notifications';
  static const favourites = '/profile/favourites';
  static const recentlyViewed = '/profile/recently-viewed';
  static const blockedUsers = '/profile/blocked-users';
  static const addContent = '/profile/add-content';

  // Social
  static const userSearch = '/social/search';
  static const userProfile = '/social/user/:userId';
  static const followList = '/social/follows/:userId';

  // Camera
  static const camera = '/camera';

  // Marketplace
  static const marketplace = '/marketplace';
  static const marketplaceProductDetail = '/marketplace/:productId';

  // Promoter
  static const promoterDashboard = '/promoter';
  static const myCommissions = '/promoter/commissions';
  static const myPromotions = '/promoter/promotions';
  static const wallet = '/promoter/wallet';
  static const affiliateSales = '/promoter/affiliate-sales';
  static const withdrawal = '/promoter/withdrawal';

  // Admin
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const adminWithdrawal = '/admin/withdrawal';
  static const adminUserManagement = '/admin/users';
  static const adminProductManagement = '/admin/products';
  static const adminOrders = '/admin/orders';
  static const adminCommissions = '/admin/commissions';
  static const adminCjImport = '/admin/cj-import';
  static const adminFollows = '/admin/follows';
  static const adminPosts = '/admin/posts';
  static const adminComments = '/admin/comments';
  static const adminCategories = '/admin/categories';
  static const adminAffiliateSales = '/admin/affiliate-sales';
  static const adminPromoterWallets = '/admin/promoter-wallets';
  static const adminNotifications = '/admin/notifications';
}

/// Riverpod provider for the router (enables redirect based on auth state)
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.reels,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final isLoggedIn = await TokenManager.isLoggedIn();
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/create-account') ||
          state.matchedLocation.startsWith('/forget-password');

      // Allow reels feed in guest mode (fixes AUTH-003/004)
      if (!isLoggedIn && !isAuthRoute) {
        // Only block admin/profile actions, not browsing
        final requiresAuth = state.matchedLocation.startsWith('/admin') ||
            state.matchedLocation.startsWith('/promoter') ||
            state.matchedLocation == AppRoutes.editProfile ||
            state.matchedLocation == AppRoutes.profile;
        if (requiresAuth) return AppRoutes.login;
      }
      return null;
    },
    routes: [
      // ── Auth Routes ─────────────────────────────────────────────────
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.createAccount, builder: (_, __) => const CreateAccountScreen()),
      GoRoute(path: AppRoutes.forgetPassword, builder: (_, __) => const ForgetPasswordScreen()),
      GoRoute(path: AppRoutes.resetPassword, builder: (_, __) => const ResetPasswordScreen()),
      GoRoute(path: AppRoutes.passwordChanged, builder: (_, __) => const PasswordChangedScreen()),

      // ── Admin Routes (standalone — no shell) ────────────────────────
      GoRoute(path: AppRoutes.adminLogin, builder: (_, __) => const AdminLoginScreen()),
      GoRoute(path: AppRoutes.adminDashboard, builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: AppRoutes.adminWithdrawal, builder: (_, __) => const AdminWithdrawalScreen()),
      GoRoute(path: AppRoutes.adminUserManagement, builder: (_, __) => const AdminUserManagementScreen()),
      GoRoute(path: AppRoutes.adminProductManagement, builder: (_, __) => const AdminProductManagementScreen()),
      GoRoute(path: AppRoutes.adminOrders, builder: (_, __) => const AdminOrderScreen()),
      GoRoute(path: AppRoutes.adminCommissions, builder: (_, __) => const AdminCommissionScreen()),
      GoRoute(path: AppRoutes.adminCjImport, builder: (_, __) => const AdminCjImportScreen()),
      GoRoute(path: AppRoutes.adminFollows, builder: (_, __) => const AdminFollowsScreen()),
      GoRoute(path: AppRoutes.adminPosts, builder: (_, __) => const AdminPostsScreen()),
      GoRoute(path: AppRoutes.adminComments, builder: (_, __) => const AdminCommentsScreen()),
      GoRoute(path: AppRoutes.adminCategories, builder: (_, __) => const AdminCategoriesScreen()),
      GoRoute(path: AppRoutes.adminAffiliateSales, builder: (_, __) => const AdminAffiliateSalesScreen()),
      GoRoute(path: AppRoutes.adminPromoterWallets, builder: (_, __) => const AdminPromoterWalletsScreen()),
      GoRoute(path: AppRoutes.adminNotifications, builder: (_, __) => const AdminNotificationsScreen()),

      // ── Main Shell (Bottom Nav) ──────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Reels
          GoRoute(
            path: AppRoutes.reels,
            builder: (_, __) => const ReelsFeedScreen(),
            routes: [
              GoRoute(path: 'explore', builder: (_, __) => const ExploreScreen()),
              GoRoute(path: 'search', builder: (_, __) => const SearchReelsScreen()),
              GoRoute(
                path: 'sound',
                builder: (context, state) {
                  final videoUrl = state.uri.queryParameters['videoUrl'] ?? '';
                  return SoundPageScreen(videoUrl: videoUrl);
                },
              ),
            ],
          ),
          // Products
          GoRoute(
            path: AppRoutes.products,
            builder: (_, __) => const ProductListScreen(),
            routes: [
              GoRoute(path: 'search', builder: (_, __) => const SearchScreen()),
              GoRoute(path: 'all', builder: (_, __) => const AllProductsScreen()),
              GoRoute(
                path: ':productId',
                builder: (context, state) =>
                    ProductDetailScreen(productId: state.pathParameters['productId']!),
              ),
            ],
          ),
          // Cart
          GoRoute(
            path: AppRoutes.cart,
            builder: (_, __) => const CartScreen(),
            routes: [
              GoRoute(path: 'payment', builder: (_, __) => const PaymentScreen()),
              GoRoute(
                path: 'success',
                builder: (context, state) {
                  final orderId = int.tryParse(state.uri.queryParameters['orderId'] ?? '');
                  final orderNumber = state.uri.queryParameters['orderNumber'] ?? '';
                  final total = double.tryParse(state.uri.queryParameters['total'] ?? '') ?? 0.0;
                  return OrderSuccessScreen(
                    orderId: orderId,
                    orderNumber: orderNumber,
                    total: total,
                  );
                },
              ),
            ],
          ),
          // Profile
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(path: 'edit', builder: (_, __) => const EditProfileScreen()),
              GoRoute(path: 'settings', builder: (_, __) => const SettingsScreen()),
              GoRoute(path: 'notifications', builder: (_, __) => const NotificationsScreen()),
              GoRoute(path: 'favourites', builder: (_, __) => const FavouritesScreen()),
              GoRoute(path: 'recently-viewed', builder: (_, __) => const RecentlyViewedScreen()),
              GoRoute(path: 'blocked-users', builder: (_, __) => const BlockedUsersScreen()),
              GoRoute(path: 'add-content', builder: (_, __) => const AddContentScreen()),
              GoRoute(
                path: 'orders',
                builder: (_, __) => const OrdersHistoryScreen(),
                routes: [
                  GoRoute(
                    path: ':orderId',
                    builder: (context, state) =>
                        TrackOrderScreen(orderId: state.pathParameters['orderId']!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Social (full-screen, no shell) ──────────────────────────────
      GoRoute(path: AppRoutes.userSearch, builder: (_, __) => const UserSearchScreen()),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) =>
            UserProfileScreen(userId: state.pathParameters['userId']!),
      ),
      GoRoute(
        path: AppRoutes.followList,
        builder: (context, state) => FollowListScreen(
          userId: state.pathParameters['userId']!,
          startTab: int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0,
        ),
      ),

      // ── Camera ──────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.camera, builder: (_, __) => const CameraScreen()),

      // ── Marketplace ────────────────────────────────────────────────
      GoRoute(path: AppRoutes.marketplace, builder: (_, __) => const MarketplaceScreen()),
      GoRoute(
        path: AppRoutes.marketplaceProductDetail,
        builder: (context, state) =>
            MarketplaceProductDetailScreen(productId: state.pathParameters['productId']!),
      ),

      // ── Promoter ────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.promoterDashboard, builder: (_, __) => const PromoterDashboardScreen()),
      GoRoute(path: AppRoutes.myCommissions, builder: (_, __) => const MyCommissionsScreen()),
      GoRoute(path: AppRoutes.myPromotions, builder: (_, __) => const MyPromotionsScreen()),
      GoRoute(path: AppRoutes.wallet, builder: (_, __) => const WalletScreen()),
      GoRoute(path: AppRoutes.affiliateSales, builder: (_, __) => const AffiliateSalesScreen()),
      GoRoute(path: AppRoutes.withdrawal, builder: (_, __) => const WithdrawalScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});
