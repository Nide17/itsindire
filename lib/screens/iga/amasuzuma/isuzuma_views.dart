import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_custom_radio_button.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_ikibazo_button.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_timer.dart';
import 'package:itsindire/screens/iga/amasuzuma/qn_img_url.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';

typedef ShowQnCallback = void Function(int index);

class IsuzumaViews extends StatefulWidget {
  final String userID;
  final int qnIndex;
  final ShowQnCallback showQn;
  final IsuzumaModel isuzuma;
  final IsuzumaScoreModel? scorePrModel;

  const IsuzumaViews({
    super.key,
    required this.userID,
    required this.qnIndex,
    required this.showQn,
    required this.isuzuma,
    this.scorePrModel,
  });

  @override
  State<IsuzumaViews> createState() => _IsuzumaViewsState();
}

class _IsuzumaViewsState extends State<IsuzumaViews> {
  void handleTimerExpired() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItsindireAlert(
          errorTitle: 'Iminota yarangiye!',
          errorMsg: 'Igihe cyashize, reba uko wakoze cyangwa usubiremo!',
          firstButtonTitle: 'Funga',
          firstButtonFunction: () {
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
                  builder: (context) =>
                      IsuzumaScoreReview(isuzuma: widget.isuzuma),
                ));
          },
          alertType: 'error',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IsuzumaScoreModel>(builder: (context, scorePrModel, child) {
      List<ScoreQuestionI> scoreQns = scorePrModel.questions;
      int scoreQnsLength = scoreQns.length;
      ScoreQuestionI currentQn = scoreQns[widget.qnIndex - 1];

      return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientTitle(
                  title: scorePrModel.isuzumaTitle ?? '',
                  icon: 'assets/images/amasuzumabumenyi.svg',
                  marginTop: MediaQuery.of(context).size.height * 0.02,
                  parentWidget: 'isuzume'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              IsuzumaTimer(
                duration: 1200, // Duration in seconds - 20 minutes
                // duration: 12, // Duration in seconds
                onTimerExpired: handleTimerExpired,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: Wrap(
                          spacing: MediaQuery.of(context).size.width * 0.014,
                          direction: Axis.horizontal,
                          children: List.generate(
                            scoreQnsLength,
                            (index) => IsuzumaIkibazoButton(
                                isActive: (index + 1) == widget.qnIndex
                                    ? true
                                    : false,
                                showQn: widget.showQn,
                                qnIndex: (index + 1),
                                isReviewing: false),
                          ))),

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

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.000,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentQn.title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),

                            // DISPLAY NETWORK IMAGE IF ANY
                            currentQn.imageUrl == null
                                ? const SizedBox.shrink()
                                : QuestionImgUrl(
                                    currentQn: currentQn,
                                  ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: currentQn.options.map<Widget>((option) {
                                return IsuzumaCustomRadioButton(
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
