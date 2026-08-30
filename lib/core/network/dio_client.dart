import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_providers.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // Do NOT hard-code baseUrl here — it is injected per-request
      // by the interceptor below so URL changes take effect immediately.
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Always use the current override URL — this picks up any runtime change
        // made via ApiEndpoints.setBaseUrl() without needing a provider invalidation.
        final currentBase = ApiEndpoints.baseUrl;
        if (!options.uri.isAbsolute) {
          // Path is relative — prefix with the current base URL
          options.baseUrl = currentBase;
        }

        final storage = ref.read(localStorageProvider);
        final token = await storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          debugPrint('🌐 [HTTP Request] ${options.method} ${options.baseUrl}${options.path}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('✅ [HTTP Response ${response.statusCode}] ${response.requestOptions.path}');
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        if (kDebugMode) {
          debugPrint('❌ [HTTP Error] ${error.requestOptions.path} => ${error.type} ${error.message} ${error.response?.data}');
        }

        if (error.response?.statusCode == 401) {
          final storage = ref.read(localStorageProvider);
          await storage.clearAuthSession();
        }

        ApiException mappedException;
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError) {
          mappedException = NetworkException(
            'Failed to connect to backend at ${ApiEndpoints.baseUrl}. Ensure FastAPI is running on port 8000.',
          );
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
