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
  static const int skipIncrement = 5;
  int ingingoID = 0;
  Future<List<PopQuestionModel>?>? pagePopQuestionsFuture = null;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPopQuestions();
  }

  void _loadPopQuestions() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    List<int> listIngingosID2 =
        List.generate(skipIncrement, (i) => ingingoID + i);
    if (listIngingosID2.isNotEmpty) {
      pagePopQuestionsFuture = PopQuestionService()
          .getPopQuestionsByIngingoIDs(widget.isomo.id, listIngingosID2)
          .first
          .whenComplete(() {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      pagePopQuestionsFuture = Future.value([]);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PopQuestionModel>?>(
      future: pagePopQuestionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorText(snapshot.error);
        } else {
          return _buildButton(context, snapshot.data ?? []);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator();
  }

  Widget _buildErrorText(Object? error) {
    return Text('Error: $error');
  }

  Widget _buildButton(
      BuildContext context, List<PopQuestionModel> pgPopQuestions) {
    return MultiProvider(
      providers: [
        StreamProvider<List<PopQuestionModel>?>.value(
          value: Stream.value(pgPopQuestions),
          initialData: null,
          catchError: (context, error) => [],
        ),
      ],
      child: Consumer3<List<IngingoModel>, CourseProgressModel,
          List<PopQuestionModel>?>(
        builder: (context, pageIngingos, courseProgress, pgPopQuestions, _) {
          _updateIngingoID(pageIngingos);
          return ElevatedButton(
            onPressed: isLoading || pgPopQuestions == null
                ? () => _showLoadingMessage(context)
                : () => _handleOnPressed(
                    context, pageIngingos, courseProgress, pgPopQuestions),
            style: _buttonStyle(context),
            child: _buttonChild(context),
          );
        },
      ),
    );
  }

  void _showLoadingMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please wait, loading...')),
    );
  }

  void _updateIngingoID(List<IngingoModel> pageIngingos) {
    if (pageIngingos.isNotEmpty && ingingoID != pageIngingos[0].id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          ingingoID = pageIngingos[0].id;
          _loadPopQuestions();
        });
      });
    }
  }

  void _handleOnPressed(
      BuildContext context,
      List<IngingoModel> pageIngingos,
      CourseProgressModel courseProgress,
      List<PopQuestionModel>? pgPopQuestions) {
    widget.scrollTop();
    if (widget.direction == 'inyuma') {
      widget.changeSkipNumber(-skipIncrement);
    } else if (widget.direction == 'komeza') {
      if (pgPopQuestions != null && pgPopQuestions.isNotEmpty) {
        _navigateToPopQuiz(
            context, pgPopQuestions, courseProgress, pageIngingos.length);
      } else {
        CourseProgressService().updateUserCourseProgress(
          courseProgress.userId,
          widget.isomo.id,
          widget.skip + pageIngingos.length,
          courseProgress.totalIngingos,
          null,
        );
        widget.changeSkipNumber(skipIncrement);
      }
    }
  }

  void _navigateToPopQuiz(
      BuildContext context,
      List<PopQuestionModel> pgPopQuestions,
      CourseProgressModel courseProgress,
      int currentIngingoLength) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopQuiz(
          pagePopQuestions: pgPopQuestions,
          isomo: widget.isomo,
          courseProgress: courseProgress,
          currentIngingo: widget.skip + currentIngingoLength,
          coursechangeSkipNumber: widget.changeSkipNumber,
        ),
      ),
    );
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
