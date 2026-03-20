import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/marketplace_remote_data_source.dart';

final marketplaceRatingSummaryProvider =
    FutureProvider.family<MarketplaceRatingSummary?, String>((ref, productUid) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getProductRatingSummary(productUid);
});
