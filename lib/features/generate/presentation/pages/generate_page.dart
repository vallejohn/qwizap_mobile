import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../core/di/setup_locator.dart';
import '../../../../src/qwizap/presentation/blocs/timer/timer_bloc.dart';
import '../../core/params/generate_params.dart';
import '../bloc/generate_bloc.dart';

class GeneratePage extends StatefulWidget {
  final String category;
  const GeneratePage({super.key, this.category = ''});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final int _duration = 60;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GenerateBloc>()..add(GenerateEvent.fetch(GenerateFetchParams(noOfItems: 10, category: widget.category))),
      child: MultiBlocListener(
        listeners: [
          BlocListener<GenerateBloc, GenerateState>(
            listenWhen: (prev, cur) => prev.fetchStatus != cur.fetchStatus,
            listener: (context, state) {
              if (state.fetchStatus == GenerateFetchStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }

              if (state.fetchStatus == GenerateFetchStatus.success) {
                BlocProvider.of<TimerBloc>(context)
                    .add(TimerEvent.started(_duration));
              }
            },
          ),
          BlocListener<GenerateBloc, GenerateState>(
            listener: (context, state) {
              if (state.currentQuestion != null && state.currentQuestion!.selectedAnswer.isNotEmpty) {
                BlocProvider.of<TimerBloc>(context)
                    .add(const TimerEvent.paused());
              }
            },
          ),
          BlocListener<GenerateBloc, GenerateState>(
            listenWhen: (prev, cur) =>
            prev.currentQuestion?.question != cur.currentQuestion?.question,
            listener: (context, state) {
              BlocProvider.of<TimerBloc>(context)
                  .add(TimerEvent.started(_duration));
            },
          )
        ], 
        child: Scaffold(
          body: BlocBuilder<GenerateBloc, GenerateState>(
            builder: (context, state) {
              final quizBloc = context.read<GenerateBloc>();
              Widget body = Container();

              if (state.fetchStatus == GenerateFetchStatus.loading) {
                body = _loadingPage();
              }

              if (state.fetchStatus == GenerateFetchStatus.success) {
                body = _mainContent(quizBloc);
              }

              if (state.fetchStatus == GenerateFetchStatus.finished) {
                body = _finishedPage(quizBloc);
              }

              return Scaffold(
                body: SafeArea(child: body),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _loadingPage() {
    final textStyle = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white,),
          const SizedBox(height: 20),
          Text(
            'Generating questions...',
            style: textStyle.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      )
    );
  }

  Widget _finishedPage(GenerateBloc bloc) {
    final textStyle = Theme.of(context).textTheme;
    int total = bloc.state.data.fold(0, (total, q) => total + q.score);

    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        const SizedBox(height: 200,),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Score',
            style: textStyle.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            total.toString(),
            style: textStyle.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 50,),
        FilledButton(
          onPressed: () {
            context.go('/');
          },
          child: Align(
            alignment: Alignment.center,
            child: Text('BACK TO HOME',
              style: textStyle.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _mainContent(GenerateBloc bloc) {
    final textStyle = Theme.of(context).textTheme;
    final fbStyle = Theme.of(context).filledButtonTheme.style;
    final score = bloc.state.currentQuestion!.score;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                final duration = state.maybeWhen(
                  orElse: () => 60,
                  initial: (duration) => duration,
                  runInProgress: (duration) => duration,
                  runPause: (duration) => duration,
                  runComplete: () => 0,
                );

                final minutesStr =
                ((duration / 60).floor()).toString().padLeft(2, '0');
                final secondsStr = (duration % 60).toString().padLeft(2, '0');

                final totalDuration = _duration;
                final progress = (totalDuration - duration) / totalDuration;

                return Row(
                  children: [
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: progress),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            minHeight: 5,
                            value: value,
                            color: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Colors.white.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(16),
                          );
                        },
                        duration: const Duration(seconds: 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      (((duration / 60).floor()) ~/ 60) == 0
                          ? secondsStr
                          : '$minutesStr:$secondsStr',
                      style: textStyle.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(minHeight: 200),
                child: Center(
                    child: Text(
                      bloc.state.currentQuestion!.question,
                      textAlign: TextAlign.center,
                      style: textStyle.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ...bloc.state.currentQuestion!.choices.map((choice) {
              bool highlightCorrectAnswer = false;
              Color highlightColor = Colors.transparent;
              final currentQuestion = bloc.state.currentQuestion!;

              if (currentQuestion.selectedAnswer.isNotEmpty) {
                if (currentQuestion.answer == choice &&
                    currentQuestion.selectedAnswer != currentQuestion.answer) {
                  highlightCorrectAnswer = true;
                  highlightColor = Colors.white.withOpacity(0.5);
                }
              }

              Color color = Colors.white.withOpacity(0.09);
              if (currentQuestion.selectedAnswer == choice) {
                if (currentQuestion.selectedAnswer == currentQuestion.answer) {
                  color = const Color(0xff00954F);
                }
                if (currentQuestion.selectedAnswer != currentQuestion.answer) {
                  color = const Color(0xff950000);
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: FilledButton(
                  onPressed: () {
                    if (currentQuestion.selectedAnswer.isEmpty) {
                      final timer = BlocProvider.of<TimerBloc>(context).state;
                      final remainingTime = timer.maybeWhen(
                        runInProgress: (duration) => duration,
                        orElse: () => 0,
                      );

                      bloc.add(
                        GenerateEvent.onAnswerSelected(
                            answer: choice,
                            remainingTime: remainingTime,
                            duration: _duration),
                      );
                    }
                  },
                  style: fbStyle?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(color),
                    shape: WidgetStatePropertyAll(
                      SmoothRectangleBorder(
                          smoothness: 1,
                          borderRadius: BorderRadius.circular(13),
                          side: highlightCorrectAnswer
                              ? BorderSide(width: 2, color: highlightColor)
                              : BorderSide.none),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      choice,
                      style: textStyle.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          child: IntrinsicHeight(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TweenAnimationBuilder(
                        tween: IntTween(
                          begin: 0,
                          end: score,
                        ),
                        duration: Duration(milliseconds: score == 0 ? 0 : 500),
                        builder: (context, value, child) => Text(
                          value.toString(),
                          style: textStyle.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        bloc.add(const GenerateEvent.nextQuestion());
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          bloc.state.fetchStatus == GenerateFetchStatus.finished
                              ? 'VIEW SCORE'
                              : 'NEXT',
                          style: textStyle.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

