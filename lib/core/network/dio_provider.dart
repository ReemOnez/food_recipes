import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        /// Read token from sharedPreference:
        /// if (ref.watch(sharedPreferencesProvider).getToken != null)
        /// { options.headers['Authorization'] = 'Bearer ${ref.watch(sharedPreferencesProvider).getToken}';}
        final token = 'your_access_token';
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle responses globally if needed
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        final response = error.response;

        if (response?.statusCode == 401) {
          /// refresh sharedPreference in case of unauthorisedRequest:
          //  ref.read(sharedPreferencesProvider).clearToken();
          //  ref.read(sharedPreferencesProvider).clearUserID();
          //  ref.read(sharedPreferencesProvider).clearUserType();
          //  ref.invalidate(dioProvider);

          /// Attempt refresh logic manually (mocked)
          try {
            final refreshToken = 'your_refresh_token';
            final refreshResponse = await dio.post('/auth/refresh', data: {'refresh_token': refreshToken});

            final newAccessToken = refreshResponse.data['access_token'];
            error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final cloneReq = await dio.fetch(error.requestOptions);
            return handler.resolve(cloneReq);
          } catch (e) {
            return handler.reject(error);
          }
        } else {
          return handler.next(error);
        }
      },
    ),

    LogInterceptor(request: true, requestHeader: true, requestBody: true, responseHeader: true, responseBody: true, error: true),
  ]);

  ref.onDispose(dio.close);
  return dio;
});
