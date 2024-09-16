import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/services/isomo_progress.dart';

class DirectionButton extends StatelessWidget {
  // INSTANCE VARIABLES
  final String buttonText;
  final String direction;
  final double opacity;
  final int skip;
  final ValueChanged<int> changeSkip;
  final IsomoModel isomo;

  const DirectionButton({
    Key? key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    required this.skip,
    required this.changeSkip,
    required this.isomo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GET THE INGINGOS
    final ingingos = Provider.of<List<IngingoModel>?>(context) ?? [];

    // GET THE INGINGOS LENGTH
    final pageIngingos = ingingos.length;

    // GET THE COURSE PROGRESS
    final courseProgress = Provider.of<CourseProgressModel?>(context);

    // GET THE TOTAL NUMBER OF INGINGOS IN THE COURSE
    final totalIngs = courseProgress != null ? courseProgress.totalIngingos : 0;

    // GET THE CURRENT PROGRESS
    final currProgress =
        courseProgress != null ? courseProgress.currentIngingo : 0;

    // RETURN THE WIDGETS
    return ElevatedButton(
      onPressed: () {
        if (direction == 'inyuma') {
          // DECREASE SKIP STATE
          changeSkip(-5);
        } else if (direction == 'komeza') {
          // INCREASE SKIP STATE
          changeSkip(5);

          // UPDATE THE CURRENT INGINGO
          if (skip >= 0 && skip < totalIngs) {
            // UPDATE THE CURRENT INGINGO
            CourseProgressService().updateUserCourseProgress(
              courseProgress!.userId,
              isomo.id,
              courseProgress.totalIngingos,
              skip + pageIngingos,
            );

            print('courseProgress: $courseProgress');
            print('pageIngingos: $pageIngingos');
            print('totalIngs: $totalIngs');
            print('skip: $skip');
            print(
                'last ingingos: ${ingingos.isNotEmpty ? ingingos.last.id : "No ingingos"}');
            print('current progress: $currProgress');
            print('Next progress: ${skip + pageIngingos}');
          }
          // REMOVE THE CURRENT PAGE FROM THE STACK IF NO MORE NEXT PAGES
          if (pageIngingos + skip >= totalIngs) {
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.3,
          MediaQuery.of(context).size.height * 0.0,
        ),
        backgroundColor: const Color(0xFF00CCE5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON
            Visibility(
              visible: direction == 'inyuma' ? true : false,
              child: Opacity(
                opacity: opacity,
                child: SvgPicture.asset(
                  direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
            Text(
              direction == 'komeza' && pageIngingos + skip >= totalIngs
                  ? 'Soza'
                  : buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color:
                      direction == 'komeza' && pageIngingos + skip >= totalIngs
                          ? Colors.white
                          : Colors.black),
            ), // ICON
            Visibility(
              visible: direction == 'inyuma' ? false : true,
              child: Opacity(
                opacity: pageIngingos + skip >= totalIngs ? 0.0 : opacity,
                child: SvgPicture.asset(
                  direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
