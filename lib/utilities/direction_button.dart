import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/pop_question_db.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/ingingo.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/pop_quiz.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';

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
  int ingingoID = 0;

  @override
  Widget build(BuildContext context) {
    // Generate a list of ingingos IDs from ingingoID
    List<int> listIngingosID2 = List.generate(5, (i) => ingingoID + i);

    return MultiProvider(
      providers: [
        StreamProvider<List<PopQuestionModel>?>.value(
          value: listIngingosID2.isNotEmpty
              ? PopQuestionService().getPopQuestionsByIngingoIDs(
                  widget.isomo.id,
                  listIngingosID2,
                )
              : null,
          initialData: null,
          catchError: (context, error) => [],
        ),
      ],
      child: Consumer3<List<IngingoModel>, CourseProgressModel?, List<PopQuestionModel>?>(
        builder: (context, pageIngingos, courseProgress, pagePopQuestions, _) {
          print('pagePopQuestions: $pagePopQuestions');

          if (pageIngingos.isNotEmpty && ingingoID != pageIngingos[0].id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                ingingoID = pageIngingos[0].id;
              });
            });
          }

          List<int> currentIngingosIds =
              pageIngingos.isNotEmpty ? pageIngingos.map((e) => e.id).toList() : [];

          bool isPageIngingosHavePopQuestions = currentIngingosIds.contains(
              pagePopQuestions != null && pagePopQuestions.isNotEmpty
                  ? pagePopQuestions[0].ingingoID
                  : 0);

          return ElevatedButton(
            onPressed: () => _handleOnPressed(context, pageIngingos, courseProgress, pagePopQuestions, isPageIngingosHavePopQuestions),
            style: _buttonStyle(context),
            child: _buttonChild(context),
          );
        },
      ),
    );
  }

  void _handleOnPressed(BuildContext context, List<IngingoModel> pageIngingos, CourseProgressModel? courseProgress, List<PopQuestionModel>? pagePopQuestions, bool isPageIngingosHavePopQuestions) {
    widget.scrollTop();
    if (widget.direction == 'inyuma') {
      widget.changeSkipNumber(-5);
    } else if (widget.direction == 'komeza') {
      // UPDATE THE CURRENT INGINGO
      if (widget.skip >= 0 &&
          widget.skip <= courseProgress!.totalIngingos &&
          pageIngingos.length + widget.skip >
              courseProgress.currentIngingo &&
          pagePopQuestions!.isEmpty) {
        CourseProgressService().updateUserCourseProgress(
          courseProgress.userId,
          widget.isomo.id,
          widget.skip + pageIngingos.length,
          courseProgress.totalIngingos,
          null,
        );
      }

      if (pagePopQuestions != null &&
          pagePopQuestions.isNotEmpty &&
          isPageIngingosHavePopQuestions) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PopQuiz(
              popQuestions: pagePopQuestions,
              isomo: widget.isomo,
              courseProgress: courseProgress!,
              currentIngingo: widget.skip + pageIngingos.length,
              coursechangeSkipNumber: widget.changeSkipNumber,
            ),
          ),
        );
      } else {
        widget.changeSkipNumber(5);
      }
    }
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.3,
        MediaQuery.of(context).size.height * 0.0,
      ),
      backgroundColor: const Color(0xFF00CCE5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: BorderSide(
            color: const Color.fromARGB(255, 0, 0, 0),
            style: BorderStyle.solid,
            width: MediaQuery.of(context).size.width * 0.005,
          )),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget _buttonChild(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(widget.direction == 'inyuma'),
          Text(
            widget.buttonText,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.black),
          ),
          _buildIcon(widget.direction != 'inyuma'),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Opacity(
        opacity: widget.opacity,
        child: SvgPicture.asset(
          widget.direction == 'inyuma'
              ? 'assets/images/backward.svg'
              : 'assets/images/forward.svg',
          width: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
    );
  }
}
