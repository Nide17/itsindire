import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/amasomo_progress.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/progress_circle.dart';
import 'package:itsindire/utilities/view_not_logged_in.dart';
import 'package:provider/provider.dart';

class Wasoje extends StatefulWidget {
  const Wasoje({super.key});

  @override
  State<Wasoje> createState() => _WasojeState();
}

class _WasojeState extends State<Wasoje> {
  @override
  Widget build(BuildContext context) {
    final allAmasomos = Provider.of<List<IsomoModel?>?>(context);

    return MultiProvider(
        providers: [
          StreamProvider<List<CourseProgressModel?>?>.value(
            value: FirebaseAuth.instance.currentUser != null
                ? CourseProgressService().getFinishedProgresses(
                    FirebaseAuth.instance.currentUser!.uid)
                : null,
            initialData: null,
            catchError: (context, error) {
              return [];
            },
          ),
        ],
        child: Consumer<AuthState>(builder: (context, authState, _) {
          return Consumer<List<CourseProgressModel?>?>(
              builder: (context, finishedProgresses, child) {
            final overallProgress =
                allAmasomos != null && finishedProgresses != null
                    ? finishedProgresses.length / allAmasomos.length
                    : 0.0;

            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 71, 103, 158),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(58.0),
                  child: AppBarItsindire(),
                ),
                body: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(Color(0xFFFFBD59)),
                  ),
                  child: Scrollbar(
                    child: ListView(children: <Widget>[
                      const GradientTitle(
                          title: 'AMASOMO WASOJE KWIGA',
                          icon: 'assets/images/course_list.svg'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      ProgressCircle(
                        percent: authState.currentProfile != null
                            ? overallProgress
                            : 0.0,
                        progress: authState.currentProfile != null
                            ? 'Ugeze kukigero cya ${(overallProgress * 100).toStringAsFixed(0)}% wiga!'
                            : 'Banza winjire!',
                        usr: authState.currentUser,
                      ),
                      if (authState.currentProfile != null)
                        AmasomoProgress(progressesToShow: finishedProgresses)
                      else
                        const ViewNotLoggedIn(),
                    ]),
                  ),
                ),
                bottomNavigationBar: const RebaIbiciro());
          });
        }));
  }
}
