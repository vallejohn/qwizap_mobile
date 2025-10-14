import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String devBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String prodBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  static const String baseUrl = prodBaseUrl;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static final Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'x-goog-api-key': dotenv.env['GEMINI_API_KEY']?? '',
  };
}