import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/screens/iga/utils/quiz_score_provider.dart';

typedef ShowQnCallback = void Function(int index);

class IkibazoButton extends StatefulWidget {
  // INSTANCE VARIABLES
  final String buttonText;
  final ShowQnCallback showQn;
  final PopQuestionModel popQuestion;
  final int index;
  final bool isActive;

  const IkibazoButton({
    Key? key,
    required this.buttonText,
    required this.showQn,
    required this.popQuestion,
    required this.index,
    required this.isActive,
  }) : super(key: key);

  @override
  State<IkibazoButton> createState() => _IkibazoButtonState();
}

class _IkibazoButtonState extends State<IkibazoButton> {

  @override
  Widget build(BuildContext context) {
    // // UPDATE THE QUESTION SCORE FOR THIS QUESTION
    // // BUILD ScoreQuestion - final PopQuestionModel popQuestion, bool isAnswered, int optionChoiceID
    // ScoreQuestion scoreQuestion = ScoreQuestion(
    //   popQuestion: widget.popQuestion,
    //   isAnswered: isAnswered,
    //   optionChoiceID: -1,
    // );

    // // UPDATE THE SCORE OBJECT
    // widget.scoreObject.updateQuestion(scoreQuestion);

    // RETURN THE BUTTON
    return Consumer<QuizScoreProvider>(
        builder: (context, scoreProviderModel, child) {
          print(scoreProviderModel.quizScore.questions[widget.index].isAnswered);
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: MediaQuery.of(context).size.width * 0.3,
        child: ElevatedButton(
          onPressed: () {
            widget.isActive ? null : widget.showQn(widget.index);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.height * 0.0,
            ),
            backgroundColor: widget.isActive
                ? const Color(0xFF03369B)
                : scoreProviderModel.quizScore.questions[widget.index].isAnswered
                    ? const Color(0xFF00CCE5)
                    : const Color(0xFF8A8DB8),
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
                Text(
                  widget.buttonText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: scoreProviderModel.quizScore
                                  .questions[widget.index].isAnswered || widget.isActive
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}