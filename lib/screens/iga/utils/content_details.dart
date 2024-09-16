import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/screens/iga/utils/content_title_text.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/screens/iga/utils/option_content.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';

class ContentDetails extends StatefulWidget {
// INSTANCE VARIABLES
  final IsomoModel isomo;
  final String? userID;

  const ContentDetails({
    super.key,
    required this.isomo,
    this.userID,
  });

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  final int pageNumber = 1;
  final int? limit = 1;
  final int? skip = 1;

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET THE currINGINGOS
    final currIngingos = Provider.of<List<IngingoModel>?>(context) ?? [];

    // GET THE COURSE PROGRESS
    final courseProgress = Provider.of<CourseProgressModel?>(context);

    // GET THE REAL TOTAL NUMBER OF INGINGOS IN THE COURSE
    final IngingoSum? realTotalIngingos = Provider.of<IngingoSum?>(context);

    // GET THE TOTAL NUMBER OF INGINGOS IN THE COURSE
    final totalIngs = courseProgress != null ? courseProgress.totalIngingos : 0;

    // UPDATE THE PROGRESS IF THE REAL TOTAL INGINGOS IS GREATER THAN THE CURRENT TOTAL INGINGOS
    if (realTotalIngingos != null &&
        int.parse(realTotalIngingos.toString()) > totalIngs) {
      // UPDATE THE PROGRESS
      CourseProgressService().updateUserCourseProgress(
          courseProgress != null ? courseProgress.userId : widget.userID ?? '',
          widget.isomo.id,
          int.parse(realTotalIngingos.toString()),
          courseProgress != null ? courseProgress.currentIngingo : 0);
    }

    // GET THE CURRENT PROGRESS
    final currProgress =
        courseProgress != null ? courseProgress.currentIngingo : 0;

    // RETURN THE CONTENT
    return Column(children: <Widget>[
      // 1. GRADIENT TITLE
      Container(
        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
        decoration: const BoxDecoration(
          color: Color(0xFF5B8BDF),
        ),
        child:
            GradientTitle(title: widget.isomo.title, icon: '', marginTop: 8.0),
      ),
      // 3. INGINGO LIST
      Expanded(
        child: currIngingos.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Iri somo nta ngingo rifite!',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9D14DD),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // REDIRECT BUTTON TO /iga
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0XFF00A651),
                      backgroundColor: const Color(0xFF0500E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Funga',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                ),
                child: ListView.builder(
                  itemCount: currIngingos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
                      child: Column(
                        children: [
                          // IF THE COURSE HAS BEEN COMPLETED, SHOW THE COMPLETED MESSAGE
                          if (index == 0 && currProgress == totalIngs)
                            const Text(
                              'Wasoje kwiga isomo!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  color: Colors.green),
                            ),

                          // IF THE COURSE HAS BEEN COMPLETED, MAKE A RESET BUTTON
                          if (index == 0 && currProgress == totalIngs)
                            ElevatedButton(
                              onPressed: () {
                                CourseProgressService()
                                    .updateUserCourseProgress(
                                  courseProgress != null
                                      ? courseProgress.userId
                                      : widget.userID ?? '',
                                  courseProgress != null
                                      ? courseProgress.courseId
                                      : 0,
                                  totalIngs,
                                  0,
                                );

                                // GO BACK TO THE COURSE PAGE
                                Navigator.pop(context);
                              },
                              child: const Text('Ongera utangire iri somo!'),
                            ),

                          if (index == 0 && currProgress == totalIngs)
                            const SizedBox(height: 10.0),

                          // isomo.introText IF ANY, ON THE FIRST INGINGO
                          if (index == 0 && widget.isomo.introText != '')
                            Text(
                              '${widget.isomo.introText}\n\n',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),

                          ContentTitlenText(
                            title: '${currIngingos[index].title} ',
                            text: '${currIngingos[index].text}',
                          ),

                          // IF INGINGO HAS insideTitle
                          if (currIngingos[index].insideTitle != null &&
                              currIngingos[index].insideTitle != '')
                            Text(
                              '\n\n${currIngingos[index].insideTitle}',
                              style: const TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),

                          // IF INGINGO HAS OPTIONS USING ABOVE METHOD
                          if (currIngingos[index].options != null &&
                              currIngingos[index].options != [])
                            Column(
                              children: List<Widget>.generate(
                                currIngingos[index].options.length,
                                (optionIndex) {
                                  // ONE OPTION
                                  Option option = Option.fromJson(
                                      currIngingos[index].options[optionIndex]);

                                  // RETURN THE WIDGETS OF THE OPTIONS
                                  return OptionContent(
                                      option: // check if null or not
                                          option);
                                },
                              ).toList(),
                            ),

                          // INGINGO NB IF ANY
                          if (currIngingos[index].nb != null &&
                              currIngingos[index].nb != '')
                            Text.rich(
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text: '\nNB: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: '${currIngingos[index].nb}'),
                                ],
                              ),
                            ),

                          // INGINGO FB STORAGE NETWORK IMAGE IF ANY
                          if (currIngingos[index].imageUrl != null &&
                              currIngingos[index].imageUrl != '')
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      0.0, 4.0, 0.0, 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set the desired border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.8), // Set the shadow color
                                        spreadRadius:
                                            2.0, // Set the spread radius
                                        blurRadius: 5.0, // Set the blur radius
                                        offset: const Offset(
                                            0, 3), // Set the shadow offset
                                      ),
                                    ],
                                  ),
                                  // BORDER RADIUS OF THE IMAGE
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set the desired border radius
                                    child: Image.network(
                                      currIngingos[index].imageUrl ?? '',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // INGINGO IMAGE CAPTION IF ANY
                                if (currIngingos[index].imageDesc != null &&
                                    currIngingos[index].imageDesc != '')
                                  Text(
                                    currIngingos[index].imageDesc ?? '',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ),
                              ],
                            ),

                          // ISOMO CONCLUSION IF ANY
                          if (index == currIngingos.length - 1 &&
                              widget.isomo.conclusion != '')
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  0.0, 12.0, 0.0, 14.0),
                              child: Text(
                                widget.isomo.conclusion,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                        ],
                      ),
                    ));
                  },
                )),
      ),
    ]);
  }
}
