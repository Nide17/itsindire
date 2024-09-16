import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/screens/iga/utils/pop_quiz.dart';
import 'package:tegura/services/isomo_progress.dart';

class DirectionButton extends StatefulWidget {
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
  State<DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
  @override
  Widget build(BuildContext context) {
    // GET THE INGINGOS
    final ingingos = Provider.of<List<IngingoModel>?>(context) ?? [];

    // GET THE INGINGOS LENGTH
    final pageIngingos = ingingos.length;

    // GET THE COURSE PROGRESS
    final courseProgress = Provider.of<CourseProgressModel?>(context);

    // GET THE TOTAL NUMBER OF INGINGOS IN THE COURSE
    final totalIngsInProgr =
        courseProgress != null ? courseProgress.totalIngingos : 0;

    // GET THE POP QUESTIONS
    final popQuestions = Provider.of<List<PopQuestionModel>?>(context);

    // LIST OF INGINGOS STATE IDS
    List<int> currentIngingosIds = ingingos.map((e) => e.id).toList();

    // CHECK IF THE FIRST POP QUESTION ID IS IN THE LIST OF INGINGOS IDS
    bool isPopQuestionInIngingos = currentIngingosIds.contains(
        popQuestions != null && popQuestions.isNotEmpty
            ? popQuestions[0].ingingoID
            : 0);

    return ElevatedButton(
      onPressed: () {
        if (widget.direction == 'inyuma') {
          // DECREASE SKIP STATE
          widget.changeSkip(-5);
        } else if (widget.direction == 'komeza') {
          // IF THIS PAGE HAS POP QUESTIONS, THEN SHOW THEM FIRST BEFORE PROCEEDING TO THE NEXT PAGE
          if (popQuestions != null &&
              popQuestions.isNotEmpty &&
              isPopQuestionInIngingos) {
            // PUSH THE POP QUESTIONS TO THE SCREEN
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PopQuiz(
                  popQuestions: popQuestions,
                  isomo: widget.isomo,
                  courseChangeSkip: widget.changeSkip,
                ),
              ),
            );
          } else {
            // INCREASE SKIP STATE
            widget.changeSkip(5);
          }

          // UPDATE THE CURRENT INGINGO
          if (widget.skip >= 0 &&
              widget.skip < totalIngsInProgr &&
              pageIngingos + widget.skip > courseProgress!.currentIngingo) {
            // UPDATE THE CURRENT INGINGO
            CourseProgressService().updateUserCourseProgress(
              courseProgress.userId,
              widget.isomo.id,
              courseProgress.totalIngingos < courseProgress.currentIngingo
                  ? courseProgress.currentIngingo
                  : courseProgress.totalIngingos,
              widget.skip + pageIngingos,
            );
          }
          // REMOVE THE CURRENT PAGE FROM THE STACK IF NO MORE NEXT PAGES
          if (pageIngingos + widget.skip >= totalIngsInProgr) {
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
              visible: widget.direction == 'inyuma' ? true : false,
              child: Opacity(
                opacity: widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
            Text(
              widget.direction == 'komeza' &&
                      pageIngingos + widget.skip >= totalIngsInProgr
                  ? 'Soza'
                  : widget.buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: widget.direction == 'komeza' &&
                          pageIngingos + widget.skip >= totalIngsInProgr
                      ? Colors.white
                      : Colors.black),
            ), // ICON
            Visibility(
              visible: widget.direction == 'inyuma' ? false : true,
              child: Opacity(
                opacity: pageIngingos + widget.skip >= totalIngsInProgr
                    ? 0.0
                    : widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
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
