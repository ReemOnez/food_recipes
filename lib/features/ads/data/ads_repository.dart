import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/core/network/api_client.dart';
import 'package:recipes/core/network/api_result.dart';
import 'package:recipes/core/network/network_exceptions.dart';
import 'package:recipes/core/network/urls.dart';
import 'package:recipes/features/ads/data/ads_model.dart';

class AdsRepository {
  final ApiClient apiClient;

  AdsRepository({required this.apiClient});

  Future<List<AdModel>> fetchAds({required String? query, required CancelToken cancelToken}) async {
    try {
      final ApiResult<List<AdModel>> result = await apiClient.get<List<AdModel>>(
        '${Urls.getAdsUrl}/$query',
        decoder: (json) => List<AdModel>.from(json.map((x) => AdModel.fromJson(x))),
        cancelToken: cancelToken,
      );
      if (result.isSuccess && result.data != null) {
        return result.data!;
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      final err = NetworkException.from(e);
      throw Exception(err.message);
    }
  }
}

final adsRepositoryProvider = Provider<AdsRepository>((ref) {
  return AdsRepository(apiClient: ref.watch(apiClientProvider));
});
