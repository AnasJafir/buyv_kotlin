import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/marketplace_remote_data_source.dart';

final marketplaceProductPreviewProvider =
    FutureProvider.family<MarketplaceProductPreview?, String>((ref, productUid) async {
  final dataSource = MarketplaceRemoteDataSource();
  return dataSource.getProductPreview(productUid);
});
