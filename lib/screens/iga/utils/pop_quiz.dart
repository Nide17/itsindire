import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/circle_progress_pq.dart';
import 'package:itsindire/screens/iga/utils/custom_radio_button.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/direction_button_pq.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class PopQuiz extends StatefulWidget {
  final List<PopQuestionModel> pagePopQuestions;
  final IsomoModel isomo;
  final CourseProgressModel courseProgress;
  final int currentIngingo;
  final ValueChanged<int> coursechangeSkipNumber;

  const PopQuiz({
    super.key,
    required this.pagePopQuestions,
    required this.isomo,
    required this.courseProgress,
    required this.currentIngingo,
    required this.coursechangeSkipNumber,
  });

  @override
  State<PopQuiz> createState() => _PopQuizState();
}

class _PopQuizState extends State<PopQuiz> {
  int selectedOption = 0;
  bool isCurrentCorrect = false;
  int currentQuestionNo = 1;
  bool loading = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<AuthState>(context, listen: false).currentUser;
  }

  void handleQuizCompletion() {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      loading = true;
    });

    widget.coursechangeSkipNumber(5); // Update skip value in parent widget

    // Update the user's course progress with the current ingingo and unanswered pop questions
    if (currentUser != null) {
      CourseProgressService().updateUserCourseProgress(
        widget.courseProgress.userId,
        widget.isomo.id,
        widget.currentIngingo,
        widget.courseProgress.totalIngingos,
        widget.courseProgress.unansweredPopQuestions -
            widget.pagePopQuestions.length,
      );
    }

    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      loading = false;
    });
  }

  void forward() {
    if (currentQuestionNo < widget.pagePopQuestions.length) {
      setState(() {
        currentQuestionNo++;
        resetSelection();
      });
    } else {
      handleQuizCompletion();
    }
  }

  void backward() {
    if (currentQuestionNo > 1) {
      setState(() {
        currentQuestionNo--;
        resetSelection();
      });
    }
  }

  void resetSelection() {
    selectedOption = 0;
    isCurrentCorrect = false;
  }

  Widget buildQuestionTitle() {
    return Text(
      widget.pagePopQuestions[currentQuestionNo - 1].title ?? '',
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildQuestionImage() {
    return widget.pagePopQuestions[currentQuestionNo - 1].imageUrl == null ||
            widget.pagePopQuestions[currentQuestionNo - 1].imageUrl == ''
        ? const SizedBox.shrink()
        : SizedBox(
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
                image: widget.pagePopQuestions[currentQuestionNo - 1].imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  Widget buildOptions() {
    return Column(
      children: widget.pagePopQuestions[currentQuestionNo - 1].options
          .map<Widget>((option) {
        return CustomRadioButton(
          option: option,
          isSelected: option.id == selectedOption,
          isThisCorrect: isCurrentCorrect,
          onChanged: (value) {
            setState(() {
              selectedOption = option.id;
              isCurrentCorrect = option.isCorrect;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int lastQuestion = widget.pagePopQuestions.length;

    return loading == true
        ? const Center(child: CircularProgressIndicator())
        : currentQuestionNo > 0 &&
                currentQuestionNo <= widget.pagePopQuestions.length
            ? Scaffold(
                backgroundColor: const Color.fromARGB(255, 228, 225, 225),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(58.0),
                  child: AppBarItsindire(),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildGradientTitle(),
                      buildQuestionContent(),
                    ],
                  ),
                ),
                bottomNavigationBar: buildBottomNavigationBar(lastQuestion),
              )
            : const SizedBox.shrink();
  }

  Widget buildGradientTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      decoration: const BoxDecoration(
        color: Color(0xFF5B8BDF),
      ),
      child: GradientTitle(title: widget.isomo.title, icon: '', marginTop: 8.0),
    );
  }

  Widget buildQuestionContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        children: [
          buildQuestionTitle(),
          buildQuestionImage(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.016),
          buildOptions(),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar(int lastQuestion) {
    const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
    const Color shadowColor = Color.fromARGB(255, 72, 255, 0);

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: const BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, -1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DirectionButtonPq(
            buttonText: 'inyuma',
            direction: 'inyuma',
            opacity: 1,
            backward: backward,
            pagePopQuestions: widget.pagePopQuestions,
            currentQuestionNo: currentQuestionNo,
            isDisabled: false,
          ),
          CircleProgressPq(
            percent: currentQuestionNo / widget.pagePopQuestions.length,
          ),
          DirectionButtonPq(
            buttonText: 'komeza',
            direction: 'komeza',
            opacity: 1,
            forward: forward,
            pagePopQuestions: widget.pagePopQuestions,
            currentQuestionNo: currentQuestionNo,
            isDisabled: selectedOption == 0 || !isCurrentCorrect,
          ),
        ],
      ),
    );
  }
}
