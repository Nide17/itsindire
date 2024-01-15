import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma_score.dart';

typedef ShowQnCallback = void Function(int index);

class IsuzumaIkibazoButton extends StatefulWidget {
  final ShowQnCallback showQn;
  final int qnIndex;
  final bool isActive;
  final bool isReviewing;

  const IsuzumaIkibazoButton({
    super.key,
    required this.showQn,
    required this.qnIndex,
    required this.isActive,
    required this.isReviewing,
  });

  @override
  State<IsuzumaIkibazoButton> createState() => _IsuzumaIkibazoButtonState();
}

class _IsuzumaIkibazoButtonState extends State<IsuzumaIkibazoButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IsuzumaScoreModel>(builder: (context, scorePModel, child) {
      ScoreQuestionI currentQn = scorePModel.questions[widget.qnIndex - 1];

      return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
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
            backgroundColor: calculateBackgroundColor(
                currentQn, widget.isReviewing, widget.isActive),
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
                  '${widget.qnIndex}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                      color: currentQn.isAnswered || widget.isActive
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

  // CALCULATE COLOR
  Color calculateBackgroundColor(
      ScoreQuestionI currentQn, bool isReviewing, bool isActive) {
    if (isReviewing) {
      if (currentQn.isCorrectChoosen()) {
        return const Color(0xFF00A651).withOpacity(isActive ? 0.7 : 1);
      } else {
        return const Color(0xFFFF5B5B).withOpacity(isActive ? 0.7 : 1);
      }
    } else {
      if (isActive) {
        return const Color(0xFF03369B);
      } else {
        if (currentQn.isAnswered) {
          return const Color.fromARGB(255, 21, 124, 184);
        } else {
          return const Color(0xFF8A8DB8);
        }
      }
    }
  }
}
