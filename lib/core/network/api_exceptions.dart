class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'Unable to connect to server. Please check your internet.'])
      : super(statusCode: 0);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Session expired. Please log in again.'])
      : super(statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'Requested resource not found.'])
      : super(statusCode: 404);
}

class ValidationException extends ApiException {
  ValidationException(super.message, {super.data})
      : super(statusCode: 422);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Internal server error. Please try again later.'])
      : super(statusCode: 500);
}
