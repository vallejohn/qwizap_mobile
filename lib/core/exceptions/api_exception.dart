class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data; // optional response body

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
  
  /// Factory for easily creating exceptions from HTTP/Dio responses
  factory ApiException.fromResponse({
    required int? statusCode,
    dynamic data,
  }) {
    String message;

    if(statusCode == null){
      message = 'No response from server. Please check your connection.';
    } else if (statusCode >= 500) {
      message = 'Server error occurred. Please try again later.';
    } else if (statusCode == 404) {
      message = 'Requested resource not found.';
    } else if (statusCode == 401 || statusCode == 403) {
      message = 'Unauthorized request.';
    } else if (statusCode >= 400) {
      message = 'Something went wrong. Please check your request.';
    } else {
      message = 'Unexpected error occurred.';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// For network-level (no response) errors
  factory ApiException.network([String? message]) => ApiException(
        message: message ?? 'No internet connection. Please try again.',
      );
}

