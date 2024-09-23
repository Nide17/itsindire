import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_views.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_direction_button.dart';

class IsuzumaAttempt extends StatefulWidget {
  final IsuzumaModel isuzuma;
  final IsuzumaModel? nextIsuzuma;
  const IsuzumaAttempt({
    super.key,
    required this.isuzuma,
    this.nextIsuzuma,
  });

  @override
  State<IsuzumaAttempt> createState() => _IsuzumaAttemptState();
}

class _IsuzumaAttemptState extends State<IsuzumaAttempt> {
  int qnIndex = 1;

  @override
  Widget build(BuildContext context) {
    final usr = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        // CHANGE NOTIFIER PROVIDER FOR ISUZUMA SCORE
        ChangeNotifierProvider(
          create: (context) {
            List<ScoreQuestionI> scoreQns = [];

            // LOOP THROUGH THE QUESTIONS TO MAKE A NEW LIST OF QUESTIONS FOR THE SCORE
            for (var qn in widget.isuzuma.questions) {
              List<ScoreOptionI> scoreOptions = qn.options
                  .map((e) => ScoreOptionI(
                        id: e.id,
                        text: e.text,
                        imageUrl: e.imageUrl,
                        explanation: e.explanation,
                        isCorrect: e.isCorrect,
                        isChoosen: false,
                      ))
                  .toList();

              // Create ScoreQuestionI object
              ScoreQuestionI scoreQuestion = ScoreQuestionI(
                id: qn.id,
                isomoID: qn.isomoID,
                ingingoID: qn.ingingoID,
                title: qn.title,
                imageUrl: qn.imageUrl,
                options: scoreOptions,
                isAnswered: false,
              );

              scoreQns.add(scoreQuestion);
            }

            // RETURN NEW ISUZUMA SCORE MODEL FOR ATTMEPTING
            return IsuzumaScoreModel(
              id: '',
              takerID: usr!.uid,
              isuzumaID: widget.isuzuma.id,
              dateTaken: DateTime.now(),
              marks: 0,
              totalMarks: widget.isuzuma.questions.length,
              questions: scoreQns,
              amasomo: widget.isuzuma.questions.map((e) => e.isomoID).toList(),
              isuzumaTitle: widget.isuzuma.title,
            );
          },
        ),
      ],
      child: Consumer<IsuzumaScoreModel>(
        builder: (context, scorePrModel, child) {
          int qnsLength = scorePrModel.questions.length;

          // UNANSWERED QUESTIONS
          List<ScoreQuestionI> unansweredQns = scorePrModel.questions
              .where((element) => !element.isAnswered)
              .toList();

          // CALLBACK FOR FORWARD BUTTON
          void forward() {
            setState(() => qnIndex = qnIndex + 1);
          }

          // CALLBACK FOR BACKWARD BUTTON
          void backward() {
            if (qnIndex <= 1) {
            } else {
              setState(() => qnIndex = qnIndex - 1);
            }
          }

          // RETURN THE WIDGETS
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              _showTheDialog(
                context,
                'Ugiye gusohoka udasoje?',
                'Ushaka gusohoka udasoje kwisuzuma? Ibyo wahisemo birasibama.',
                'OYA',
                const Color(0xFF00A651),
                'YEGO',
                () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                const Color(0xFFE60000),
              );
            },
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(58.0),
                child: AppBarItsindire(),
              ),
              body: IsuzumaViews(
                  userID: usr!.uid,
                  qnIndex: qnIndex,
                  showQn: showQn,
                  isuzuma: widget.isuzuma,
                  scorePrModel: scorePrModel),
              bottomNavigationBar: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 216, 215, 215),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 83, 65, 240)
                                .withOpacity((qnsLength != qnIndex) ? 0.7 : 1),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                            spreadRadius: -8,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // IF THERE ARE UNANSWERED QUESTIONS
                          if (unansweredQns.isNotEmpty) {
                            _showTheDialog(
                              context,
                              'Hari ibidasubije!',
                              'Hari ibibazo utasubije. Ushaka gusoza?',
                              'OYA',
                              const Color(0xFF00A651),
                              'SOZA',
                              () {
                                for (var qn in scorePrModel.questions) {
                                  if (!qn.isAnswered) {
                                    qn.isAnswered = true;
                                  }
                                }

                                // SAVE THE SCORE
                                IsuzumaScoreService()
                                    .createOrUpdateIsuzumaScore(scorePrModel);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IsuzumaScoreReview(
                                      isuzuma: widget.isuzuma,
                                    ),
                                  ),
                                );
                              },
                              const Color(0xFFE60000),
                            );
                          } else {
                            _showTheDialog(
                              context,
                              'Gusoza isuzuma!',
                              'Wasubije ibibazo byose. Ese ushaka gusoza nonaha?',
                              'OYA',
                              const Color(0xFFE60000),
                              'YEGO',
                              () {
                                IsuzumaScoreService()
                                    .createOrUpdateIsuzumaScore(scorePrModel);
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IsuzumaScoreReview(
                                      isuzuma: widget.isuzuma,
                                    ),
                                  ),
                                );
                              },
                              const Color(0xFF00A651),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white
                              .withOpacity(unansweredQns.isNotEmpty ? 0.65 : 1),
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0)
                              .withOpacity(unansweredQns.isNotEmpty ? 0.6 : 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/tick.svg',
                              width: MediaQuery.of(context).size.width * 0.03,
                              colorFilter: ColorFilter.mode(
                                const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(
                                        unansweredQns.isNotEmpty ? 0.5 : 1),
                                BlendMode.srcATop,
                              ),
                            ),
                            Text(
                              ' Soza isuzuma',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(
                                        unansweredQns.isNotEmpty ? 0.65 : 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IsuzumaDirectionButton(
                          direction: 'inyuma',
                          backward: backward,
                          qnsLength: qnsLength,
                          currQnID: qnIndex,
                        ),

                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),

                        // 3. KOMEZA BUTTON
                        IsuzumaDirectionButton(
                          direction: 'komeza',
                          forward: forward,
                          qnsLength: qnsLength,
                          currQnID: qnIndex,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showQn(int index) {
    setState(() => qnIndex = index);
  }

  Future<void> _showTheDialog(
      BuildContext context,
      String errorTitle,
      String errorMsg,
      String? firstButtonTitle,
      Color? firstButtonColor,
      String? secondButtonTitle,
      Function? secondButtonFunction,
      Color? secondButtonColor) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ItsindireAlert(
          errorTitle: errorTitle,
          errorMsg: errorMsg,
          firstButtonTitle: firstButtonTitle,
          firstButtonFunction: () {
            Navigator.of(context).pop();
          },
          firstButtonColor: const Color(0xFF00A651),
          secondButtonTitle: secondButtonTitle,
          secondButtonFunction: secondButtonFunction,
          secondButtonColor: secondButtonColor,
        );
      },
    );
  }
}
