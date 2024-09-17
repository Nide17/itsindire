import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/isuzuma_db.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:itsindire/screens/iga/amasuzuma/amasuzuma.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_custom_radio_button.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_direction_button.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_ikibazo_button.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_overview.dart';
import 'package:itsindire/screens/iga/amasuzuma/qn_img_url.dart';
import 'package:itsindire/screens/iga/amasuzuma/review_action_buttons.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class IsuzumaScoreReview extends StatefulWidget {
  final IsuzumaModel isuzuma;

  const IsuzumaScoreReview({super.key, required this.isuzuma});

  @override
  State<IsuzumaScoreReview> createState() => _IsuzumaScoreReviewState();
}

class _IsuzumaScoreReviewState extends State<IsuzumaScoreReview> {
  int qnIndex = -1;

  @override
  Widget build(BuildContext context) {
    String nextIsuzumaTitle =
        '${widget.isuzuma.title.split(' ')[0]} ${widget.isuzuma.title.split(' ')[1]} ${int.parse(widget.isuzuma.title.split(' ')[2]) + 1}';
    final usr = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        StreamProvider<IsuzumaScoreModel?>.value(
          value: IsuzumaScoreService()
              .getScoreByID('${usr!.uid}_${widget.isuzuma.id}'),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
        StreamProvider<IsuzumaModel?>.value(
          value: IsuzumaService().getIsuzumaByTitle(nextIsuzumaTitle),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child:
          Consumer<IsuzumaScoreModel?>(builder: (context, scorePrModel, child) {
        return Consumer<IsuzumaModel?>(builder: (context, nextIsuzuma, child) {
          final List<Map<String, dynamic>> buttonsList = [
            {
              'icon': 'assets/images/backward.svg',
              'text': 'Subira ku masuzuma',
              'bgColor': 0xFF5B8BDF,
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
              'screen': nextIsuzuma == null
                  ? const ItsindireAlert(
                      errorTitle: 'Amasuzuma yarangiye!',
                      errorMsg: 'Nta suzuma rindi ryabashije kuboneka!',
                      alertType: 'warning')
                  : IsuzumaOverview(
                      isuzuma: nextIsuzuma,
                    ),
            },
          ];

          if (scorePrModel == null) {
            return const LoadingWidget();
          } else {
            List<ScoreQuestionI> scoreQns = scorePrModel.questions;

            int scoreQnsLength = scoreQns.length;
            ScoreQuestionI? currentQn =
                qnIndex > -1 ? scoreQns[qnIndex - 1] : null;

            String outcome = scorePrModel.marks / scorePrModel.totalMarks < 0.6
                ? 'Watsinzwe 😢!'
                : 'Watsinze 🙂!';
            String amanota =
                'Wagize ${scorePrModel.marks}/${scorePrModel.totalMarks}';

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(58.0),
                child: AppBarItsindire(),
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
                            child: Wrap(
                                spacing:
                                    MediaQuery.of(context).size.width * 0.014,
                                direction: Axis.horizontal,
                                children: List.generate(
                                  scoreQnsLength,
                                  (index) => IsuzumaIkibazoButton(
                                    isActive:
                                        (index + 1) == qnIndex ? true : false,
                                    showQn: showQn,
                                    qnIndex: (index + 1),
                                    isReviewing: true,
                                  ),
                                ))),
                      ),

                      // horizontal line
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.00,
                        ),
                        child: const Divider(
                          color: Color.fromARGB(255, 0, 0, 0),
                          thickness: 2,
                        ),
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),

                              // DISPLAY NETWORK IMAGE IF ANY
                              currentQn == null ||
                                      currentQn.imageUrl == null ||
                                      currentQn.imageUrl == ''
                                  ? const SizedBox.shrink()
                                  : QuestionImgUrl(
                                      currentQn: currentQn,
                                    ),

                              // ######################## CONTENT #######################
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
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
                                      color: const Color(0xFF5B8BDF),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.06),
                                      border: Border.all(
                                        color: const Color(0xFFFFBD59),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.008,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(255, 59, 57, 77),
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
                                                255, 255, 255, 255),
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
                                                255, 255, 255, 255),
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
                                  spacing:
                                      MediaQuery.of(context).size.width * 0.014,
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(buttonsList.length,
                                      (index) {
                                    if (qnIndex != -1 && index == 1) {
                                      return Container();
                                    } else {
                                      return ReviewActionButtons(
                                          icon: buttonsList[index]['icon'],
                                          text: buttonsList[index]['text'],
                                          bgColor: buttonsList[index]
                                              ['bgColor'],
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
        });
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
      const ItsindireAlert(
        errorTitle: 'Last Question',
        errorMsg: 'This is the last question',
        alertType: 'warning',
      );
    } else {
      setState(() {
        qnIndex = qnIndex + 1;
      });
    }
  }

  // CALLBACK FOR BACKWARD BUTTON
  void backward() {
    if (qnIndex <= 1) {
    } else {
      setState(() {
        qnIndex = qnIndex - 1;
      });
    }
  }
}
