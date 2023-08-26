import 'package:flutter/material.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/providers/quiz_score_provider.dart';

class CustomRadioButton extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool?> onChanged;
  final bool isThisCorrect;
  final List<ScoreQuestion>? scoreQuestions;
  final QuizScoreProvider? scoreProviderModel;
  final Map<String, dynamic>? option;
  final PopQuestionModel? currentQuestion;
  final int? choosenOption;
  final bool? isAnswered;
  final bool? isAnswerCorrect; // NULL AT FIRST

  const CustomRadioButton({
    super.key,

    // POP QUESTIONS
    required this.isSelected,
    required this.isThisCorrect,
    required this.onChanged,
    this.scoreQuestions,
    this.scoreProviderModel,
    this.option,
    this.currentQuestion,

    // SCORE QUESTIONS
    this.choosenOption,
    this.isAnswered,
    this.isAnswerCorrect,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    bool? isThisCorrect = widget.isAnswered == null
        ? widget.isThisCorrect
        : // CASE OF POP QUESTIONS
        (widget.isAnswered == true &&
                widget.option!['id'] == widget.choosenOption &&
                widget.isAnswerCorrect == true)
            ? true
            : null;

    bool? isSelected = widget.isAnswered == null
        ? widget.isSelected
        : // CASE OF POP QUESTIONS
        (widget.isAnswered == true &&
                widget.option!['id'] == widget.choosenOption)
            ? true
            : false;

    return GestureDetector(
      onTap: () {
        // CALL THE ONCHANGED FUNCTION
        widget.onChanged(!isSelected);

        // SET THE OPTION CHOICE ID
        if (widget.scoreProviderModel != null) {
          for (var element in widget.scoreProviderModel!.quizScore.questions) {
            if (element.popQuestion.id == widget.currentQuestion!.id) {
              element.isAnswered = true;
              element.setChoosenOption(widget.option!['id']);
              element.setIsAnswerCorrect(widget.option!['id'] ==
                  widget.currentQuestion!.getCorrectOptionId());
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.006),
              margin: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height * 0.015),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? getDisplayColor(isThisCorrect)
                        : Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 2,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: isSelected ? 
                  getDisplayColor(isThisCorrect) : Colors.grey,
                  width: 1.0,
                ),
              ),

              // THE OPTION: CHECKMARK, TEXT
              child: Row(
                children: [
                  Container(
                    width: 28.0,
                    height: 28.0,
                    margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: MediaQuery.of(context).size.height * 0.002,
                      ),
                    ),

                    // THE CHECKMARK OR CROSS
                    child: isSelected
                        ? Icon(isThisCorrect == true
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: isThisCorrect == true
                                ? Colors.green
                                : Colors.red,
                            size: 24.0,
                          )
                        : Container(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.option != null ? widget.option!['text'] : '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THE DESCRIPTION SUBTITLE IF SELECTED
            isSelected
                ? Wrap(
                    children: [
                      isThisCorrect == true
                          ? const Text('Wabikoze! ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold))
                          : const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Ongera ugerageze!',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),
                      Text(
                        isThisCorrect == true &&
                                widget.option != null &&
                                widget.option!['description'] != null
                            ? widget.option!['description']
                            : '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Color getDisplayColor(bool? isThisCorrect) {
    if (isThisCorrect != null) {
      if (isThisCorrect == true) {
        return Colors.green;
      } else if (isThisCorrect == false) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }
}
