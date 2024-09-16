import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/screens/iga/iga_content.dart';
import 'package:tegura/services/course_progress.dart';

class UserProgress extends StatelessWidget {
  // INSTANCE VARIABLES
  final IsomoModel isomo;
  final String userId;
  final int totalIngingos = 0;

  // CONSTRUCTOR
  const UserProgress({
    super.key,
    required this.isomo,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // PROVIDERS
    final courseProgress = Provider.of<CourseProgressModel?>(context);
    final totalIngingos = Provider.of<int?>(context) ?? 0;

    // GET THE CURRENT INGINGO
    final int curCourseIngingo =
        courseProgress != null ? courseProgress.currentIngingo : 1;

    // GET THE PERCENTAGE
    final double percent = (courseProgress != null && totalIngingos != 0)
        ? (curCourseIngingo / totalIngingos) // GET THE PROGRESS
        : 0.0; // GET THE PROGRESS

    return // PROGRESS BAR WITH CTA BUTTON
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PROGRESS BAR
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 0.4,
          animation: true,
          lineHeight: MediaQuery.of(context).size.height * 0.032,
          animationDuration: 2500,
          percent: percent,
          center: Text(
            '${(percent * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: Colors.white,
            ),
          ),
          barRadius: const Radius.circular(16.0),
          backgroundColor: const Color(0xFF494F56),
          progressColor:
              percent > 0.5 ? const Color(0xFF00A651) : const Color(0xFFFF3131),
        ),

        // CTA BUTTON
        if (percent != 1.0)
          GestureDetector(
            // NAVIGATE TO IGA
            onTap: () {
              // GET THE PROGRESS
              final courseProgress =
                  Provider.of<CourseProgressModel?>(context, listen: false);

              // IF THE USER HAS NOT STARTED THE COURSE, CREATE A NEW PROGRESS
              if (courseProgress == null) {
                // CREATE A NEW PROGRESS BY UPDATING THE COURSE PROGRESS
                CourseProgressService().updateUserCourseProgress(
                  userId,
                  isomo.id,
                  totalIngingos,
                  curCourseIngingo,
                );
              }

              // IF THE USER HAS NOT STARTED THE COURSE, THEN START THE STATE AT 0 (FIRST INGINGO) ELSE START AT THE CURRENT INGINGO (INGINGO THAT THE USER IS ON)
              // final int curCourseIngingo = courseProgress != null ? courseProgress.ingingo : 0;

              // NAVIGATE TO IGA CONTENT
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IgaContent(
                          isomo: isomo)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.033,
              decoration: BoxDecoration(
                color: const Color(0XFF00CCE5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  (percent == 0.0) ? "TANGIRA" : "KOMEZA",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
