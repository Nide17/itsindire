import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class CircleProgressPq extends StatelessWidget {
  final double percent;
  const CircleProgressPq({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width * 0.05,
      lineWidth: MediaQuery.of(context).size.width * 0.008,
      animation: true,
      percent: percent,
      center: Text(
        '${(percent * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: percent < 0.9
              ? MediaQuery.of(context).size.width * 0.03
              : MediaQuery.of(context).size.width * 0.025,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      progressColor: const Color(0xFF9D14DD),
      backgroundColor: const Color(0xFFBCCCBF),
    );
  }
}
