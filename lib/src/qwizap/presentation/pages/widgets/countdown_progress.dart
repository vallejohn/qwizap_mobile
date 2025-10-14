import 'package:flutter/material.dart';

class CountdownProgress extends StatefulWidget {
  final AnimationController controller;
  final int duration;
  const CountdownProgress(
      {super.key, required this.controller, required this.duration});

  @override
  State<CountdownProgress> createState() => _CountdownProgressState();
}

class _CountdownProgressState extends State<CountdownProgress>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = widget.controller;
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return StreamBuilder<int>(
      builder: (context, snapshot) {
        double progress = _controller.value;
        int remainingTime = ((1 - progress) * widget.duration).round();
        String minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
        String seconds = (remainingTime % 60).toString().padLeft(2, '0');

        return Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                builder: (context, child) {
                  return LinearProgressIndicator(
                    minHeight: 5,
                    value: _controller.value,
                    color: const Color(0xFFDE00FF),
                    backgroundColor: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(16),
                  );
                },
                animation: _controller,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              (remainingTime ~/ 60) == 0? seconds : '$minutes:$seconds',
              style: textStyle.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        );
      },
      stream: _countdownStream(seconds: widget.duration),
    );
  }

  Stream<int> _countdownStream({required int seconds}) async* {
    for (int i = seconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _startCountdown() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.forward();
  }
}
