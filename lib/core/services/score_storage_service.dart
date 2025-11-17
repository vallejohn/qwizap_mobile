import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorageService {
  static const String _scorePrefix = 'category_score_';
  // Maximum reasonable score: 10 questions * 200 points each = 2000
  static const int _maxReasonableScore = 10000;

  /// Normalizes category name for consistent storage
  String _normalizeCategoryName(String categoryName) {
    return categoryName.trim().toLowerCase();
  }

  /// Validates score is within acceptable range
  bool _isValidScore(int score) {
    return score >= 0 && score <= _maxReasonableScore;
  }

  /// Save score for a category
  /// If a higher score already exists, it will be kept (best score wins)
  /// Throws exception if score is invalid or storage fails
  Future<void> saveScore(String categoryName, int score) async {
    // Validate input
    if (!_isValidScore(score)) {
      throw ArgumentError(
        'Score must be between 0 and $_maxReasonableScore, got: $score',
      );
    }

    final normalizedCategory = _normalizeCategoryName(categoryName);
    if (normalizedCategory.isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_scorePrefix$normalizedCategory';
      
      // Get existing score if any
      final existingScore = prefs.getInt(key) ?? 0;
      
      // Only save if new score is higher (best score wins)
      if (score > existingScore) {
        final success = await prefs.setInt(key, score);
        if (!success) {
          throw Exception('Failed to save score for category: $categoryName');
        }
      }
    } catch (e) {
      throw Exception('Error saving score: $e');
    }
  }

  /// Get score for a category
  /// Returns 0 if no score exists
  /// Throws exception if storage access fails
  Future<int> getScore(String categoryName) async {
    final normalizedCategory = _normalizeCategoryName(categoryName);
    if (normalizedCategory.isEmpty) {
      return 0;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_scorePrefix$normalizedCategory';
      return prefs.getInt(key) ?? 0;
    } catch (e) {
      throw Exception('Error getting score for category $categoryName: $e');
    }
  }

  /// Get all scores as a map of category name to score
  /// Returns empty map if no scores exist or on error
  Future<Map<String, int>> getAllScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final scores = <String, int>{};
      
      for (final key in keys) {
        if (key.startsWith(_scorePrefix)) {
          final categoryName = key.substring(_scorePrefix.length);
          final score = prefs.getInt(key) ?? 0;
          // Only include valid scores
          if (_isValidScore(score)) {
            scores[categoryName] = score;
          }
        }
      }
      
      return scores;
    } catch (e) {
      // Return empty map on error rather than throwing
      return <String, int>{};
    }
  }

  /// Clear score for a specific category
  /// Throws exception if storage access fails
  Future<void> clearScore(String categoryName) async {
    final normalizedCategory = _normalizeCategoryName(categoryName);
    if (normalizedCategory.isEmpty) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_scorePrefix$normalizedCategory';
      await prefs.remove(key);
    } catch (e) {
      throw Exception('Error clearing score for category $categoryName: $e');
    }
  }

  /// Clear all scores
  /// Throws exception if storage access fails
  Future<void> clearAllScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_scorePrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      throw Exception('Error clearing all scores: $e');
    }
  }
}

