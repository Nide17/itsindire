import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
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
    final allAmasomos = Provider.of<List<IsomoModel?>?>(context);

    return MultiProvider(
        providers: [
          StreamProvider<List<CourseProgressModel?>?>.value(
            value: CourseProgressService().getUnfinishedProgresses(usr?.uid),
            initialData: null,
            catchError: (context, error) {
              return [];
            },
          ),
        ],
        child: Consumer<List<CourseProgressModel?>?>(
            builder: (context, notFinishedProgresses, child) {
          if (allAmasomos != null) {
            for (var isomo in allAmasomos) {
              if (notFinishedProgresses != null) {
                if (!notFinishedProgresses
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
          final overallProgress = usr != null &&
                  allAmasomos != null &&
                  notFinishedProgresses != null
              ? (allAmasomos.length - notFinishedProgresses.length) /
                  allAmasomos.length
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
                  AmasomoProgress(progressesToShow: notFinishedProgresses)
                else
                  const ViewNotLoggedIn(),
              ]),
              bottomNavigationBar: const RebaIbiciro());
        }));
  }
}
