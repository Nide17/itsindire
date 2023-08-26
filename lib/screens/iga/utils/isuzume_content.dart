import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/utils/isuzume_details.dart';
import 'package:tegura/screens/iga/utils/isuzume_results.dart';
import 'package:tegura/screens/iga/utils/quiz_score_provider.dart';
import 'package:tegura/services/pop_question_db.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/direction_button_isuzume.dart';

class IsuzumeContent extends StatefulWidget {
  // INSTANCE VARIABLES
  final IsomoModel isomo;
  final CourseProgressModel? courseProgress;
  const IsuzumeContent({super.key, required this.isomo, this.courseProgress});

  @override
  State<IsuzumeContent> createState() => _IsuzumeContentState();
}

class _IsuzumeContentState extends State<IsuzumeContent> {
  // STATE VARIABLES
  int qnIndex = 0;
  bool isCurrentCorrect = false;
  int selectedOption = -1;

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET THE USER
    final usr = Provider.of<UserModel?>(context);

    // RETURN THE CONTENT
    return MultiProvider(
      providers: [
        // CHANGE NOTIFIER PROVIDER FOR QUIZ SCORE
        ChangeNotifierProvider(
          create: (context) => QuizScoreProvider(),
        ),
        // STREAM PROVIDER FOR POP QUESTIONS
        StreamProvider<List<PopQuestionModel>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: PopQuestionService().getPopQuestionsByIsomoID(
              widget.isomo.id), // GET THE POP QUESTIONS
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error iga content pq: $error");
              print(
                  "The err: ${PopQuestionService().getPopQuestionsByIsomoID(widget.isomo.id)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child: Consumer<QuizScoreProvider>(
        builder: (context, scoreProviderModel, child) {
          // print('isAnswered: ${scoreProviderModel.quizScore.questions}');
          return Consumer<List<PopQuestionModel>?>(
            builder: (context, popQuestions, _) {
              if (popQuestions == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // SET Total Marks, Marks, User ID, Isomo ID
              scoreProviderModel.quizScore.setUserID(usr!.uid);
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
              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),

                // APP BAR
                appBar: PreferredSize(
                  preferredSize: MediaQuery.of(context).size * 0.07,
                  child: const AppBarTegura(),
                ),

                // PAGE BODY
                body: IsuzumeDetails(
                  isomo: widget.isomo,
                  userID: usr.uid,
                  courseProgress: widget.courseProgress,
                  qnIndex: qnIndex,
                  selectedOption: selectedOption,
                  isCurrentCorrect: isCurrentCorrect,
                  setSelectedOption: setSelectedOption,
                  showQn: showQn,
                ),

                bottomNavigationBar: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 72, 255, 0),
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
                          Navigator.push(
                            // GO TO THE RESULTS PAGE
                            context,
                            MaterialPageRoute(
                              builder: (context) => IsuzumeResults(
                                  scoreProviderModel: scoreProviderModel),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Soza isuzuma',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      // 2. INYUMA BUTTON
                      Row(
                        children: [
                          DirectionButtonIsuzume(
                            buttonText: 'inyuma',
                            direction: 'inyuma',
                            opacity: 1,
                            backward: backward,
                            popQuestions: popQuestions,
                            currQnID: qnIndex,
                            isDisabled: qnIndex < 1,
                            scoreObject: scoreProviderModel,
                          ),

                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),

                          // 3. KOMEZA BUTTON
                          DirectionButtonIsuzume(
                            buttonText: 'komeza',
                            direction: 'komeza',
                            opacity: 1,
                            forward: forward,
                            popQuestions: popQuestions,
                            currQnID: qnIndex,
                            isDisabled: qnIndex >= popQuestions.length - 1,
                            scoreObject: scoreProviderModel,
                          ),
                        ],
                      ),
                    ],
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
    // print('The value i up: $index');
    setState(() {
      qnIndex = index;
      selectedOption = -1;
      isCurrentCorrect = false;
    });
  }

// SET THE SELECTED OPTION AND THE CORRECTNESS OF THE ANSWER
  void setSelectedOption(Map<String, dynamic>? option) {
    if (option == null) {
      setState(() {
        selectedOption = -1;
        isCurrentCorrect = false;
      });
      return;
    }
    setState(() {
      selectedOption = option['id'];
      isCurrentCorrect = option['isCorrect'];
    });
  }
}
