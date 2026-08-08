import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  factory ApiException.from(Object error) {
    if (error is! DioException) {
      return const ApiException('Something went wrong. Please try again.');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException('The request timed out. Please try again.');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const ApiException('No internet connection.');
      case DioExceptionType.badCertificate:
        return const ApiException('Could not verify a secure connection.');
      case DioExceptionType.cancel:
        return const ApiException('The request was cancelled.');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status != null && status >= 500) {
          return const ApiException('The server is unavailable right now.');
        }
        return ApiException('Could not load causes (error $status).');
    }
  }

  final String message;

  @override
  String toString() => message;
}
