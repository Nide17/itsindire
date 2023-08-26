import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isuzuma_score_db.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_custom_radio_button.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_ikibazo_button.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_timer.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';

typedef ShowQnCallback = void Function(int index);

class IsuzumaViews extends StatefulWidget {
  // INSTANCE VARIABLES
  final String userID;
  final int qnIndex;
  final ShowQnCallback showQn;
  final IsuzumaModel isuzuma;
  final IsuzumaScoreModel? scorePrModel;
  final String? scoreID;

  const IsuzumaViews({
    super.key,
    required this.userID,
    required this.qnIndex,
    required this.showQn,
    required this.isuzuma,
    this.scorePrModel,
    this.scoreID,
  });

  @override
  State<IsuzumaViews> createState() => _IsuzumaViewsState();
}

class _IsuzumaViewsState extends State<IsuzumaViews> {
  void handleTimerExpired() {
    // ALERT THE USER
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Iminota yarangiye!'),
          content: const Text(
              'Igihe cyashize, wareba uko wakoze cyangwa ugasubiramo!'),
          actions: [
            TextButton(
              onPressed: () {
                // FIND UNANSWERED QUESTIONS
                for (var qn in widget.scorePrModel!.questions) {
                  if (!qn.isAnswered) {
                    qn.isAnswered = true;
                  }
                }

                // SAVE THE SCORE
                IsuzumaScoreService()
                    .createOrUpdateIsuzumaScore(widget.scorePrModel!);

                // GO TO THE REVIEW PAGE
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IsuzumaScoreReview(
                          scoreId: widget.scoreID!, isuzuma: widget.isuzuma),
                    ));
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // RETURN THE SCORE PROVIDER CONSUMER
    return Consumer<IsuzumaScoreModel>(builder: (context, scorePrModel, child) {
      List<ScoreQuestionI> scoreQns = scorePrModel.questions;
      int scoreQnsLength = scoreQns.length;
      ScoreQuestionI currentQn = scoreQns[widget.qnIndex - 1];

      // RETURN THE CONTENT
      return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
        ),
        child: Column(children: [
          GradientTitle(
              title: scorePrModel.isuzumaTitle ?? '',
              icon: 'assets/images/amasuzumabumenyi.svg',
              marginTop: 8.0,
              parentWidget: 'isuzume'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          IsuzumaTimer(
            duration: 1200, // Duration in seconds - 20 minutes
            // duration: 12, // Duration in seconds
            onTimerExpired: handleTimerExpired,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              child: Column(
            children: [
              // IKIBAZO NUMBER BUTTONS
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.008,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFF00A651),
                          width: 2.0,
                        ),
                        bottom: BorderSide(
                          color: Color(0xFF00A651),
                          width: 4.0,
                        ),
                        left: BorderSide(
                          color: Color(0xFF00A651),
                          width: 2.0,
                        ),
                        right: BorderSide(
                          color: Color(0xFF00A651),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Wrap(
                        spacing: 10.0,
                        direction: Axis.horizontal,
                        children: List.generate(
                          scoreQnsLength,
                          (index) => IsuzumaIkibazoButton(
                              // MAKE THE FIRST QUESTION ACTIVE BY DEFAULT ON PAGE LOAD
                              isActive:
                                  (index + 1) == widget.qnIndex ? true : false,
                              showQn: widget.showQn,
                              qnIndex: (index + 1),
                              isReviewing: false),
                        ))),
              ),

              // SHOW THE QUESTION AND OPTIONS
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          currentQn.title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),

                        // DISPLAY NETWORK IMAGE IF ANY
                        currentQn.image == null
                            ? const SizedBox.shrink()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.13,
                                child: Image.network(
                                  currentQn.image!,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.001,
                                ),
                              ),

                        const SizedBox(height: 10.0),
                        Column(
                          children: currentQn.options.map<Widget>((option) {
                            return IsuzumaCustomRadioButton(
                                // VARIABLES PROPERTIES
                                option: option,
                                curQnIndex: widget.qnIndex,
                                isReviewing: false);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ]),
      );
    });
  }
}
