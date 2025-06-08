enum ApiResultType { success, failure }

class ApiResult<T> {
  final ApiResultType type;
  final T? data;
  final dynamic meta;
  final String? message;
  final bool? error;

  const ApiResult._({required this.type, this.data, this.meta, this.message, this.error});

  factory ApiResult.success(T data, {dynamic meta}) {
    return ApiResult._(type: ApiResultType.success, data: data, meta: meta, error: false);
  }

  factory ApiResult.failure(String message, {bool? error}) {
    return ApiResult._(type: ApiResultType.failure, message: message, error: error ?? true);
  }

  factory ApiResult.fromJson(Map<String, dynamic> json, T Function(dynamic json)? decoder) {
    return json['error'] == true
        ? ApiResult.failure(json['message'] ?? 'Unknown error')
        : ApiResult.success(decoder != null ? decoder(json['data']) : json['data'], meta: json['meta']);
  }

  bool get isSuccess => type == ApiResultType.success;

  bool get isFailure => type == ApiResultType.failure;

  String get errorMessage => message ?? 'Unknown error';

  @override
  String toString() {
    return 'ApiResult(type: $type, message: $message, error: $error, data: $data, meta: $meta)';
  }
}
