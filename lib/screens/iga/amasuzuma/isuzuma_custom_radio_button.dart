import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/isuzuma_score.dart';

class IsuzumaCustomRadioButton extends StatefulWidget {
  final ScoreOptionI? option;
  final int? curQnIndex;
  final bool isReviewing;

  const IsuzumaCustomRadioButton({
    super.key,
    this.option,
    this.curQnIndex,
    required this.isReviewing,
  });

  @override
  State<IsuzumaCustomRadioButton> createState() =>
      _IsuzumaCustomRadioButtonState();
}

class _IsuzumaCustomRadioButtonState extends State<IsuzumaCustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IsuzumaScoreModel>(builder: (context, scorePrModel, child) {
      bool isThisBtnSelected = scorePrModel.isThisAnswerOptionChoosen(
        widget.curQnIndex!,
        widget.option!.id,
      );

      String btnText = (widget.option!.isCorrect && widget.option!.isChoosen!)
          ? 'Wabikoze!'
          : (widget.option!.isCorrect && widget.option!.isChoosen! == false)
              ? 'Igisubizo nyacyo'
              : (widget.option!.isCorrect == false && widget.option!.isChoosen!)
                  ? 'Wasubije ikitaricyo!'
                  : '';

      return GestureDetector(
        onTap: () {
          scorePrModel.setAnswerOption(
            widget.curQnIndex!,
            widget.option!.id,
          );
        },
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
                    color: widget.isReviewing
                        ? getDisplayColor(
                            widget.option!.isCorrect, widget.isReviewing)
                        : Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
                color:
                    widget.isReviewing ? getReviewChoosenColor() : Colors.white,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                border: Border.all(
                  color: widget.isReviewing
                      ? getDisplayColor(
                          widget.option!.isCorrect, widget.isReviewing)
                      : const Color(0xFFFFBD59),
                  width: MediaQuery.of(context).size.width * 0.004,
                ),
              ),

              // THE OPTION: CHECKMARK, TEXT
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height * 0.023,
                    height: MediaQuery.of(context).size.height * 0.023,
                    margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.004,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isThisBtnSelected ? Colors.black : Colors.grey,
                        width: MediaQuery.of(context).size.height * 0.002,
                      ),
                    ),

                    // THE CHECKMARK OR CROSS
                    child: isThisBtnSelected
                        ? Icon(
                            widget.option!.isCorrect ||
                                    widget.isReviewing == false
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: getDisplayColor(
                                widget.option!.isCorrect, widget.isReviewing),
                            size: MediaQuery.of(context).size.height * 0.018,
                          )
                        : !isThisBtnSelected && widget.isReviewing
                            ? Icon(
                                widget.option!.isCorrect
                                    ? Icons.check_circle
                                    : widget.option!.isCorrect == false &&
                                            widget.option!.isChoosen == true
                                        ? Icons.cancel
                                        : Icons.radio_button_unchecked,
                                color: getDisplayColor(widget.option!.isCorrect,
                                    widget.isReviewing),
                                size:
                                    MediaQuery.of(context).size.height * 0.018,
                              )
                            : Container(),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Expanded(
                    child: Text(
                      widget.option != null ? widget.option!.text! : '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.017,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THE DESCRIPTION SUBTITLE IF SELECTED
            widget.isReviewing &&
                    (widget.option!.isCorrect ||
                        (widget.option!.isCorrect == false &&
                            widget.option!.isChoosen == true))
                ? Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: [
                          Text(btnText,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: btnText == 'Wasubije ikitaricyo!'
                                      ? Colors.red
                                      : const Color(0xFF00A651),
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.014,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            widget.option!.isCorrect && widget.option != null
                                ? widget.option!.explanation ?? ''
                                : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.014,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    });
  }

  Color getDisplayColor(bool? isThisCorrect, bool isReviewing) {
    if (!isReviewing) {
      return Colors.purple;
    } else {
      if (isThisCorrect != null) {
        if (isThisCorrect) {
          return const Color.fromARGB(255, 139, 228, 144);
        } else if (isThisCorrect == false && widget.option!.isChoosen == true) {
          return const Color.fromARGB(255, 253, 140, 140);
        } else {
          return Colors.grey;
        }
      } else {
        return Colors.grey;
      }
    }
  }

  // CALCULATE REVIEWCHOOSEN COLOR
  Color getReviewChoosenColor() {
    if (widget.option!.isCorrect && widget.option!.isChoosen == true) {
      return Colors.green;
    } else if (widget.option!.isCorrect == false && widget.option!.isChoosen == true) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }
}
