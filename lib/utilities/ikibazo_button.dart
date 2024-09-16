import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/providers/quiz_score_provider.dart';

typedef ShowQnCallback = void Function(int index);

class IkibazoButton extends StatefulWidget {
  final ShowQnCallback showQn;
  final int qnIndex;
  final bool isActive;

  const IkibazoButton({
    super.key,
    required this.showQn,
    required this.qnIndex,
    required this.isActive,
  });

  @override
  State<IkibazoButton> createState() => _IkibazoButtonState();
}

class _IkibazoButtonState extends State<IkibazoButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizScoreProvider>(
        builder: (context, scoreProviderModel, child) {

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
        width: MediaQuery.of(context).size.width * 0.08,
                margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.00,
          horizontal: MediaQuery.of(context).size.width * 0.00,
        ),
        child: ElevatedButton(
          onPressed: () {
            widget.isActive ? null : widget.showQn(widget.qnIndex);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isActive
                ? const Color.fromARGB(255, 0, 47, 142)
                : scoreProviderModel
                        .quizScore.questions[widget.qnIndex].isAnswered
                    ? const Color(0xFF00CCE5)
                    : const Color.fromARGB(255, 167, 170, 210),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                side: BorderSide(
                    color: const Color(0xFFFFBD59),
                    width: MediaQuery.of(context).size.width * 0.004,
                    style: BorderStyle.solid)),
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.height * 0.001,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Text(
                  '${widget.qnIndex + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: scoreProviderModel.quizScore
                                  .questions[widget.qnIndex].isAnswered ||
                              widget.isActive
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
