import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';

class CircleProgress extends StatelessWidget {
  const CircleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProgress = Provider.of<CourseProgressModel?>(context);

    // GET THE CURRENT INGINGO
    final int curCourseIngingo =
        courseProgress != null ? courseProgress.currentIngingo : 1;

    // GET THE PERCENTAGE
    final double percent = (courseProgress != null &&
            courseProgress.totalIngingos != 0 && courseProgress.totalIngingos >= curCourseIngingo)
        ? (curCourseIngingo / courseProgress.totalIngingos) // GET THE PROGRESS
        : 0.0; // GET THE PROGRESS

    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width * 0.05,
      lineWidth: MediaQuery.of(context).size.width * 0.01,
      animation: true,
      percent: percent,
      center: Text(
        '${(percent * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      progressColor: const Color(0xFF9D14DD),
      backgroundColor: const Color(0xFFBCCCBF),
    );
  }
}
