import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:recipes/core/network/dio_provider.dart';
import 'network_exceptions.dart';
import 'api_result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<ApiResult<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, T Function(dynamic json)? decoder, Options? options}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);

      return ApiResult.fromJson(response.data, decoder);
    } catch (e) {
      final error = NetworkException.from(e);
      return ApiResult.failure(error.message);
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters, options: options);

      return ApiResult.fromJson(response.data, decoder);
    } catch (e) {
      final error = NetworkException.from(e);
      return ApiResult.failure(error.message);
    }
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters, options: options);

      return ApiResult.fromJson(response.data, decoder);
    } catch (e) {
      final error = NetworkException.from(e);
      return ApiResult.failure(error.message);
    }
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);

      return ApiResult.fromJson(response.data, decoder);
    } catch (e) {
      final error = NetworkException.from(e);
      return ApiResult.failure(error.message);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
