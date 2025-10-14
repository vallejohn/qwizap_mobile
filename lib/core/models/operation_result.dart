import 'package:equatable/equatable.dart';

class OperationResult<T> extends Equatable {
  final String? message;
  final T? data;

  const OperationResult({
    this.message,
    this.data,
  });

  /// Named constructor for clarity
  const OperationResult.success({
    this.data,
    this.message,
  });

  @override
  List<Object?> get props => [message, data];

  @override
  String toString() =>
      'OperationResult(message: $message, data: $data)';
}

