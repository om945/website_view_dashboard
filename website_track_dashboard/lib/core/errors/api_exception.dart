class ApiException implements Exception {
  ApiException(this.statusCode, this.message, {this.code, this.requestId});

  final int statusCode;
  final String message;
  final String? code;
  final String? requestId;

  bool get isUnauthorized => statusCode == 401;
  bool get isNetwork => statusCode == 0;
  bool get isRateLimited => statusCode == 429;
  bool get isServer => statusCode >= 500;

  @override
  String toString() => message;
}

String friendlyError(Object error) {
  if (error is ApiException) return error.message;
  return 'Unable to reach the API.';
}
