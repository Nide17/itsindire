import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/pop_question_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/screens/iga/utils/pop_quiz.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';

class DirectionButton extends StatefulWidget {
  final String buttonText;
  final String direction;
  final double opacity;
  final ValueChanged<int> changeSkipNumber;
  final Function scrollTop;
  final IsomoModel isomo;
  final int skip;
  final int increment;

  const DirectionButton({
    super.key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    required this.changeSkipNumber,
    required this.scrollTop,
    required this.isomo,
    required this.skip,
    required this.increment,
  });

  @override
  State<DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
  @override
  Widget build(BuildContext context) {
    final pageIngingos = Provider.of<List<IngingoModel>?>(context) ?? [];
    final courseProgress = Provider.of<CourseProgressModel?>(context);
    final List<int> listIngingosID =
        pageIngingos.map((ing) => ing.id + widget.increment).toList();
        
    return MultiProvider(
      providers: [
        StreamProvider<List<PopQuestionModel>?>.value(
          value: listIngingosID.isNotEmpty
              ? PopQuestionService().getPopQuestionsByIngingoIDs(
                  widget.isomo.id,
                  listIngingosID,
                )
              : null,
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<List<PopQuestionModel>?>(
          builder: (context, popQuestions, child) {
        List<int> currentIngingosIds = pageIngingos.map((e) => e.id).toList();

        bool isIngingosHavePopQuestions = currentIngingosIds.contains(
            popQuestions != null && popQuestions.isNotEmpty
                ? popQuestions[0].ingingoID
                : 0);

        // print('isIngingosHavePopQuestions: $isIngingosHavePopQuestions');
        // print('popQuestions: $popQuestions');
        return ElevatedButton(
          onPressed: () {
            widget.scrollTop();
            if (widget.direction == 'inyuma') {
              widget.changeSkipNumber(-5);
            } else if (widget.direction == 'komeza') {
              // UPDATE THE CURRENT INGINGO
              if (widget.skip >= 0 &&
                  widget.skip <= courseProgress!.totalIngingos &&
                  pageIngingos.length + widget.skip >
                      courseProgress.currentIngingo) {
                CourseProgressService().updateUserCourseProgress(
                  courseProgress.userId,
                  widget.isomo.id,
                  widget.skip + pageIngingos.length,
                  courseProgress.totalIngingos,
                );
              }

              if (popQuestions != null &&
                  popQuestions.isNotEmpty &&
                  isIngingosHavePopQuestions) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PopQuiz(
                      popQuestions: popQuestions,
                      isomo: widget.isomo,
                      coursechangeSkipNumber: widget.changeSkipNumber,
                    ),
                  ),
                );
              } else {
                widget.changeSkipNumber(5);
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
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          ),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  widget.buttonText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Colors.black),
                ),
                Visibility(
                  visible: widget.direction == 'inyuma' ? false : true,
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
