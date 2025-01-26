import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/ingingo_db.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/ingingo.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/screens/iga/utils/content_title_text.dart';
import 'package:itsindire/screens/iga/utils/iga_content.dart';
import 'package:itsindire/screens/iga/utils/option_content.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ContentDetails extends StatefulWidget {
  final IsomoModel isomo;
  final ScrollController controller;

  const ContentDetails(
      {super.key, required this.isomo, required this.controller});

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  int thisCourseTotalIngingos = 0;
  bool loadingTotalIngingos = true;
  late StreamSubscription<IsomoIngingoSum> _subscription;

  Future<void> getTotalIngingos() async {
    Stream<IsomoIngingoSum> totalIngingos =
        IngingoService().getTotalIsomoIngingos(widget.isomo.id);

    _subscription = totalIngingos.listen((event) {
      if (mounted) {
        setState(() {
          thisCourseTotalIngingos = event.totalIngingos;
          loadingTotalIngingos = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalIngingos();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadingTotalIngingos
        ? const LoadingWidget()
        : Consumer<List<IngingoModel>?>(builder: (context, currPageIngingos, _) {
            return Consumer<CourseProgressModel?>(builder: (context, courseProgress, _) {
              return Consumer<List<PopQuestionModel>?>(builder: (context, quizPopQuestions, _) {
                if (currPageIngingos == null) {
                  return const LoadingWidget();
                } else {
                  return ListView.builder(
                    controller: widget.controller,
                    itemCount: currPageIngingos.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return buildIngingoItem(context, currPageIngingos, index, courseProgress, quizPopQuestions);
                    },
                  );
                }
              });
            });
          });
  }

  Widget buildIngingoItem(BuildContext context, List<IngingoModel> currPageIngingos, int index, CourseProgressModel? courseProgress, List<PopQuestionModel>? quizPopQuestions) {
    final totalIngingos = courseProgress?.totalIngingos ?? 0;
    final currentIngingo = courseProgress?.currentIngingo ?? 0;
    final unansweredPopQuestions = courseProgress?.unansweredPopQuestions ?? 0;

    return Align(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.008,
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.022),
          child: Column(
            children: [
              if (index == 0) ...[
                if (currentIngingo == totalIngingos && unansweredPopQuestions == 0)
                  buildCompletionMessage(context),
                if (currentIngingo == totalIngingos && unansweredPopQuestions == 0)
                  buildRedoButton(context, courseProgress, quizPopQuestions),
                if (widget.isomo.introText != '')
                  buildIntroText(context),
              ],
              buildContent(context, currPageIngingos[index]),
              if (index == currPageIngingos.length - 1 && widget.isomo.conclusion != '')
                buildConclusion(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompletionMessage(BuildContext context) {
    return Text(
      'Wasoje kwiga isomo!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.height * 0.021,
        color: Colors.green,
      ),
    );
  }

  Widget buildRedoButton(BuildContext context, CourseProgressModel? courseProgress, List<PopQuestionModel>? quizPopQuestions) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.002),
      ),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ItsindireAlert(
              errorTitle: 'IBIJYANYE NIRI SOMO',
              errorMsg: 'Ugiye kwiga isomo ryitwa "${widget.isomo.title}" rigizwe n’ingingo "${thisCourseTotalIngingos}" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : thisCourseTotalIngingos * 4}" gusa!',
              firstButtonTitle: 'Inyuma',
              firstButtonFunction: () {
                Navigator.pop(context);
              },
              firstButtonColor: const Color(0xFFE60000),
              secondButtonTitle: 'Tangira',
              secondButtonFunction: () {
                if (courseProgress != null && quizPopQuestions != null) {
                  CourseProgressService().updateUserCourseProgress(
                    courseProgress.userId,
                    courseProgress.courseId,
                    0,
                    courseProgress.totalIngingos,
                    quizPopQuestions.length,
                  );
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IgaContent(
                      isomo: widget.isomo,
                      courseProgress: courseProgress,
                      thisCourseTotalIngingos: thisCourseTotalIngingos,
                    ),
                  ),
                );
              },
              secondButtonColor: const Color(0xFF00A651),
            );
          },
        );
      },
      child: Text(
        'Ongera utangire iri somo!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height * 0.012,
        ),
      ),
    );
  }

  Widget buildIntroText(BuildContext context) {
    return Text(
      '\n${widget.isomo.introText}\n',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.height * 0.022,
      ),
    );
  }

  Widget buildContent(BuildContext context, IngingoModel ingingo) {
    return Column(
      children: [
        ContentTitlenText(
          title: '${ingingo.title} ',
          text: '${ingingo.text}',
        ),
        if (ingingo.insideTitle != null && ingingo.insideTitle != '')
          Text(
            '\n${ingingo.insideTitle}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.021,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (ingingo.options != null && ingingo.options.isNotEmpty)
          Column(
            children: List.generate(
              ingingo.options.length,
              (optionIndex) {
                Option option = Option.fromJson(ingingo.options[optionIndex]);
                return OptionContent(option: option);
              },
            ).toList(),
          ),
        if (ingingo.nb != null && ingingo.nb != '')
          Text.rich(
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.021,
            ),
            TextSpan(
              children: [
                const TextSpan(
                  text: '\nNB: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${ingingo.nb}'),
              ],
            ),
          ),
        if (ingingo.imageUrl != null && ingingo.imageUrl != '')
          buildImage(context, ingingo),
      ],
    );
  }

  Widget buildImage(BuildContext context, IngingoModel ingingo) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border.fromBorderSide(
                BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.memoryNetwork(
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: kTransparentImage,
                image: ingingo.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.016),
        if (ingingo.imageDesc != null && ingingo.imageDesc != '')
          Text(
            ingingo.imageDesc ?? '',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.021,
              fontWeight: FontWeight.normal,
            ),
          ),
      ],
    );
  }

  Widget buildConclusion(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
      child: Text(
        widget.isomo.conclusion,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height * 0.021,
        ),
      ),
    );
  }
}
