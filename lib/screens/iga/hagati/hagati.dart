import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/firebase_services/isomodb.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/amasomo_progress.dart';
import 'package:tegura/utilities/view_not_logged_in.dart';
import 'package:tegura/utilities/progress_circle.dart';
import 'package:tegura/utilities/appbar.dart';

class Hagati extends StatefulWidget {
  const Hagati({Key? key}) : super(key: key);

  @override
  State<Hagati> createState() => _HagatiState();
}

class _HagatiState extends State<Hagati> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET THE USER
    final usr = Provider.of<UserModel?>(context);

    // RETURN THE WIDGETS
    return MultiProvider(
        providers: [
          // GET THE AMASOMO
          StreamProvider<List<IsomoModel?>?>.value(
            // WHAT TO GIVE TO THE CHILDREN WIDGETS
            value: IsomoService()
                .getAllAmasomo(usr?.uid),
            initialData: null,

            // CATCH ERRORS
            catchError: (context, error) {
              // PRINT THE ERROR
              if (kDebugMode) {
                print("Error in main2 isomo: $error");
                print(
                    "The err: ${IsomoService().getAllAmasomo(usr?.uid)}");
              }
              // RETURN NULL
              return null;
            },
          ),

          StreamProvider<List<CourseProgressModel?>?>.value(
            // WHAT TO GIVE TO THE CHILDREN WIDGETS
            value: CourseProgressService()
                .getUserProgresses(usr?.uid),
            initialData: null,

            // CATCH ERRORS
            catchError: (context, error) {
              // PRINT THE ERROR
              if (kDebugMode) {
                print("Error in get pro wasoje: $error");
                print(
                    "The err: ${CourseProgressService().getUserProgresses(usr?.uid)}");
              }
              // RETURN NULL
              return null;
            },
          ),
        ],
        child: Consumer<List<IsomoModel?>?>(builder: (context, amasomo, child) {
          return Consumer<List<CourseProgressModel?>?>(
              builder: (context, progresses, child) {
            // LIST OF PROGRESSES THAT ARE NOT FINISHED BY THE USER AND ALSO THE ONES THAT ARE NOT STARTED
            List<CourseProgressModel?>? notFinishedProgresses = [];

            // GET UNFINISHED PROGRESSES
            if (progresses != null) {
              notFinishedProgresses = progresses
                  .where((progress) =>
                      progress?.currentIngingo != progress?.totalIngingos)
                  .toList();
            }

            // GET THE AMASOMOS THAT ARE NOT STARTED, MAKE EMPTY PROGRESSES FOR THEM, ADD THEM TO THE PROGRESSES LIST
            if (amasomo != null) {
              for (var isomo in amasomo) {
                if (progresses != null) {
                  if (!progresses
                      .any((progress) => progress?.courseId == isomo!.id)) {
                    notFinishedProgresses.add(CourseProgressModel(
                      courseId: isomo!.id,
                      currentIngingo: 0,
                      totalIngingos: 1,
                      id: '',
                      userId: usr != null ? usr.uid : '',
                    ));
                  }
                }
              }
            }

            // OVERALL PROGRESS - RATIO OF FINISHED PROGRESSES TO ALL PROGRESSES
            final overallProgress = usr != null && amasomo != null
                ? (amasomo.length - notFinishedProgresses.length) / amasomo.length
                : 0.0;

            // LIST OF INGINGOS CONSUMER
            return Scaffold(
                backgroundColor: const Color(0xFF5B8BDF),

                // APP BAR
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(58.0),
                  child: AppBarTegura(),
                ),

                // PAGE BODY
                body: ListView(children: <Widget>[
                  // 1. GRADIENT TITLE
                  const GradientTitle(
                      title: 'AMASOMO UGEZEMO HAGATI',
                      icon: 'assets/images/video_icon.svg'),

                  // 2. ADD 10.0 PIXELS OF SPACE
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  // 3. ELLIPSE WITH SPACES IN THE STROKE
                  ProgressCircle(
                    percent: usr != null ? overallProgress : 0.0,
                    progress: usr != null
                        ? 'Ugeze kukigero cya ${(overallProgress * 100).toStringAsFixed(0)}% wiga!'
                        : 'Banza winjire!',
                    usr: usr,
                  ),

                  if (usr != null)
                    AmasomoProgress(
                        userId: usr.uid,
                        progressesToShow: notFinishedProgresses,
                        amasomo: amasomo,
                        progresses: progresses)
                  else
                    const ViewNotLoggedIn(),
                ]),

                // BOTTOM NAVIGATION BAR
                bottomNavigationBar: const RebaIbiciro());
          });
        }));
  }
}
