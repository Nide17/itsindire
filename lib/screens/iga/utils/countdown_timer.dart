import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerExpired;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onTimerExpired,
  });

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _animation = StepTween(begin: 0, end: widget.duration).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.onTimerExpired();
        }
      });

    _controller.reverse(from: widget.duration.toDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int seconds = _animation.value;
        int minutes = seconds ~/ 60;
        int remainingSeconds = seconds % 60;

        Color textColor = (_animation.value / widget.duration) < 0.5
            ? Colors.red
            : Colors.green;

        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.008),
          decoration: BoxDecoration(
            color: const Color(0xFFFFBD59),
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
            border: Border.all(
              color: const Color(0xFF5B8BDF),
              width: MediaQuery.of(context).size.width * 0.0024,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                offset: const Offset(0, 2),
                blurRadius: 1,
              ),
            ],
          ),
          child: Text(
            '$minutes:${remainingSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        );
      },
    );
  }
}
