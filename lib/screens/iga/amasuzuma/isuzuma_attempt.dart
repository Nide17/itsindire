import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isuzuma_score_db.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_views.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_direction_button.dart';

class IsuzumaAttempt extends StatefulWidget {
  // INSTANCE VARIABLES
  final IsuzumaModel isuzuma;
  final IsuzumaScoreModel? scoreUserIsuzuma;
  const IsuzumaAttempt({
    Key? key,
    required this.isuzuma,
    required this.scoreUserIsuzuma,
  }) : super(key: key);

  @override
  State<IsuzumaAttempt> createState() => _IsuzumaAttemptState();
}

class _IsuzumaAttemptState extends State<IsuzumaAttempt> {
  // STATE VARIABLES
  int qnIndex = 1;

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET THE USER
    final usr = Provider.of<UserModel?>(context);

    // RETURN THE CONTENT
    return MultiProvider(
      providers: [
        // CHANGE NOTIFIER PROVIDER FOR ISUZUMA SCORE
        ChangeNotifierProvider(
          create: (context) {
            // ADD isAnswered PROPERTY TO EACH QUESTIONS OF widget.isuzuma!.questionswidget.isuzuma!.questions
            List<ScoreQuestionI> scoreQns = [];

            // LOOP THROUGH THE QUESTIONS TO MAKE A NEW LIST OF QUESTIONS FOR THE SCORE
            for (var qn in widget.isuzuma.questions) {
              // Create ScoreOptionI objects from IsuzumaOption objects
              List<ScoreOptionI> scoreOptions = qn.options
                  .map((e) => ScoreOptionI(
                        id: e.id,
                        text: e.text,
                        imageUrl: e.imageUrl,
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

              // Add the ScoreQuestionI object to the list
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
          // LENGTH OF THE QUESTIONS
          int qnsLength = scorePrModel.questions.length;
          ScoreQuestionI currentQn = scorePrModel.questions[qnIndex - 1];
          String scoreID = '${scorePrModel.takerID}_${scorePrModel.isuzumaID}';

          // CALLBACK FOR FORWARD BUTTON
          void forward() {
            if (qnIndex >= qnsLength) {
              // ALERT DIALOG FOR LAST QUESTION
              AlertDialog(
                title: const Text('Last Question'),
                content: const Text('This is the last question'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            } else {
              setState(() {
                // GO TO NEXT QUESTION
                qnIndex = qnIndex + 1;
              });
            }
          }

          // CALLBACK FOR BACKWARD BUTTON
          void backward() {
            if (qnIndex <= 1) {
            } else {
              setState(() {
                // GO TO PREVIOUS QUESTION
                qnIndex = qnIndex - 1;
              });
            }
          }

          // RETURN THE WIDGETS
          return WillPopScope(
            // ON WILL POP
            onWillPop: () async {
              // SHOW DIALOG
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Ugiye gusohoka udasoje?'),
                    content: const Text(
                        'Ushaka gusohoka udasoje kwisuzuma? Ibyo wahisemo birasibama.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OYA'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // REMOVE THE CURRENT SCREEN FROM THE STACK
                          Navigator.pop(context);
                        },
                        child: const Text('YEGO'),
                      ),
                    ],
                  );
                },
              );

              // RETURN FALSE
              return false;
            },

            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),

              // APP BAR
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(58.0),
                child: AppBarTegura(),
              ),

              // PAGE BODY
              body: IsuzumaViews(
                userID: usr!.uid,
                qnIndex: qnIndex,
                showQn: showQn,
                isuzuma: widget.isuzuma,
                scorePrModel: scorePrModel,
                scoreID: scoreID,
              ),

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
                          // FIND UNANSWERED QUESTIONS
                          List<ScoreQuestionI> unansweredQns = scorePrModel
                              .questions
                              .where((element) => !element.isAnswered)
                              .toList();

                          // IF THERE ARE UNANSWERED QUESTIONS
                          if (unansweredQns.isNotEmpty) {
                            // ALERT DIALOG FOR UNANSWERED QUESTIONS
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Unanswered Questions'),
                                  content: const Text(
                                      'You have unanswered questions. Do you want to submit?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // SET THE UNANSWERED QUESTIONS TO ANSWERED IN THE OBJECT TO SAVE (scorePrModel)
                                        for (var qn in scorePrModel.questions) {
                                          if (!qn.isAnswered) {
                                            qn.isAnswered = true;
                                          }
                                        }

                                        // SAVE THE SCORE
                                        IsuzumaScoreService()
                                            .createOrUpdateIsuzumaScore(
                                                scorePrModel);
                                        // GO TO THE SCORE PAGE
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                IsuzumaScoreReview(
                                                    scoreId: scoreID,
                                                    isuzuma: widget.isuzuma),
                                          ),
                                        );
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // SAVE THE SCORE IF ON LAST QUESTION AND ANSWERED
                            if (qnIndex == qnsLength && currentQn.isAnswered) {
                              // SAVE THE SCORE
                              IsuzumaScoreService()
                                  .createOrUpdateIsuzumaScore(scorePrModel);

                              // REMOVE THE CURRENT SCREEN FROM THE STACK
                              Navigator.pop(context);

                              // GO TO THE SCORE PAGE
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IsuzumaScoreReview(
                                      scoreId: scoreID,
                                      isuzuma: widget.isuzuma),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white
                              .withOpacity((qnsLength != qnIndex) ? 0.7 : 1),
                          backgroundColor: const Color(0xFF1B56CB)
                              .withOpacity((qnsLength != qnIndex) ? 0.6 : 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/tick.svg',
                              width: 14,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(
                                    (qnsLength != qnIndex) ? 0.5 : 1),
                                BlendMode.srcATop,
                              ),
                            ),
                            const Text(
                              ' Soza isuzuma',
                              style: TextStyle(fontSize: 14),
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
    setState(() {
      qnIndex = index;
    });
  }
}
