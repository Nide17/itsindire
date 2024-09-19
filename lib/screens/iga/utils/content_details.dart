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

  Future<void> getTotalIngingos() async {
    Stream<IsomoIngingoSum> totalIngingos =
        IngingoService().getTotalIsomoIngingos(widget.isomo.id);

    totalIngingos.listen((event) {
      setState(() {
        thisCourseTotalIngingos = event.totalIngingos;
        loadingTotalIngingos = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalIngingos();
  }

  @override
  Widget build(BuildContext context) {
    final currPageIngingos = Provider.of<List<IngingoModel>?>(context) ?? [];
    final courseProgress = Provider.of<CourseProgressModel?>(context);
    final quizPopQuestions = Provider.of<List<PopQuestionModel>?>(context);
    final totalIngingos = courseProgress?.totalIngingos ?? 0;
    final currentIngingo = courseProgress?.currentIngingo ?? 0;
    final unansweredPopQuestions = courseProgress?.unansweredPopQuestions ?? 0;

    return loadingTotalIngingos
        ? const LoadingWidget()
        : ListView.builder(
            controller: widget.controller,
            itemCount: currPageIngingos.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Align(
                  child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.008,
                    horizontal: MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.02),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
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
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                  child: Column(
                    children: [
                      if (index == 0 &&
                          currentIngingo == totalIngingos &&
                          unansweredPopQuestions == 0)
                        Text(
                          'Wasoje kwiga isomo!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.021,
                              color: Colors.green),
                        ),
                      if (index == 0 &&
                          currentIngingo == totalIngingos &&
                          unansweredPopQuestions == 0)
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ItsindireAlert(
                                    errorTitle: 'IBIJYANYE NIRI SOMO',
                                    errorMsg:
                                        'Ugiye kwiga isomo ryitwa "${widget.isomo.title}" rigizwe n’ingingo "${totalIngingos}" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : totalIngingos * 3}" gusa!',
                                    firstButtonTitle: 'Inyuma',
                                    firstButtonFunction: () {
                                      Navigator.pop(context);
                                    },
                                    firstButtonColor: const Color(0xFFE60000),
                                    secondButtonTitle: 'Tangira',
                                    secondButtonFunction: () {
                                      // Update the user progress in the database
                                      if (courseProgress != null &&
                                          quizPopQuestions != null) {
                                        CourseProgressService()
                                            .updateUserCourseProgress(
                                                courseProgress.userId,
                                                courseProgress.courseId,
                                                0,
                                                courseProgress.totalIngingos,
                                                quizPopQuestions.length);
                                      }
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => IgaContent(
                                                  isomo: widget.isomo,
                                                  courseProgress:
                                                      courseProgress,
                                                  thisCourseTotalIngingos:
                                                      thisCourseTotalIngingos)));
                                    },
                                    secondButtonColor: const Color(0xFF00A651),
                                  );
                                });
                          },
                          child: const Text('Ongera utangire iri somo!'),
                        ),
                      if (index == 0 &&
                          currentIngingo == totalIngingos &&
                          unansweredPopQuestions == 0)
                        const SizedBox(height: 10.0),
                      if (index == 0 && widget.isomo.introText != '')
                        Text(
                          '\n${widget.isomo.introText}\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02),
                        ),
                      ContentTitlenText(
                        title: '${currPageIngingos[index].title} ',
                        text: '${currPageIngingos[index].text}',
                      ),
                      if (currPageIngingos[index].insideTitle != null &&
                          currPageIngingos[index].insideTitle != '')
                        Text(
                          '\n\n${currPageIngingos[index].insideTitle}',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                      if (currPageIngingos[index].options != null &&
                          currPageIngingos[index].options != [])
                        Column(
                          children: List.generate(
                            currPageIngingos[index].options.length,
                            (optionIndex) {
                              Option option = Option.fromJson(
                                  currPageIngingos[index].options[optionIndex]);
                              return OptionContent(option: option);
                            },
                          ).toList(),
                        ),
                      if (currPageIngingos[index].nb != null &&
                          currPageIngingos[index].nb != '')
                        Text.rich(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.021),
                          TextSpan(
                            children: [
                              const TextSpan(
                                  text: '\nNB: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '${currPageIngingos[index].nb}'),
                            ],
                          ),
                        ),
                      if (currPageIngingos[index].imageUrl != null &&
                          currPageIngingos[index].imageUrl != '')
                        Column(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                                    placeholder: kTransparentImage,
                                    image:
                                        currPageIngingos[index].imageUrl ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            if (currPageIngingos[index].imageDesc != null &&
                                currPageIngingos[index].imageDesc != '')
                              Text(
                                currPageIngingos[index].imageDesc ?? '',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021,
                                    fontWeight: FontWeight.normal),
                              ),
                          ],
                        ),
                      if (index == currPageIngingos.length - 1 &&
                          widget.isomo.conclusion != '')
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
                          child: Text(
                            widget.isomo.conclusion,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.021),
                          ),
                        ),
                    ],
                  ),
                ),
              ));
            },
          );
  }
}
