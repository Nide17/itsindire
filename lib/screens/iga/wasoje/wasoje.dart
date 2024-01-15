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

class Wasoje extends StatefulWidget {
  const Wasoje({super.key});

  @override
  State<Wasoje> createState() => _WasojeState();
}

class _WasojeState extends State<Wasoje> {
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    final allAmasomos = Provider.of<List<IsomoModel?>?>(context);

    return MultiProvider(
        providers: [
          StreamProvider<List<CourseProgressModel?>?>.value(
            value: CourseProgressService().getFinishedProgresses(usr?.uid),
            initialData: null,
            catchError: (context, error) {
              return [];
            },
          ),
        ],
        child: Consumer<List<CourseProgressModel?>?>(
            builder: (context, finishedProgresses, child) {
          final overallProgress =
              usr != null && allAmasomos != null && finishedProgresses != null
                  ? finishedProgresses.length / allAmasomos.length
                  : 0.0;

          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 71, 103, 158),
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(58.0),
                child: AppBarTegura(),
              ),
              body: ListView(children: <Widget>[
                const GradientTitle(
                    title: 'AMASOMO WASOJE KWIGA',
                    icon: 'assets/images/course_list.svg'),
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
                  AmasomoProgress(progressesToShow: finishedProgresses)
                else
                  const ViewNotLoggedIn(),
              ]),
              bottomNavigationBar: const RebaIbiciro());
        }));
  }
}
