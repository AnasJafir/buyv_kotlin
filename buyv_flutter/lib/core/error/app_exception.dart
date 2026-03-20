/// App-level exception types — replaces KMP's Result.Error wrapping.
/// Maps HTTP status codes to user-friendly error categories.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final AppErrorType type;

  const AppException({
    required this.message,
    this.statusCode,
    this.type = AppErrorType.unknown,
  });

  factory AppException.fromStatusCode(int? code, String message) {
    return switch (code) {
      400 => AppException(message: message, statusCode: code, type: AppErrorType.badRequest),
      401 => AppException(message: 'Session expired. Please log in again.', statusCode: code, type: AppErrorType.unauthorized),
      403 => AppException(message: 'You don\'t have permission.', statusCode: code, type: AppErrorType.forbidden),
      404 => AppException(message: 'Not found.', statusCode: code, type: AppErrorType.notFound),
      422 => AppException(message: message, statusCode: code, type: AppErrorType.validation),
      429 => AppException(message: 'Too many requests. Please wait.', statusCode: code, type: AppErrorType.rateLimit),
      500 || 502 || 503 => AppException(message: 'Server error. Please try again.', statusCode: code, type: AppErrorType.server),
      _ when code == null => AppException(message: 'No internet connection.', type: AppErrorType.network),
      _ => AppException(message: message, statusCode: code),
    };
  }

  factory AppException.network(String message) =>
      AppException(message: message, type: AppErrorType.network);

  factory AppException.unknown(String message) =>
      AppException(message: message, type: AppErrorType.unknown);

  bool get isUnauthorized => type == AppErrorType.unauthorized;
  bool get isNetwork => type == AppErrorType.network;

  @override
  String toString() => 'AppException(${type.name}): $message';
}

enum AppErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimit,
  server,
  network,
  unknown,
}
