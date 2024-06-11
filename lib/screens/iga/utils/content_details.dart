import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/ingingo_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/screens/iga/utils/content_title_text.dart';
import 'package:tegura/screens/iga/utils/iga_content.dart';
import 'package:tegura/screens/iga/utils/option_content.dart';
import 'package:tegura/utilities/loading_widget.dart';
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
    final usr = FirebaseAuth.instance.currentUser;
    final currPageIngingos = Provider.of<List<IngingoModel>?>(context) ?? [];
    final courseProgress = Provider.of<CourseProgressModel?>(context);
    final totalIngingos = courseProgress?.totalIngingos ?? 0;
    final currentIngingo = courseProgress?.currentIngingo ?? 0;

    return loadingTotalIngingos
        ? const LoadingWidget()
        : ListView.builder(
            controller: widget.controller,
            itemCount: currPageIngingos.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Align(
                  child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
                child: Column(
                  children: [
                    if (index == 0 && currentIngingo == totalIngingos)
                      Text(
                        'Wasoje kwiga isomo!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023,
                            color: Colors.green),
                      ),
                    if (index == 0 && currentIngingo == totalIngingos)
                      ElevatedButton(
                        onPressed: () {
                          CourseProgressService().updateUserCourseProgress(
                            usr!.uid,
                            courseProgress!.courseId,
                            0,
                            totalIngingos,
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IgaContent(
                                      isomo: widget.isomo,
                                      courseProgress: courseProgress,
                                      thisCourseTotalIngingos:
                                          thisCourseTotalIngingos)));
                        },
                        child: const Text('Ongera utangire iri somo!'),
                      ),
                    if (index == 0 && currentIngingo == totalIngingos)
                      const SizedBox(height: 10.0),
                    if (index == 0 && widget.isomo.introText != '')
                      Text(
                        '\n${widget.isomo.introText}\n\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022),
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
                                MediaQuery.of(context).size.height * 0.023,
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
                                MediaQuery.of(context).size.height * 0.023),
                        TextSpan(
                          children: [
                            const TextSpan(
                                text: '\nNB: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '${currPageIngingos[index].nb}'),
                          ],
                        ),
                      ),
                    if (currPageIngingos[index].imageUrl != null &&
                        currPageIngingos[index].imageUrl != '')
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0,
                                MediaQuery.of(context).size.height * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: currPageIngingos[index].imageUrl ?? '',
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (currPageIngingos[index].imageDesc != null &&
                              currPageIngingos[index].imageDesc != '')
                            Text(
                              currPageIngingos[index].imageDesc ?? '',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.023,
                                  fontWeight: FontWeight.normal),
                            ),
                        ],
                      ),
                    if (index == currPageIngingos.length - 1 &&
                        widget.isomo.conclusion != '')
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
                        child: Text(
                          widget.isomo.conclusion,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.023),
                        ),
                      ),
                  ],
                ),
              ));
            },
          );
  }
}
