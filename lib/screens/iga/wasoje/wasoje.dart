import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/view_logged_in.dart';
import 'package:tegura/utilities/view_not_logged_in.dart';
import 'package:tegura/utilities/progress_circle.dart';
import 'package:tegura/utilities/appbar.dart';

class Wasoje extends StatefulWidget {
  const Wasoje({Key? key}) : super(key: key);

  @override
  State<Wasoje> createState() => _WasojeState();
}

class _WasojeState extends State<Wasoje> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    // const usr = null;
    // print(usr?.uid);

    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size * 0.07,
          child: const AppBarTegura(),
        ),

        // PAGE BODY
        body: ListView(children: <Widget>[
          // 1. GRADIENT TITLE
          const GradientTitle(
              title: 'AMASOMO WASOJE KWIGA',
              icon: 'assets/images/course_list.svg'),

          // 2. VERTICAL SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // 3. ELLIPSE WITH SPACES IN THE STROKE
          ProgressCircle(
            percent: usr != null ? 1.0 : 0.0,
            progress: usr != null
                ? 'Ugeze kukigero cya 100% wiga!'
                : 'Nturatangira kwiga!',
            usr: usr,
          ),

          if (usr != null)
            Column(
              children: const [
                // ViewLoggedIn(
                //     title: 'IBYAPA BYO KUMIHANDA',
                //     description:
                //         'Ibyapa byo kumuhanda bigira uruhare runini mukurinda umutekano mumihanda yacu...',
                //     progress: 1.0),
                // ViewLoggedIn(
                //     title: 'IBYAPA BYO MUMUHANDA',
                //     description:
                //         'Ibimenyetso byo mumuhanda ni imirongo cyangwa inyuguti bishushanyije mumuhanda...',
                //     progress: 1.0),
                // ViewLoggedIn(
                //     title: 'IMPANUKA',
                //     description:
                //         'Hari amategeko yihariye ajyena uko umuyobozi agomba kwitwara mubihe by\'impanuka...',
                //     progress: 1.0),
                
              ],
            )
          else
            const ViewNotLoggedIn(),
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
