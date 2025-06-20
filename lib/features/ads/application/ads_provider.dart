import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/core/network/network_exceptions.dart';
import 'package:recipes/features/ads/data/ads_model.dart';
import 'package:recipes/features/ads/data/ads_repository.dart';

final adsListProvider = FutureProvider.family<List<AdModel>, String>((ref, String searchTerm) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  if (cancelToken.isCancelled) throw NetworkException.unexpectedError();
  return await ref.watch(adsRepositoryProvider).fetchAds(query: searchTerm, cancelToken: cancelToken);
});
