import 'package:flutter/material.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_model.dart';

class QuestionProper extends StatefulWidget {
  final List<Question> questions;
  const QuestionProper({super.key, required this.questions});

  @override
  State<QuestionProper> createState() => _QuestionProperState();
}

class _QuestionProperState extends State<QuestionProper> with TickerProviderStateMixin{
  late AnimationController _controller;

  late Question _currentQuestion;
  List<Question> _questions = [];
  final int _duration = 20;

  int totalScore = 0;
  int totalItems = 0;
  int currentItem = 1;

  @override
  void initState() {
    super.initState();
    _questions = widget.questions;
    totalItems = _questions.length;
    _currentQuestion = _questions.first;
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startCountdown(){
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _duration),
    );

    _controller.forward();
  }

  Stream<int> countdownStream({required int seconds}) async* {
    for (int i = seconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _checkScore()async {
    int correctScore = 100;
    bool correct = _currentQuestion.selectedAnswer == _currentQuestion.answer;

    double progress = _controller.value;
    int remainingTime = ((1 - progress) * _duration).round();

    double itemCompletionRate = (remainingTime / _duration) * 100;
    double timeScore = ((itemCompletionRate/100) * correctScore);

    int totalItemScore = !correct? 0 : int.parse((correctScore + timeScore).toStringAsFixed(0));

    _currentQuestion = _currentQuestion.copyWith(score: totalItemScore);
    totalScore = totalScore + totalItemScore;
    _controller.stop();
    _controller.dispose();
  }

  void _nextItem(){
    _startCountdown();
    final index = _questions.indexWhere((e) => e.question == _currentQuestion.question);

    if(index >= 0 && (index + 1) < totalItems){
      final nextIndex = index + 1;
      setState(() {
        currentItem = currentItem + 1;
        _currentQuestion = _questions[nextIndex];
      });
    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Questions ended'),));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question $currentItem/$totalItems'),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(totalScore.toString(), style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.w700),),
        )],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(height: 20,),
          StreamBuilder<int>(
            builder: (context, snapshot) {
              double progress = _controller.value;
              int remainingTime = ((1 - progress) * _duration).round();
              String minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
              String seconds = (remainingTime % 60).toString().padLeft(2, '0');

              return Column(
                children: [
                  AnimatedBuilder(
                    builder: (context, child) {
                      return LinearProgressIndicator(value: _controller.value,);
                    }, animation: _controller,
                  ),
                  Text('$minutes:$seconds'),
                ],
              );
            }, stream: countdownStream(seconds: _duration),
          ),
          const SizedBox(height: 20,),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(minHeight: 150),
                child: Center(child: Text(
                  _currentQuestion.question,
                  textAlign: TextAlign.center,
                  style: textStyle.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
                )),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(
                _currentQuestion.score.toString(),
                textAlign: TextAlign.center,
                style: textStyle.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
              )),
            ),
          ),
          const SizedBox(height: 20,),
          ..._currentQuestion.choices.map((choice){
            return Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      side: _currentQuestion.selectedAnswer != choice? null : BorderSide(width: 2, color: _currentQuestion.selectedAnswer != _currentQuestion.answer? Theme.of(context).colorScheme.error : Colors.green),
                    ),
                    onPressed: _currentQuestion.selectedAnswer.isNotEmpty? null : (){
                      _currentQuestion = _currentQuestion.copyWith(selectedAnswer: choice);
                      final index = _questions.indexWhere((e) => e.question == _currentQuestion.question);
                      setState(() => _questions[index] = _currentQuestion);
                      _checkScore();
                    }, child: Align(alignment: Alignment.centerLeft, child: Text(choice, style: textStyle.titleMedium?.copyWith(fontWeight: FontWeight.w600),)),
                  ),
                ),
                const SizedBox(width: 10,),
                if(_currentQuestion.selectedAnswer == choice) Icon(
                  _currentQuestion.selectedAnswer != _currentQuestion.answer? Icons.close :Icons.check,
                  color: _currentQuestion.selectedAnswer != _currentQuestion.answer? Theme.of(context).colorScheme.error : Colors.green,
                ),
              ],
            );
          })
        ],
      ),
      floatingActionButton: _currentQuestion.selectedAnswer.isNotEmpty && currentItem != totalItems? FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: (){
          _nextItem();
        },
      ) : null,
    );
  }
}
