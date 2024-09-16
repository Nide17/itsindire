import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma_score.dart';

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

      String btnText = (widget.option!.isCorrect == true &&
              widget.option!.isChoosen! == true)
          ? 'Wabikoze!'
          : (widget.option!.isCorrect == true &&
                  widget.option!.isChoosen! == false)
              ? 'Igisubizo nyacyo'
              : (widget.option!.isCorrect == false &&
                      widget.option!.isChoosen! == true)
                  ? 'Wasubije ikitaricyo!'
                  : '';

      return GestureDetector(
        onTap: () {
          scorePrModel.setAnswerOption(
            widget.curQnIndex!,
            widget.option!.id,
          );
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
                      color: widget.isReviewing == true
                          ? getDisplayColor(
                              widget.option!.isCorrect, widget.isReviewing)
                          : Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 4),
                      blurRadius: 2,
                    ),
                  ],
                  color: widget.isReviewing == true
                      ? getReviewChoosenColor()
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: widget.isReviewing == true
                        ? getDisplayColor(
                            widget.option!.isCorrect, widget.isReviewing)
                        : Colors.grey,
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
                          color: isThisBtnSelected ? Colors.black : Colors.grey,
                          width: MediaQuery.of(context).size.height * 0.002,
                        ),
                      ),

                      // THE CHECKMARK OR CROSS
                      child: isThisBtnSelected
                          ? Icon(
                              widget.option!.isCorrect == true ||
                                      widget.isReviewing == false
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: getDisplayColor(
                                  widget.option!.isCorrect, widget.isReviewing),
                              size: 24.0,
                            )
                          : !isThisBtnSelected && widget.isReviewing
                              ? Icon(
                                  widget.option!.isCorrect == true
                                      ? Icons.check_circle
                                      : widget.option!.isCorrect == false &&
                                              widget.option!.isChoosen == true
                                          ? Icons.cancel
                                          : Icons.radio_button_unchecked,
                                  color: getDisplayColor(
                                      widget.option!.isCorrect,
                                      widget.isReviewing),
                                  size: 24.0,
                                )
                              : Container(),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        widget.option != null ? widget.option!.text! : '',
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
              widget.isReviewing == true
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: [
                          Text(btnText,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: btnText == 'Wasubije ikitaricyo!'
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          Text(
                            widget.option!.isCorrect == true &&
                                    widget.option != null
                                ? widget.option!.explanation ?? ''
                                : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }

  Color getDisplayColor(bool? isThisCorrect, bool isReviewing) {
    if (!isReviewing) {
      return Colors.purple;
    } else {
      if (isThisCorrect != null) {
        if (isThisCorrect == true) {
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
    if (widget.option!.isCorrect == true && widget.option!.isChoosen == true) {
      return Colors.green;
    } else if (widget.option!.isCorrect == false &&
        widget.option!.isChoosen == true) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }
}
