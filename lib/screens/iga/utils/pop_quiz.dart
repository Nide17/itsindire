import 'package:flutter/material.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/screens/iga/utils/circle_progress_pq.dart';
import 'package:tegura/screens/iga/utils/custom_radio_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/direction_button_pq.dart';

class PopQuiz extends StatefulWidget {
  final List<PopQuestionModel> popQuestions;
  final IsomoModel isomo;
  final ValueChanged<int> courseChangeSkip;

  const PopQuiz(
      {super.key,
      required this.popQuestions,
      required this.isomo,
      required this.courseChangeSkip});

  @override
  State<PopQuiz> createState() => _PopQuizState();
}

class _PopQuizState extends State<PopQuiz> {
  // STATE VARIABLES
  int selectedOption = 0;
  bool isCurrentCorrect = false;
  int currQnID = 0;

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // CALLBACK FOR FORWARD BUTTON
    void forward() {
      if (currQnID >= widget.popQuestions.length - 1) {
      } else {
        setState(() {
          currQnID = currQnID + 1;

          // RESET THE SELECTED OPTION
          selectedOption = 0;

          // RESET THE CORRECTNESS OF THE ANSWER
          isCurrentCorrect = false;

          // UPDATE THE SKIP VALUE IN THE PARENT WIDGET (IGA_CONTENT) IF THE USER IS ON THE LAST QUESTION
          if (currQnID == widget.popQuestions.length - 1) {
            widget.courseChangeSkip(5);
          }
        });
      }
    }

    // CALLBACK FOR BACKWARD BUTTON
    void backward() {
      if (currQnID < 1) {
      } else {
        setState(() {
          currQnID = currQnID - 1;

          // RESET THE SELECTED OPTION
          selectedOption = 0;

          // RESET THE CORRECTNESS OF THE ANSWER
          isCurrentCorrect = false;
        });
      }
    }

    return !(currQnID < 1 || (currQnID >= widget.popQuestions.length - 1))
        ?
        // EMPTY WIDGET
        Container()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 228, 225, 225),
            // APP BAR
            appBar: PreferredSize(
              preferredSize: MediaQuery.of(context).size * 0.07,
              child: const AppBarTegura(),
            ),

            // PAGE BODY
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. GRADIENT TITLE
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5B8BDF),
                    ),
                    child: GradientTitle(
                        title: widget.isomo.title, icon: '', marginTop: 8.0),
                  ),

                  // 2. QUESTION OPTIONS
                  Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Column(
                      children: [
                        // 1. QUESTION TITLE
                        Text(
                          widget.popQuestions[currQnID].title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Column(
                          children: widget.popQuestions[currQnID].options
                              .map<Widget>((option) {
                            return CustomRadioButton(
                              // PROPERTIES
                              option: option,
                              isSelected: option['id'] == selectedOption,
                              isThisCorrect: isCurrentCorrect,

                              // ON CHANGE
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = option['id'];
                                  isCurrentCorrect = option['isCorrect'];
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
                  // 2. INYUMA BUTTON
                  DirectionButtonPq(
                    buttonText: 'inyuma',
                    direction: 'inyuma',
                    opacity: 1,
                    backward: backward,
                    popQuestions: widget.popQuestions,
                    currQnID: currQnID,
                    isDisabled: selectedOption == 0,
                  ),

                  // 1. PERCENTAGE INDICATOR
                  CircleProgressPq(
                    percent: (currQnID + 1) / widget.popQuestions.length,
                  ),

                  // 3. KOMEZA BUTTON
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
          );
  }
}
