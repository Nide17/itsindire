import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/firebase_services/ingingo_db.dart';
import 'package:itsindire/firebase_services/isomo_db.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/firebase_services/pop_question_db.dart';
import 'package:itsindire/main.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:itsindire/screens/iga/iga_data.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:itsindire/utilities/no_internet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class IgaLanding extends StatefulWidget {
  const IgaLanding({super.key});

  @override
  State<IgaLanding> createState() => _IgaLandingState();
}

class _IgaLandingState extends State<IgaLanding> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final conn = Provider.of<ConnectionStatus>(context);
    checkInternet(context, conn);

    return loading
        ? const LoadingWidget()
        : MultiProvider(
            providers: [
              StreamProvider<List<IsomoModel?>?>.value(
                value: IsomoService()
                    .getAllAmasomo(FirebaseAuth.instance.currentUser?.uid),
                initialData: null,
                catchError: (context, error) {
                  return [];
                },
              ),
              StreamProvider<List<CourseProgressModel?>?>.value(
                value: CourseProgressService()
                    .getUserProgresses(FirebaseAuth.instance.currentUser?.uid),
                initialData: null,
                catchError: (context, error) {
                  return [];
                },
              ),
            ],
            child: Consumer<List<CourseProgressModel?>?>(
                builder: (context, allUserProgresses, child) {
              return Consumer<List<IsomoModel?>?>(
                  builder: (context, allAmasomos, _) {
                if (allUserProgresses != null &&
                    allUserProgresses.isEmpty &&
                    allAmasomos != null &&
                    allAmasomos.isNotEmpty) {
                  loading = true;

                  for (var isomo in allAmasomos) {
                    // GET THE TOTAL INGINGOS FOR THE COURSE AND UPDATE THE PROGRESS'S TOTAL INGINGOS
                    IngingoService()
                        .getTotalIsomoIngingos(isomo!.id)
                        .listen((isomoEvent) {
                      // GET THE TOTAL NUMBER OF POP QUESTIONS
                      PopQuestionService()
                          .getPopQuestionsByIsomoID(isomo.id)
                          .listen((popQnEvent) {
                            if (FirebaseAuth.instance.currentUser != null) {
                              CourseProgressService().updateUserCourseProgress(
                                FirebaseAuth.instance.currentUser!.uid,
                                isomo.id,
                                0,
                                isomoEvent.realTotalIngingos,
                                popQnEvent.length,
                              );
                            }
                      });
                    });
                  }

                  loading = false;
                }
                return Scaffold(
                    backgroundColor: const Color.fromARGB(255, 71, 103, 158),
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(58.0),
                      child: AppBarItsindire(),
                    ),
                    body: conn.isOnline == false
                        ? const NoInternet()
                        : ListView(
                            children: igaList.asMap().entries.map((entry) {
                              final bool isFirst = entry.key == 0;
                              final bool isLast =
                                  entry.key == igaList.length - 1;
                              final double height = isFirst
                                  ? MediaQuery.of(context).size.height * 0.06
                                  : MediaQuery.of(context).size.height * 0.025;
                              final Map<String, dynamic> item = entry.value;

                              return Column(
                                children: <Widget>[
                                  SizedBox(height: height),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.012,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.025,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00CCE5),
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        width: 2.0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(255, 54, 54, 54),
                                          offset: Offset(1, 3),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: item['screen']));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          SvgPicture.asset(
                                            item['icon'],
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          Text(item['text'],
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.045,
                                                color: const Color(0xFF000000),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isLast)
                                    Column(children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      Container(
                                        color: const Color(0xFF000000),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                    ])
                                ],
                              );
                            }).toList(),
                          ),
                    bottomNavigationBar: const RebaIbiciro());
              });
            }),
          );
  }
}

// Internet check function
Future<void> checkInternet(BuildContext context, ConnectionStatus conn) async {
  bool everDisconnected = false;

  if (conn.isOnline == false) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nta internet mufite!.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 255, 8, 0),
          duration: Duration(seconds: 3),
        ),
      );
    });
    everDisconnected = true;
  }

  if (conn.isOnline && everDisconnected) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Internet yagarutse!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 255, 85),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}
