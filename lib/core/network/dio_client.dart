import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_providers.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = ref.read(localStorageProvider);
        final token = await storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired
          final storage = ref.read(localStorageProvider);
          await storage.clearAuthSession();
        }

        // Map Dio error to custom ApiException
        ApiException mappedException;
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError) {
          mappedException = NetworkException();
        } else if (error.response?.statusCode == 401) {
          mappedException = UnauthorizedException();
        } else if (error.response?.statusCode == 404) {
          mappedException = NotFoundException(
            error.response?.data?['detail']?.toString() ?? 'Resource not found',
          );
        } else if (error.response?.statusCode == 422) {
          mappedException = ValidationException(
            error.response?.data?['detail']?.toString() ?? 'Invalid data submitted',
            data: error.response?.data,
          );
        } else {
          mappedException = ServerException(
            error.response?.data?['detail']?.toString() ?? 'Server error occurred',
          );
        }

        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: mappedException,
          ),
        );
      },
    ),
  );

  return dio;
});
