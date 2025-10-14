class GeneratedContentException implements Exception {
  final String message;

  GeneratedContentException(this.message);

  @override
  String toString() => 'GeneratedContentException: $message';
}

GeneratedContentException emptyTextResponse() =>
    GeneratedContentException('There was an error creating the topic');

GeneratedContentException invalidGeneratedFormat() =>
    GeneratedContentException('invalid response format');
