import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/screens/iga/utils/iga_content.dart';
import 'package:tegura/services/isomo_progress.dart';

class UserProgress extends StatelessWidget {
  // INSTANCE VARIABLES
  final IsomoModel isomo;
  final String userId;
  final int totalIngingos;

  // CONSTRUCTOR
  const UserProgress({
    super.key,
    required this.isomo,
    required this.userId,
    required this.totalIngingos,
  });

  @override
  Widget build(BuildContext context) {
    // PROVIDERS VARIABLES
    final progresses = Provider.of<List<CourseProgressModel?>?>(context);

    // GET THE PROGRESS
    final courseProgress =
        progresses?.firstWhere((progress) => progress!.courseId == isomo.id,
            orElse: () => CourseProgressModel(
                  courseId: isomo.id,
                  currentIngingo: 0,
                  totalIngingos: 1,
                  id: '',
                  userId: '',
                ));

    // GET THE CURRENT INGINGO IF THE USER HAS STARTED THE COURSE OR 1
    final int curCourseIngingo =
        courseProgress != null ? courseProgress.currentIngingo : 1;

    // GET THE PERCENTAGE
    final double percent = (courseProgress != null &&
            courseProgress.totalIngingos != 0 && courseProgress.totalIngingos >= curCourseIngingo)
        ? (curCourseIngingo / courseProgress.totalIngingos) // GET THE PROGRESS
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
        GestureDetector(
          // NAVIGATE TO IGA
          onTap: () {
            // IF THE USER HAS NOT STARTED THE COURSE, CREATE A NEW PROGRESS
            if (courseProgress?.totalIngingos != totalIngingos) {
              // CREATE OR UPDATE USER PROGRESS
              CourseProgressService().updateUserCourseProgress(
                userId,
                isomo.id,
                totalIngingos,
                curCourseIngingo,
              );
            }

            print('USER ID: $userId');
            print('ISOMO ID: ${isomo.id}');
            print('TOTAL INGINGOS: $totalIngingos');
            print('CURRENT INGINGO: $curCourseIngingo');

            // NAVIGATE TO IGA CONTENT
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IgaContent(isomo: isomo)));
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
                (percent == 0.0)
                    ? "TANGIRA"
                    : percent == 1.0
                        ? "ISUZUME"
                        : "KOMEZA",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: percent == 1.0 ? Colors.white : Colors.black,
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
