class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => code != null ? '[$code] $message' : message;
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}

class DatabaseException extends AppException {
  DatabaseException(String message) : super(message, code: 'DATABASE_ERROR');
}

class AuthenticationException extends AppException {
  AuthenticationException(String message) : super(message, code: 'AUTH_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, code: 'NOT_FOUND');
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class BusinessException extends AppException {
  BusinessException(String message) : super(message, code: 'BUSINESS_ERROR');
}
