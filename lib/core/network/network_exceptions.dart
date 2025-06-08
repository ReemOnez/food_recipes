import 'package:dio/dio.dart';

sealed class NetworkException implements Exception {
  const NetworkException();

  /// Unified entry point:
  /// - If [e] is a DioException, map it accordingly.
  /// - Otherwise, return [UnexpectedError].
  factory NetworkException.from(Object e) {
    if (e is DioException) {
      return NetworkException._fromDio(e);
    }
    return const NetworkException.unexpectedError();
  }

  /// Maps Dio-specific errors to our variants.
  factory NetworkException._fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException.requestTimeout();
      case DioExceptionType.cancel:
        return const NetworkException.requestCancelled();
      case DioExceptionType.badCertificate:
        return const NetworkException.badCertificate();
      case DioExceptionType.connectionError:
        return const NetworkException.noInternet();
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code != null) {
          if (code >= 500) return const NetworkException.serverError();
          if (code == 404) return const NetworkException.notFound();
          if (code == 401 || code == 403) return const NetworkException.unauthorized();
          if (code == 400) return const NetworkException.badRequest();
          if (code == 422) return const NetworkException.validationError();
        }
        return const NetworkException.unexpectedError();
      case DioExceptionType.unknown:
        return const NetworkException.unexpectedError();
    }
  }

  ///* Variants *///
  const factory NetworkException.requestTimeout() = RequestTimeout;

  const factory NetworkException.requestCancelled() = RequestCancelled;

  const factory NetworkException.badCertificate() = BadCertificate;

  const factory NetworkException.noInternet() = NoInternet;

  const factory NetworkException.badRequest() = BadRequest;

  const factory NetworkException.unauthorized() = Unauthorized;

  const factory NetworkException.notFound() = NotFound;

  const factory NetworkException.validationError() = ValidationError;

  const factory NetworkException.serverError() = ServerError;

  const factory NetworkException.unexpectedError() = UnexpectedError;
}

final class RequestTimeout extends NetworkException {
  const RequestTimeout();
}

final class RequestCancelled extends NetworkException {
  const RequestCancelled();
}

final class BadCertificate extends NetworkException {
  const BadCertificate();
}

final class NoInternet extends NetworkException {
  const NoInternet();
}

final class BadRequest extends NetworkException {
  const BadRequest();
}

final class Unauthorized extends NetworkException {
  const Unauthorized();
}

final class NotFound extends NetworkException {
  const NotFound();
}

final class ValidationError extends NetworkException {
  const ValidationError();
}

final class ServerError extends NetworkException {
  const ServerError();
}

final class UnexpectedError extends NetworkException {
  const UnexpectedError();
}

extension NetworkExceptionMessage on NetworkException {
  String get message {
    return switch (this) {
      BadRequest() => 'Bad request',
      Unauthorized() => 'Unauthorized access',
      NotFound() => 'Resource not found',
      ServerError() => 'Internal server error',
      RequestTimeout() => 'Connection timed out',
      NoInternet() => 'No internet connection',
      RequestCancelled() => 'Request was cancelled',
      BadCertificate() => 'Invalid SSL certificate',
      ValidationError() => 'Data validation error',
      UnexpectedError() => 'Something went wrong',
    };
  }
}
