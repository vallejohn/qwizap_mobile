

import '../models/level.dart';

class LevelManager {
  late final List<Level> _levels;
  List<Level> get levels => _levels;

  late final int _currentLevel;
  int get currentLevel => _currentLevel;

  void updateLevel(){
    _currentLevel += 1;
  }

  void initLevel() {
    _currentLevel = 10;

    _levels = [
      Level(
        no: 1,
        requiredXP: 0,
        perQuestionXP: [10, 0, 0],
        bonusXP: 0,
        duration: 60,
        noOfQuestions: 5,
      ),
      Level(
        no: 2,
        requiredXP: 50,
        perQuestionXP: [10, 20, 0],
        bonusXP: 5,
        duration: 55,
        noOfQuestions: 6,
      ),
      Level(
        no: 3,
        requiredXP: 150,
        perQuestionXP: [10, 20, 0],
        bonusXP: 5,
        duration: 50,
        noOfQuestions: 6,
      ),
      Level(
        no: 4,
        requiredXP: 300,
        perQuestionXP: [10, 20, 30],
        bonusXP: 5,
        duration: 45,
        noOfQuestions: 7,
      ),
      Level(
        no: 5,
        requiredXP: 500,
        perQuestionXP: [10, 20, 30],
        bonusXP: 10,
        duration: 45,
        noOfQuestions: 7,
      ),
      Level(
        no: 6,
        requiredXP: 750,
        perQuestionXP: [0, 20, 30],
        bonusXP: 10,
        duration: 40,
        noOfQuestions: 8,
      ),
      Level(
        no: 7,
        requiredXP: 1100,
        perQuestionXP: [0, 20, 30],
        bonusXP: 10,
        duration: 40,
        noOfQuestions: 8,
      ),
      Level(
        no: 8,
        requiredXP: 1500,
        perQuestionXP: [0, 20, 40],
        bonusXP: 10,
        duration: 35,
        noOfQuestions: 9,
      ),
      Level(
        no: 9,
        requiredXP: 2000,
        perQuestionXP: [0, 20, 40],
        bonusXP: 15,
        duration: 35,
        noOfQuestions: 9,
      ),
      Level(
        no: 10,
        requiredXP: 2600,
        perQuestionXP: [0, 20, 50],
        bonusXP: 15,
        duration: 30,
        noOfQuestions: 10,
      ),
    ];
  }
}
