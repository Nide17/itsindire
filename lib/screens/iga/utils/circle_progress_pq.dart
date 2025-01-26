import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircleProgressPq extends StatelessWidget {
  final double percent;
  const CircleProgressPq({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: _calculateRadius(context),
      lineWidth: _calculateLineWidth(context),
      animation: true,
      percent: percent,
      center: Text(
        '${(percent * 100).toStringAsFixed(0)}%',
        style: _getTextStyle(context),
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      progressColor: const Color(0xFF9D14DD),
      backgroundColor: const Color(0xFFBCCCBF),
    );
  }

  // Calculate the radius based on screen width
  double _calculateRadius(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05;
  }

  // Calculate the line width based on screen width
  double _calculateLineWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.008;
  }

  // Get the text style based on the percent value
  TextStyle _getTextStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: percent < 0.9
          ? MediaQuery.of(context).size.width * 0.03
          : MediaQuery.of(context).size.width * 0.025,
    );
  }
}
