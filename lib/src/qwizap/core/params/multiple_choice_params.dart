import 'package:equatable/equatable.dart';

class MultipleChoiceParam extends Equatable {
  final int questionCount;
  final String topic;
  final int noOfChoices;
  final int level;

  const MultipleChoiceParam({
    this.questionCount = 5, // Default value of 5
    required this.topic,
    this.noOfChoices = 4,
    required this.level,
  });

  @override
  List<Object?> get props => [
        questionCount,
        topic,
        noOfChoices,
        level,
      ];
}
