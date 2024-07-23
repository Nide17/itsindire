import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/utils/isuzume_details.dart';
import 'package:itsindire/providers/quiz_score_provider.dart';
import 'package:itsindire/firebase_services/pop_question_db.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/direction_button_isuzume.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class IsuzumeContent extends StatefulWidget {
  final IsomoModel isomo;
  final CourseProgressModel? courseProgress;
  const IsuzumeContent({super.key, required this.isomo, this.courseProgress});

  @override
  State<IsuzumeContent> createState() => _IsuzumeContentState();
}

class _IsuzumeContentState extends State<IsuzumeContent> {
  int qnIndex = 0;
  bool isCurrentCorrect = false;
  int selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuizScoreProvider(),
        ),
        StreamProvider<List<PopQuestionModel>?>.value(
          value: PopQuestionService().getPopQuestionsByIsomoID(widget.isomo.id),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<QuizScoreProvider>(
        builder: (context, scoreProviderModel, child) {
          return Consumer<List<PopQuestionModel>?>(
            builder: (context, popQuestions, _) {
              if (popQuestions == null) {
                return const LoadingWidget();
              }

              FirebaseAuth.instance.currentUser != null
                  ? scoreProviderModel.quizScore
                      .setUserID(FirebaseAuth.instance.currentUser!.uid)
                  : null;
              scoreProviderModel.quizScore.setIsomoID(widget.isomo.id);

              // CREATE THE QUESTIONS IN QUIZ SCORE - IF THEY DON'T EXIST
              for (var popQuestion in popQuestions) {
                // Check if the question already exists in quizScore
                bool questionExists = scoreProviderModel.quizScore.questions
                    .any((scoreQuestion) =>
                        scoreQuestion.getPopQuestion().id == popQuestion.id);

                // Add the question to quizScore if it doesn't exist
                if (!questionExists) {
                  scoreProviderModel.quizScore.addQuestion(
                    ScoreQuestion(
                      isAnswered: false,
                      isAnswerCorrect: null,
                      popQuestion: popQuestion,
                    ),
                  );
                }
              }

              // CALLBACK FOR FORWARD BUTTON
              void forward() {
                if (qnIndex >=
                    scoreProviderModel.quizScore.questions.length - 1) {
                  const ItsindireAlert(
                    errorTitle: 'Ikibazo cyanyuma!',
                    errorMsg: 'Ibibazo byose byasubije!',
                    alertType: 'warning',
                  );
                } else {
                  setState(() {
                    qnIndex = qnIndex + 1;

                    // RESET THE SELECTED OPTION
                    selectedOption = -1;

                    // RESET THE CORRECTNESS OF THE ANSWER
                    isCurrentCorrect = false;
                  });
                }
              }

              // CALLBACK FOR BACKWARD BUTTON
              void backward() {
                if (qnIndex < 1) {
                } else {
                  setState(() {
                    qnIndex = qnIndex - 1;

                    // RESET THE SELECTED OPTION
                    selectedOption = -1;

                    // RESET THE CORRECTNESS OF THE ANSWER
                    isCurrentCorrect = false;
                  });
                }
              }

              // RETURN THE WIDGETS
              return WillPopScope(
                onWillPop: () async {
                  if (!scoreProviderModel.quizScore.isAllAnswered() ||
                      isCurrentCorrect == false) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ItsindireAlert(
                          errorTitle: 'Subiza byose',
                          errorMsg: 'Ushaka gusohoka udasubije ibibazo byose?',
                          firstButtonTitle: 'OYA',
                          firstButtonFunction: () {
                            Navigator.of(context).pop();
                          },
                          firstButtonColor: const Color(0xFF00A651),
                          secondButtonTitle: 'YEGO',
                          secondButtonFunction: () {
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                          },
                          secondButtonColor: const Color(0xFFE60000),
                        );
                      },
                    );
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(58.0),
                    child: AppBarItsindire(),
                  ),
                  body: IsuzumeDetails(
                    isomo: widget.isomo,
                    userID: FirebaseAuth.instance.currentUser!.uid,
                    courseProgress: widget.courseProgress,
                    qnIndex: qnIndex,
                    selectedOption: selectedOption,
                    isCurrentCorrect: isCurrentCorrect,
                    setSelectedOption: setSelectedOption,
                    showQn: showQn,
                  ),
                  bottomNavigationBar: popQuestions.isEmpty ||
                          scoreProviderModel.quizScore
                                  .getIsAtleastOneAnswered() ==
                              false
                      ? const SizedBox.shrink()
                      : Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.024),
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00A651),
                                offset: Offset(0, -1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // IF ALL QUESTIONS ARE NOT ANSWERED, ALERT THE USER TO CONFIRM
                                  if (!scoreProviderModel.quizScore
                                          .isAllAnswered() ||
                                      isCurrentCorrect == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ItsindireAlert(
                                          errorTitle: 'Subiza byose',
                                          errorMsg:
                                              'Ushaka gusohoka udasubije ibibazo byose?',
                                          firstButtonTitle: 'OYA',
                                          firstButtonFunction: () {
                                            Navigator.of(context).pop();
                                          },
                                          firstButtonColor:
                                              const Color(0xFF00A651),
                                          secondButtonTitle: 'YEGO',
                                          secondButtonFunction: () {
                                            Navigator.of(context).pop();
                                            Navigator.pop(context);
                                          },
                                          secondButtonColor:
                                              const Color(0xFFE60000),
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ItsindireAlert(
                                          errorTitle: 'Wasoje kwisuzuma!',
                                          errorMsg:
                                              'Wabonye ${popQuestions.length}/${popQuestions.length}',
                                          firstButtonTitle: 'Inyuma',
                                          firstButtonFunction: () {
                                            Navigator.of(context).pop();
                                            Navigator.pop(context);
                                          },
                                          firstButtonColor:
                                              const Color(0xFF00A651),
                                          alertType: 'success',
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Soza kwisuzuma',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                ),
                              ),
                              Row(
                                children: [
                                  DirectionButtonIsuzume(
                                    buttonText: 'inyuma',
                                    direction: 'inyuma',
                                    opacity: 1,
                                    backward: backward,
                                    lastQn: popQuestions.length - 1,
                                    currQnID: qnIndex,
                                    isDisabled: qnIndex < 1,
                                  ),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04),

                                  // 3. KOMEZA BUTTON
                                  DirectionButtonIsuzume(
                                    buttonText: 'komeza',
                                    direction: 'komeza',
                                    opacity: 1,
                                    forward: forward,
                                    lastQn: popQuestions.length - 1,
                                    currQnID: qnIndex,
                                    isDisabled:
                                        qnIndex >= popQuestions.length - 1 ||
                                            isCurrentCorrect == false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showQn(int index) {
    setState(() {
      qnIndex = index;
      selectedOption = -1;
      isCurrentCorrect = false;
    });
  }

// SET THE SELECTED OPTION AND THE CORRECTNESS OF THE ANSWER
  void setSelectedOption(OptionPopQn? option) {
    if (option == null) {
      setState(() {
        selectedOption = -1;
        isCurrentCorrect = false;
      });
      return;
    }
    setState(() {
      selectedOption = option.id;
      isCurrentCorrect = option.isCorrect;
    });
  }
}
