import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma_score.dart';

typedef ShowQnCallback = void Function(int index);

class IsuzumaIkibazoButton extends StatefulWidget {
  // INSTANCE VARIABLES
  final ShowQnCallback showQn;
  final int qnIndex;
  final bool isActive;
  final bool isReviewing;

  const IsuzumaIkibazoButton({
    Key? key,
    required this.showQn,
    required this.qnIndex,
    required this.isActive,
    required this.isReviewing,
  }) : super(key: key);

  @override
  State<IsuzumaIkibazoButton> createState() => _IsuzumaIkibazoButtonState();
}

class _IsuzumaIkibazoButtonState extends State<IsuzumaIkibazoButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IsuzumaScoreModel>(builder: (context, scorePModel, child) {
      // GET THE CURRENT QUESTION
      ScoreQuestionI currentQn = scorePModel.questions[widget.qnIndex - 1];

      // RETURN THE BUTTON
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: MediaQuery.of(context).size.width * 0.21,
        height: MediaQuery.of(context).size.height * 0.038,
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.004,),
        child: ElevatedButton(
          onPressed: () {
            widget.isActive ? null : widget.showQn(widget.qnIndex);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: calculateBackgroundColor(
                currentQn, widget.isReviewing, widget.isActive),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.004,),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Text(
                  'Ikibazo ${widget.qnIndex}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
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