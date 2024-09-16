import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/firebase_services/isomo_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/amasomo_progress.dart';
import 'package:tegura/utilities/view_not_logged_in.dart';
import 'package:tegura/utilities/progress_circle.dart';
import 'package:tegura/utilities/app_bar.dart';

class Hagati extends StatefulWidget {
  const Hagati({super.key});

  @override
  State<Hagati> createState() => _HagatiState();
}

class _HagatiState extends State<Hagati> {
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);

    return MultiProvider(
        providers: [
          StreamProvider<List<IsomoModel?>?>.value(
            value: IsomoService().getAllAmasomo(usr?.uid),
            initialData: null,
            catchError: (context, error) {
              return [];
            },
          ),
          StreamProvider<List<CourseProgressModel?>?>.value(
            value: CourseProgressService().getUserProgresses(usr?.uid),
            initialData: null,
            catchError: (context, error) {
              return [];
            },
          ),
        ],
        child: Consumer<List<IsomoModel?>?>(builder: (context, amasomo, child) {
          return Consumer<List<CourseProgressModel?>?>(
              builder: (context, progresses, child) {
            List<CourseProgressModel?>? notFinishedProgresses = [];

            if (progresses != null) {
              notFinishedProgresses = progresses
                  .where((progress) =>
                      progress?.currentIngingo != progress?.totalIngingos)
                  .toList();
            }

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

            final overallProgress = usr != null && amasomo != null
                ? (amasomo.length - notFinishedProgresses.length) /
                    amasomo.length
                : 0.0;

            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 71, 103, 158),
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(58.0),
                  child: AppBarTegura(),
                ),
                body: ListView(children: <Widget>[
                  const GradientTitle(
                      title: 'AMASOMO UGEZEMO HAGATI',
                      icon: 'assets/images/video_icon.svg'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
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
                bottomNavigationBar: const RebaIbiciro());
          });
        }));
  }
}
