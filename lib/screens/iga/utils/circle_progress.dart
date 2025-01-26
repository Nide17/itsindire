import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/course_progress.dart';

class CircleProgress extends StatelessWidget {
  const CircleProgress({super.key});

  double _calculatePercentage(CourseProgressModel? courseProgress) {
    if (courseProgress == null || courseProgress.totalIngingos == 0) {
      return 1.0;
    }
    final int curCourseIngingo = courseProgress.currentIngingo;
    return (courseProgress.totalIngingos >= curCourseIngingo)
        ? (curCourseIngingo / courseProgress.totalIngingos)
        : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProgressModel?>(
        builder: (context, courseProgress, _) {
      final double percent = _calculatePercentage(courseProgress);

      return CircularPercentIndicator(
        radius: MediaQuery.of(context).size.width * 0.05,
        lineWidth: MediaQuery.of(context).size.width * 0.008,
        animation: true,
        percent: percent,
        center: Text(
          '${(courseProgress?.unansweredPopQuestions != 0 && percent > 0.1 ? (percent - 0.1) * 100 : percent * 100).toStringAsFixed(0)}%',
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
    });
  }
}
