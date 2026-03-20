import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/promoter_remote_data_source.dart';
import 'auth_provider.dart';

final promoterRemoteDataSourceProvider = Provider<PromoterRemoteDataSource>((ref) {
  return PromoterRemoteDataSource();
});

final promoterStatusProvider = FutureProvider<PromoterStatusSummary>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getPromoterStatus();
});

final commissionsProvider = FutureProvider<List<CommissionEntry>>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getMyCommissions();
});

final promotionsProvider = FutureProvider<List<PromotionEntry>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const <PromotionEntry>[];
  }
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getMyPromotions(user.id);
});

final affiliateSalesProvider = FutureProvider<List<AffiliateSaleEntry>>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getMyAffiliateSales();
});

final walletOverviewProvider = FutureProvider<WalletOverview>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getWalletOverview();
});

final withdrawalStatsProvider = FutureProvider<WithdrawalStatsEntry>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getWithdrawalStats();
});

final withdrawalHistoryProvider = FutureProvider<List<WithdrawalHistoryEntry>>((ref) async {
  final dataSource = ref.watch(promoterRemoteDataSourceProvider);
  return dataSource.getWithdrawalHistory();
});

class PromoterActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> requestWithdrawal({
    required double amount,
    required String paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    state = const AsyncLoading();
    final dataSource = ref.read(promoterRemoteDataSourceProvider);

    try {
      await dataSource.createWithdrawalRequest(
        amount: amount,
        paymentMethod: paymentMethod,
        paymentDetails: paymentDetails,
      );
      ref.invalidate(withdrawalStatsProvider);
      ref.invalidate(withdrawalHistoryProvider);
      ref.invalidate(walletOverviewProvider);
      ref.invalidate(promoterStatusProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final promoterActionProvider = AsyncNotifierProvider<PromoterActionNotifier, void>(
  PromoterActionNotifier.new,
);
