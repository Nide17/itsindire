import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isuzuma_score_db.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/screens/iga/amasuzuma/amasuzuma.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_attempt.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_custom_radio_button.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_direction_button.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_ikibazo_button.dart';
import 'package:tegura/screens/iga/amasuzuma/review_action_buttons.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';

class IsuzumaScoreReview extends StatefulWidget {
  // INSTANCE VARIABLES
  final String scoreId;
  final IsuzumaModel isuzuma;
  const IsuzumaScoreReview(
      {super.key, required this.scoreId, required this.isuzuma});

  @override
  State<IsuzumaScoreReview> createState() => _IsuzumaScoreReviewState();
}

class _IsuzumaScoreReviewState extends State<IsuzumaScoreReview> {
  int qnIndex = -1;

  @override
  Widget build(BuildContext context) {
    // RETURN THE SCORE PROVIDER CONSUMER
    return MultiProvider(
      providers: [
        // PROVIDE FIREBASE FIRESTORE INSTANCE - DB REFERENCE TO PROFILES COLLECTION
        StreamProvider<IsuzumaScoreModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: IsuzumaScoreService().getScoreByID(widget.scoreId),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in isuzuma score: $error");
              print(
                  "The err: ${IsuzumaScoreService().getScoreByID(widget.scoreId)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child:
          Consumer<IsuzumaScoreModel?>(builder: (context, scorePrModel, child) {
        if (scorePrModel == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<ScoreQuestionI> scoreQns = scorePrModel.questions;

          int scoreQnsLength = scoreQns.length;
          ScoreQuestionI? currentQn =
              qnIndex > -1 ? scoreQns[qnIndex - 1] : null;

          String outcome = scorePrModel.marks / scorePrModel.totalMarks < 0.6
              ? 'Watsinzwe!'
              : 'Watsinze!';
          String amanota =
              'Wagize ${scorePrModel.marks}/${scorePrModel.totalMarks}';

          final List<Map<String, dynamic>> buttonsList = [
            {
              'icon': 'assets/images/backward.svg',
              'text': 'Subira ku masuzuma',
              'bgColor': 0xFF0079C1,
              'color': 0xFFFFFFFF,
              'screen': const Amasuzumabumenyi(),
            },
            {
              'icon': 'assets/images/test.svg',
              'text': 'Reba uko wasubije',
              'bgColor': 0xFFFFBD59,
              'color': 0xFF000000,
              'action': 'question1',
            },
            {
              'icon': 'assets/images/forward.svg',
              'text': 'Kora irindi suzuma',
              'bgColor': 0xFF00A651,
              'color': 0xFFFFFFFF,
              'screen': IsuzumaAttempt(
                isuzuma: widget.isuzuma,
                scoreUserIsuzuma: null,
              ),
            },
          ];
          // RETURN THE CONTENT
          return Scaffold(
            // APP BAR
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: AppBarTegura(),
            ),

            body: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Column(children: [
                GradientTitle(
                    title: widget.isuzuma.title,
                    icon: 'assets/images/amasuzumabumenyi.svg',
                    marginTop: 8.0,
                    parentWidget: 'isuzume'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    // IKIBAZO NUMBER BUTTONS
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.008,
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
                                      (index + 1) == qnIndex ? true : false,
                                  showQn: showQn,
                                  qnIndex: (index + 1),
                                  isReviewing: true,
                                ),
                              ))),
                    ),

                    // CONTENT AND RADIO BUTTONS
                    // ######################## CONTENT TITLE #######################
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              currentQn == null ? '' : currentQn.title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.04,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),

                            // DISPLAY NETWORK IMAGE IF ANY
                            currentQn == null || currentQn.imageUrl == null || currentQn.imageUrl == ''
                                ? const SizedBox.shrink()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      margin: const EdgeInsets.only(top: 10.0),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        border: Border.fromBorderSide(
                                          BorderSide(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            width: 1,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            offset: Offset(0, 1),
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Image.network(
                                        currentQn.imageUrl!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                      ),
                                    ),
                                  ),

                            // ######################## CONTENT #######################
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02), 
                            Column(
                              children: currentQn?.options
                                      .map<Widget>((option) {
                                    return IsuzumaCustomRadioButton(
                                      // VARIABLES PROPERTIES
                                      option: option,
                                      curQnIndex: qnIndex,
                                      isReviewing: true,
                                    );
                                  }).toList() ??
                                  [], // Use an empty list if currentQn is null
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ############## QUESTIONS OPTIONS ##############
                    // SHOW THE QUESTION AND OPTIONS
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        // vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          qnIndex == -1
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                  ),
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDE59),
                                    borderRadius: BorderRadius.circular(24.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 59, 57, 77),
                                        offset: Offset(0, 3),
                                        blurRadius: 8,
                                        spreadRadius: -7,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        outcome,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.w900,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        amanota,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.w900,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),

                          // KOMEZA INYUMA BUTTONS
                          qnIndex != -1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IsuzumaDirectionButton(
                                      direction: 'inyuma',
                                      backward: backward,
                                      qnsLength: scoreQnsLength,
                                      currQnID: qnIndex,
                                    ),

                                    // 3. KOMEZA BUTTON
                                    IsuzumaDirectionButton(
                                      direction: 'komeza',
                                      forward: forward,
                                      qnsLength: scoreQnsLength,
                                      currQnID: qnIndex,
                                    ),
                                  ],
                                )
                              : Container(),

                          // ######### BUTTON for buttonsList.asMap() ########
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.024,
                            ),
                            child: Center(
                              child: Wrap(
                                spacing: 10.0,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                children:
                                    List.generate(buttonsList.length, (index) {
                                  if (qnIndex != -1 && index == 1) {
                                    return Container();
                                  } else {
                                    return ReviewActionButtons(
                                        // VARIABLES PROPERTIES
                                        icon: buttonsList[index]['icon'],
                                        text: buttonsList[index]['text'],
                                        bgColor: buttonsList[index]['bgColor'],
                                        color: buttonsList[index]['color'],
                                        screen: buttonsList[index]['screen'],
                                        action: buttonsList[index]['action'],
                                        showQn: showQn);
                                  }
                                }),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                )),
              ]),
            ),
          );
        }
      }),
    );
  }

  void showQn(int index) {
    setState(() {
      qnIndex = index;
    });
  }

  // CALLBACK FOR FORWARD BUTTON
  void forward() {
    if (qnIndex >= widget.isuzuma.questions.length) {
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
}
