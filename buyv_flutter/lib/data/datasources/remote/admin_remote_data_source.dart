import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/services/token_manager.dart';

class AdminRemoteDataSource {
  AdminRemoteDataSource({Dio? authDio, Dio? publicDio})
      : _authDio = authDio ?? ApiClient.authenticated,
        _publicDio = publicDio ?? ApiClient.public;

  final Dio _authDio;
  final Dio _publicDio;

  Future<void> adminLogin({required String email, required String password}) async {
    final response = await _publicDio.post(
      '/auth/admin/login',
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid admin login response.');
    }

    final token = _asString(data['access_token']);
    if (token.isEmpty) {
      throw const FormatException('Missing access token.');
    }

    await TokenManager.saveAccessToken(token);

    final adminRaw = data['admin'];
    if (adminRaw is Map<String, dynamic>) {
      final adminId = _asString(adminRaw['id']);
      if (adminId.isNotEmpty) {
        await TokenManager.saveUserId(adminId);
      }
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _authDio.get('/api/admin/dashboard/stats');
    return _asMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getRecentUsers({int limit = 10}) async {
    final response = await _authDio.get(
      '/api/admin/dashboard/recent-users',
      queryParameters: <String, dynamic>{'limit': limit},
    );
    return _asListOfMaps(response.data);
  }

  Future<List<Map<String, dynamic>>> getRecentOrders({int limit = 10}) async {
    final response = await _authDio.get(
      '/api/admin/dashboard/recent-orders',
      queryParameters: <String, dynamic>{'limit': limit},
    );
    return _asListOfMaps(response.data);
  }

  Future<List<Map<String, dynamic>>> getUsers({String? search}) async {
    final response = await _authDio.get(
      '/api/admin/users',
      queryParameters: <String, dynamic>{
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'limit': 100,
      },
    );
    return _asListOfMaps(response.data);
  }

  Future<void> verifyUsers(List<String> userIds) async {
    await _authDio.post('/api/admin/users/verify', data: <String, dynamic>{'user_ids': userIds});
  }

  Future<void> unverifyUsers(List<String> userIds) async {
    await _authDio.post('/api/admin/users/unverify', data: <String, dynamic>{'user_ids': userIds});
  }

  Future<void> deleteUser(String userUid) async {
    await _authDio.delete('/api/admin/users/$userUid');
  }

  Future<List<Map<String, dynamic>>> getAdminOrders({String? status}) async {
    if (status != null && status.trim().isNotEmpty) {
      final response = await _authDio.get(
        '/api/orders/admin/status',
        queryParameters: <String, dynamic>{'status': status.trim(), 'limit': 100},
      );
      return _asListOfMaps(response.data);
    }

    final response = await _authDio.get(
      '/api/orders/admin/all',
      queryParameters: <String, dynamic>{'limit': 100},
    );
    return _asListOfMaps(response.data);
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await _authDio.patch(
      '/api/orders/$orderId/status',
      data: <String, dynamic>{'status': status},
    );
  }

  Future<List<Map<String, dynamic>>> getAdminCommissions({String? status}) async {
    if (status != null && status.trim().isNotEmpty) {
      final response = await _authDio.get(
        '/api/commissions/admin/status',
        queryParameters: <String, dynamic>{'status': status.trim(), 'limit': 100},
      );
      return _asListOfMaps(response.data);
    }

    final response = await _authDio.get(
      '/api/commissions/admin/all',
      queryParameters: <String, dynamic>{'limit': 100},
    );
    return _asListOfMaps(response.data);
  }

  Future<void> updateCommissionStatus(int commissionId, String status) async {
    await _authDio.patch(
      '/api/commissions/$commissionId/status',
      data: <String, dynamic>{'status': status},
    );
  }

  Future<List<Map<String, dynamic>>> getAdminPosts({String? search, String? postType}) async {
    final response = await _authDio.get(
      '/api/admin/posts',
      queryParameters: <String, dynamic>{
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (postType != null && postType.trim().isNotEmpty) 'post_type': postType.trim(),
        'limit': 100,
      },
    );
    return _asListOfMaps(response.data);
  }

  Future<void> deleteAdminPost(String postUid) async {
    await _authDio.delete('/api/admin/posts/$postUid');
  }

  Future<List<Map<String, dynamic>>> getAdminComments({String? search}) async {
    final response = await _authDio.get(
      '/api/admin/comments',
      queryParameters: <String, dynamic>{
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'limit': 100,
      },
    );
    return _asListOfMaps(response.data);
  }

  Future<void> deleteAdminComment(int commentId) async {
    await _authDio.delete('/api/admin/comments/$commentId');
  }

  Future<Map<String, dynamic>> getFollowStats() async {
    final response = await _authDio.get('/api/admin/follows/stats');
    return _asMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getAdminNotifications() async {
    final response = await _authDio.get(
      '/api/admin/notifications',
      queryParameters: <String, dynamic>{'limit': 100},
    );
    return _asListOfMaps(response.data);
  }

  Future<void> sendAdminNotification({
    required String title,
    required String body,
    String type = 'admin_broadcast',
  }) async {
    await _authDio.post(
      '/api/admin/notifications/send',
      data: <String, dynamic>{
        'title': title,
        'body': body,
        'type': type,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getMarketplaceProducts({String? search}) async {
    final response = await _authDio.get(
      '/api/v1/marketplace/products',
      queryParameters: <String, dynamic>{
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'limit': 100,
      },
    );
    final map = _asMap(response.data);
    return _asListOfMaps(map['items']);
  }

  Future<List<Map<String, dynamic>>> getMarketplaceCategories() async {
    final response = await _authDio.get('/api/v1/marketplace/categories');
    return _asListOfMaps(response.data);
  }

  Future<List<Map<String, dynamic>>> searchCjProducts(String query) async {
    final response = await _authDio.get(
      '/api/v1/admin/cj/search',
      queryParameters: <String, dynamic>{'query': query, 'page_size': 20, 'page': 1},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['items'] is List) {
        return _asListOfMaps(data['items']);
      }
      if (data['data'] is List) {
        return _asListOfMaps(data['data']);
      }
      return <Map<String, dynamic>>[data];
    }
    return _asListOfMaps(data);
  }

  Future<void> importCjProduct({
    required String cjProductId,
    double? commissionRate,
    String? categoryId,
    String? customDescription,
    double? sellingPrice,
  }) async {
    await _authDio.post(
      '/api/v1/admin/cj/import',
      data: <String, dynamic>{
        'cj_product_id': cjProductId,
        if (commissionRate != null) 'commission_rate': commissionRate,
        if (categoryId != null && categoryId.trim().isNotEmpty) 'category_id': categoryId.trim(),
        if (customDescription != null && customDescription.trim().isNotEmpty)
          'custom_description': customDescription.trim(),
        if (sellingPrice != null) 'selling_price': sellingPrice,
      },
    );
  }

  Future<void> deleteMarketplaceProduct(String productId) async {
    await _authDio.delete('/api/v1/admin/marketplace/products/$productId');
  }

  Future<void> deleteMarketplaceCategory(String categoryId) async {
    await _authDio.delete('/api/v1/admin/marketplace/categories/$categoryId');
  }

  Future<List<Map<String, dynamic>>> getAdminAffiliateSales() async {
    final response = await _authDio.get(
      '/api/v1/admin/sales',
      queryParameters: <String, dynamic>{'limit': 100},
    );
    return _asListOfMaps(response.data);
  }

  Future<void> updateAffiliateSaleStatus({
    required String saleId,
    required String status,
  }) async {
    await _authDio.patch(
      '/api/v1/admin/sales/$saleId/status',
      data: <String, dynamic>{'status': status},
    );
  }

  Future<List<Map<String, dynamic>>> getAdminWithdrawals() async {
    final response = await _authDio.get('/api/marketplace/withdrawal/admin/list');
    final data = _asMap(response.data);
    return _asListOfMaps(data['requests']);
  }

  Future<void> approveWithdrawal(int withdrawalId, {String? adminNotes}) async {
    await _authDio.post(
      '/api/marketplace/withdrawal/admin/$withdrawalId/approve',
      data: <String, dynamic>{if (adminNotes != null) 'admin_notes': adminNotes},
    );
  }

  Future<void> rejectWithdrawal(int withdrawalId, {required String reason}) async {
    await _authDio.post(
      '/api/marketplace/withdrawal/admin/$withdrawalId/reject',
      data: <String, dynamic>{'admin_notes': reason},
    );
  }

  Future<void> completeWithdrawal(int withdrawalId, {required String transactionId}) async {
    await _authDio.post(
      '/api/marketplace/withdrawal/admin/$withdrawalId/complete',
      data: <String, dynamic>{'transaction_id': transactionId},
    );
  }

  static String _asString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _asListOfMaps(dynamic value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
}
