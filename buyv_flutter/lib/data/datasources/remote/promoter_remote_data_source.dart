import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class PromoterStatusSummary {
  const PromoterStatusSummary({
    required this.isPromoter,
    required this.totalEarned,
    required this.availableBalance,
    required this.pendingAmount,
    required this.totalWithdrawn,
  });

  final bool isPromoter;
  final double totalEarned;
  final double availableBalance;
  final double pendingAmount;
  final double totalWithdrawn;
}

class CommissionEntry {
  const CommissionEntry({
    required this.id,
    required this.productName,
    required this.commissionAmount,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String productName;
  final double commissionAmount;
  final String status;
  final String createdAt;
}

class PromotionEntry {
  const PromotionEntry({
    required this.id,
    required this.postId,
    required this.viewsCount,
    required this.clicksCount,
    required this.salesCount,
    required this.totalCommissionEarned,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final int viewsCount;
  final int clicksCount;
  final int salesCount;
  final double totalCommissionEarned;
  final String createdAt;
}

class AffiliateSaleEntry {
  const AffiliateSaleEntry({
    required this.id,
    required this.saleAmount,
    required this.commissionAmount,
    required this.commissionStatus,
    required this.createdAt,
  });

  final String id;
  final double saleAmount;
  final double commissionAmount;
  final String commissionStatus;
  final String createdAt;
}

class WalletOverview {
  const WalletOverview({
    required this.totalEarned,
    required this.pendingAmount,
    required this.availableAmount,
    required this.withdrawnAmount,
    required this.totalSalesCount,
  });

  final double totalEarned;
  final double pendingAmount;
  final double availableAmount;
  final double withdrawnAmount;
  final int totalSalesCount;
}

class WithdrawalStatsEntry {
  const WithdrawalStatsEntry({
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalWithdrawn,
    required this.pendingRequestsCount,
    required this.approvedRequestsCount,
    required this.totalRequestsCount,
  });

  final double availableBalance;
  final double pendingBalance;
  final double totalWithdrawn;
  final int pendingRequestsCount;
  final int approvedRequestsCount;
  final int totalRequestsCount;
}

class WithdrawalHistoryEntry {
  const WithdrawalHistoryEntry({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final double amount;
  final String paymentMethod;
  final String status;
  final String createdAt;
}

class PromoterRemoteDataSource {
  PromoterRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<PromoterStatusSummary> getPromoterStatus() async {
    final response = await _dio.get('/users/me/promoter-status');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const PromoterStatusSummary(
        isPromoter: false,
        totalEarned: 0,
        availableBalance: 0,
        pendingAmount: 0,
        totalWithdrawn: 0,
      );
    }

    final wallet = data['wallet'];
    final walletMap = wallet is Map<String, dynamic> ? wallet : const <String, dynamic>{};

    return PromoterStatusSummary(
      isPromoter: _asBool(data['is_promoter'] ?? data['isPromoter']),
      totalEarned: _asDouble(walletMap['total_earned'] ?? walletMap['totalEarned']),
      availableBalance:
          _asDouble(walletMap['available_balance'] ?? walletMap['availableAmount']),
      pendingAmount: _asDouble(walletMap['pending_amount'] ?? walletMap['pendingAmount']),
      totalWithdrawn:
          _asDouble(walletMap['total_withdrawn'] ?? walletMap['withdrawnAmount']),
    );
  }

  Future<List<CommissionEntry>> getMyCommissions() async {
    final response = await _dio.get('/commissions/me');
    final data = response.data;
    if (data is! List) {
      return const <CommissionEntry>[];
    }

    return data.whereType<Map<String, dynamic>>().map((item) {
      return CommissionEntry(
        id: _asInt(item['id']),
        productName: _asString(item['productName'] ?? item['product_name'], fallback: 'Produit'),
        commissionAmount:
            _asDouble(item['commissionAmount'] ?? item['commission_amount']),
        status: _asString(item['status'], fallback: 'pending'),
        createdAt: _asString(item['createdAt'] ?? item['created_at']),
      );
    }).toList(growable: false);
  }

  Future<List<PromotionEntry>> getMyPromotions(String userId) async {
    final response = await _dio.get('/api/v1/promotions/user/$userId');
    final data = response.data;
    if (data is! List) {
      return const <PromotionEntry>[];
    }

    return data.whereType<Map<String, dynamic>>().map((item) {
      return PromotionEntry(
        id: _asString(item['id']),
        postId: _asString(item['post_id'] ?? item['postId']),
        viewsCount: _asInt(item['views_count'] ?? item['viewsCount']),
        clicksCount: _asInt(item['clicks_count'] ?? item['clicksCount']),
        salesCount: _asInt(item['sales_count'] ?? item['salesCount']),
        totalCommissionEarned: _asDouble(
          item['total_commission_earned'] ?? item['totalCommissionEarned'],
        ),
        createdAt: _asString(item['created_at'] ?? item['createdAt']),
      );
    }).toList(growable: false);
  }

  Future<List<AffiliateSaleEntry>> getMyAffiliateSales() async {
    final response = await _dio.get('/api/v1/affiliates/sales');
    final data = response.data;
    if (data is! List) {
      return const <AffiliateSaleEntry>[];
    }

    return data.whereType<Map<String, dynamic>>().map((item) {
      return AffiliateSaleEntry(
        id: _asString(item['id']),
        saleAmount: _asDouble(item['sale_amount'] ?? item['saleAmount']),
        commissionAmount: _asDouble(item['commission_amount'] ?? item['commissionAmount']),
        commissionStatus:
            _asString(item['commission_status'] ?? item['commissionStatus']),
        createdAt: _asString(item['created_at'] ?? item['createdAt']),
      );
    }).toList(growable: false);
  }

  Future<WalletOverview> getWalletOverview() async {
    final response = await _dio.get('/api/v1/wallet');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const WalletOverview(
        totalEarned: 0,
        pendingAmount: 0,
        availableAmount: 0,
        withdrawnAmount: 0,
        totalSalesCount: 0,
      );
    }

    return WalletOverview(
      totalEarned: _asDouble(data['total_earned'] ?? data['totalEarned']),
      pendingAmount: _asDouble(data['pending_amount'] ?? data['pendingAmount']),
      availableAmount: _asDouble(data['available_amount'] ?? data['availableAmount']),
      withdrawnAmount: _asDouble(data['withdrawn_amount'] ?? data['withdrawnAmount']),
      totalSalesCount: _asInt(data['total_sales_count'] ?? data['totalSalesCount']),
    );
  }

  Future<WithdrawalStatsEntry> getWithdrawalStats() async {
    final response = await _dio.get('/api/marketplace/withdrawal/stats');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const WithdrawalStatsEntry(
        availableBalance: 0,
        pendingBalance: 0,
        totalWithdrawn: 0,
        pendingRequestsCount: 0,
        approvedRequestsCount: 0,
        totalRequestsCount: 0,
      );
    }

    return WithdrawalStatsEntry(
      availableBalance: _asDouble(data['available_balance'] ?? data['availableBalance']),
      pendingBalance: _asDouble(data['pending_balance'] ?? data['pendingBalance']),
      totalWithdrawn: _asDouble(data['total_withdrawn'] ?? data['totalWithdrawn']),
      pendingRequestsCount:
          _asInt(data['pending_requests_count'] ?? data['pendingRequestsCount']),
      approvedRequestsCount:
          _asInt(data['approved_requests_count'] ?? data['approvedRequestsCount']),
      totalRequestsCount: _asInt(data['total_requests_count'] ?? data['totalRequestsCount']),
    );
  }

  Future<List<WithdrawalHistoryEntry>> getWithdrawalHistory() async {
    final response = await _dio.get('/api/marketplace/withdrawal/history');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const <WithdrawalHistoryEntry>[];
    }

    final requests = data['requests'];
    if (requests is! List) {
      return const <WithdrawalHistoryEntry>[];
    }

    return requests.whereType<Map<String, dynamic>>().map((item) {
      return WithdrawalHistoryEntry(
        id: _asInt(item['id']),
        amount: _asDouble(item['amount']),
        paymentMethod: _asString(item['payment_method'] ?? item['paymentMethod']),
        status: _asString(item['status']),
        createdAt: _asString(item['created_at'] ?? item['createdAt']),
      );
    }).toList(growable: false);
  }

  Future<void> createWithdrawalRequest({
    required double amount,
    required String paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    await _dio.post(
      '/api/marketplace/withdrawal/request',
      data: <String, dynamic>{
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_details': paymentDetails,
      },
    );
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double _asDouble(dynamic value, {double fallback = 0.0}) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().toLowerCase().trim();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
}
