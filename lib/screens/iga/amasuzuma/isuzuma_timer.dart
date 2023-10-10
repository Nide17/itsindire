import 'package:flutter/material.dart';

class IsuzumaTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerExpired;

  const IsuzumaTimer({
    Key? key,
    required this.duration,
    required this.onTimerExpired,
  }) : super(key: key);

  @override
  IsuzumaTimerState createState() => IsuzumaTimerState();
}

class IsuzumaTimerState extends State<IsuzumaTimer>
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.016),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 237, 134),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.green,
              width: 1.5,
            ),
          ),
          child: Text(
            '$minutes:${remainingSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        );
      },
    );
  }
}
