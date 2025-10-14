class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // Categories endpoints
  static const String fetchCategories = '/categories';
  static const String createCategories = '/categories-create';
  static const String updateCategories = '/categories-update';
  static const String deleteCategories = '/categories-delete';

  // Generate endpoints
  static const String fetchGenerate = '/gemini-2.5-flash:generateContent';
  static const String createGenerate = '/generate-create';
  static const String updateGenerate = '/generate-update';
  static const String deleteGenerate = '/generate-delete';
}
