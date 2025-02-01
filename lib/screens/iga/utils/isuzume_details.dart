import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/custom_radio_button.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/providers/quiz_score_provider.dart';
import 'package:itsindire/screens/iga/utils/iga_content.dart';
import 'package:itsindire/utilities/ikibazo_button.dart';
import 'package:transparent_image/transparent_image.dart';

typedef ShowQnCallback = void Function(int index);
typedef SetSetSelectedOption = void Function(OptionPopQn? option);

class IsuzumeDetails extends StatefulWidget {
  final IsomoModel isomo;
  final String userID;
  final CourseProgressModel? courseProgress;
  final int qnIndex;
  final bool isCurrentCorrect;
  final ShowQnCallback showQn;
  final int selectedOption;
  final SetSetSelectedOption setSelectedOption;

  const IsuzumeDetails({
    super.key,
    required this.isomo,
    required this.userID,
    this.courseProgress,
    required this.qnIndex,
    required this.isCurrentCorrect,
    required this.showQn,
    required this.selectedOption,
    required this.setSelectedOption,
  });

  @override
  State<IsuzumeDetails> createState() => _IsuzumeDetailsState();
}

class _IsuzumeDetailsState extends State<IsuzumeDetails> {
  bool loadingProgressUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizScoreProvider>(
      builder: (context, scoreProviderModel, child) {
        List<ScoreQuestion> scorePopQns = scoreProviderModel.quizScore.questions;
        final scorePopQnsLength = scoreProviderModel.quizScore.questions.length;

        return Consumer<List<PopQuestionModel>?>(
          builder: (context, quizPopQuestions, child) {
            return Scaffold(
              body: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                ),
                child: Column(
                  children: [
                    GradientTitle(
                      title: widget.isomo.title,
                      icon: 'assets/images/amasuzumabumenyi.svg',
                      marginTop: 8.0,
                      parentWidget: 'isuzume',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Expanded(
                      child: scorePopQnsLength == 0
                          ? _buildNoQuestionsFound()
                          : _buildQuestionsList(scorePopQns, scoreProviderModel),
                    ),
                    if (loadingProgressUpdate) const CircularProgressIndicator(),
                    _buildRestartButton(context, quizPopQuestions),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoQuestionsFound() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Nta bibazo byabonetse!'),
        ),
      ],
    );
  }

  Widget _buildQuestionsList(List<ScoreQuestion> scorePopQns, QuizScoreProvider scoreProviderModel) {
    return Column(
      children: [
        _buildQuestionNavigation(scorePopQns.length),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuestionTitle(scorePopQns),
                  _buildQuestionImage(scorePopQns),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                  _buildOptionsList(scoreProviderModel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionNavigation(int scorePopQnsLength) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.008,
        ),
        child: Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ScrollbarTheme(
            data: const ScrollbarThemeData(
              thumbColor: WidgetStatePropertyAll(Color.fromARGB(255, 166, 0, 0)),
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.008,
                  ),
                  child: Wrap(
                    spacing: 10.0,
                    direction: Axis.horizontal,
                    children: List.generate(
                      scorePopQnsLength,
                      (index) => IkibazoButton(
                        isActive: index == widget.qnIndex,
                        showQn: widget.showQn,
                        qnIndex: index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTitle(List<ScoreQuestion> scorePopQns) {
    return Text(
      scorePopQns[widget.qnIndex].popQuestion.title ?? '',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _buildQuestionImage(List<ScoreQuestion> scorePopQns) {
    final imageUrl = scorePopQns[widget.qnIndex].popQuestion.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.only(top: 10.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border.fromBorderSide(
            BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: kTransparentImage,
          image: imageUrl,
          height: MediaQuery.of(context).size.height * 0.2,
        ),
      ),
    );
  }

  Widget _buildOptionsList(QuizScoreProvider scoreProviderModel) {
    return Column(
      children: scoreProviderModel.quizScore.questions[widget.qnIndex].popQuestion.options.map<Widget>((option) {
        return CustomRadioButton(
          option: option,
          choosenOption: scoreProviderModel.quizScore.questions[widget.qnIndex].choosenOption,
          isAnswered: scoreProviderModel.quizScore.questions[widget.qnIndex].isAnswered,
          isAnswerCorrect: scoreProviderModel.quizScore.questions[widget.qnIndex].isAnswerCorrect,
          isThisCorrect: widget.isCurrentCorrect,
          scoreProviderModel: scoreProviderModel,
          isSelected: option.id == widget.selectedOption,
          currentQuestion: scoreProviderModel.quizScore.questions[widget.qnIndex].popQuestion,
          onChanged: (value) {
            widget.setSelectedOption(option);
            scoreProviderModel.quizScore.changeIsAnsweredStatus(
              scoreProviderModel.quizScore.questions[widget.qnIndex].popQuestion.id,
              true,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildRestartButton(BuildContext context, List<PopQuestionModel>? quizPopQuestions) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.8,
          MediaQuery.of(context).size.height * 0.002,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ItsindireAlert(
              errorTitle: 'IBIJYANYE NIRI SOMO',
              errorMsg: 'Ugiye kwiga isomo ryitwa "${widget.isomo.title}" rigizwe n’ingingo "${widget.courseProgress!.totalIngingos}" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : widget.courseProgress!.totalIngingos * 4}" gusa!',
              firstButtonTitle: 'Inyuma',
              firstButtonFunction: () {
                Navigator.pop(context);
              },
              firstButtonColor: const Color(0xFFE60000),
              secondButtonTitle: 'Tangira',
              secondButtonFunction: () async {
                setState(() {
                  loadingProgressUpdate = true;
                });
                if (quizPopQuestions != null) {
                  CourseProgressService().updateUserCourseProgress(
                    widget.courseProgress!.userId,
                    widget.courseProgress!.courseId,
                    0,
                    widget.courseProgress!.totalIngingos,
                    quizPopQuestions.length,
                  );
                }
                setState(() {
                  loadingProgressUpdate = false;
                });
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IgaContent(
                      isomo: widget.isomo,
                      thisCourseTotalIngingos: widget.courseProgress!.totalIngingos,
                    ),
                  ),
                );
              },
              secondButtonColor: const Color(0xFF00A651),
            );
          },
        );
      },
      child: Text(
        'Ongera utangire iri somo!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height * 0.014,
        ),
      ),
    );
  }
}
