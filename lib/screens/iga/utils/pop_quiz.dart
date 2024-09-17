import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/circle_progress_pq.dart';
import 'package:itsindire/screens/iga/utils/custom_radio_button.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/direction_button_pq.dart';
import 'package:transparent_image/transparent_image.dart';

class PopQuiz extends StatefulWidget {
  final List<PopQuestionModel> popQuestions;
  final IsomoModel isomo;
  final CourseProgressModel courseProgress;
  final int currentIngingo;
  final ValueChanged<int> coursechangeSkipNumber;

  const PopQuiz({
    super.key,
    required this.popQuestions,
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
  int currQnID = 0;

  @override
  Widget build(BuildContext context) {
    void forward() {
      setState(() {
        if (currQnID < widget.popQuestions.length - 1) {
          currQnID++;
        } else {
          widget
              .coursechangeSkipNumber(5); // Update skip value in parent widget

          // Update the number of answered questions in the course progress
          CourseProgressService()
              .updateUnansweredPopQuestions(
                  '${widget.isomo.id}_${FirebaseAuth.instance.currentUser!.uid}',
                  -widget.popQuestions.length)
              .then((value) {
            CourseProgressService().updateUserCourseProgress(
                widget.courseProgress.userId,
                widget.isomo.id,
                widget.currentIngingo,
                widget.courseProgress.totalIngingos,
                null);
          });
        }
        selectedOption = 0;
        isCurrentCorrect = false;
      });
    }

    void backward() {
      if (currQnID > 0 && selectedOption != 0) {
        // Ensure an option is selected
        setState(() {
          currQnID--;
          selectedOption = 0;
          isCurrentCorrect = false;
        });
      }
    }

    return currQnID >= 0 && currQnID < widget.popQuestions.length
        ? Scaffold(
            backgroundColor: const Color.fromARGB(255, 228, 225, 225),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: AppBarItsindire(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5B8BDF),
                    ),
                    child: GradientTitle(
                        title: widget.isomo.title, icon: '', marginTop: 8.0),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.popQuestions[currQnID].title ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.popQuestions[currQnID].imageUrl == null ||
                                widget.popQuestions[currQnID].imageUrl == ''
                            ? const SizedBox.shrink()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        offset: Offset(0, 1),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image:
                                        widget.popQuestions[currQnID].imageUrl!,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        Column(
                          children: widget.popQuestions[currQnID].options
                              .map<Widget>((option) {
                            return CustomRadioButton(
                              option: option,
                              isSelected: option.id == selectedOption,
                              isThisCorrect: isCurrentCorrect,

                              // ON CHANGE
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = option.id;
                                  isCurrentCorrect = option.isCorrect;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 72, 255, 0),
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
                    popQuestions: widget.popQuestions,
                    currQnID: currQnID,
                    isDisabled: selectedOption == 0,
                  ),
                  CircleProgressPq(
                    percent: (currQnID + 1) / widget.popQuestions.length,
                  ),
                  DirectionButtonPq(
                    buttonText: 'komeza',
                    direction: 'komeza',
                    opacity: 1,
                    forward: forward,
                    popQuestions: widget.popQuestions,
                    currQnID: currQnID,
                    isDisabled: selectedOption == 0 || !isCurrentCorrect,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
