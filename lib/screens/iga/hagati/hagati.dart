import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/gradient_title.dart';
import 'package:tegura/screens/utilities/view_logged_in.dart';
import 'package:tegura/screens/utilities/view_not_logged_in.dart';
import 'package:tegura/screens/utilities/progress_circle.dart';
import 'package:tegura/screens/utilities/my_appbar.dart';

class Hagati extends StatefulWidget {
  const Hagati({Key? key}) : super(key: key);

  @override
  _HagatiState createState() => _HagatiState();
}

class _HagatiState extends State<Hagati> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // final usr = Provider.of<UserModel?>(context);
    const usr = null;
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
          GradientTitle(
              title: 'Amasomo ugezemo hagati',
              icon: 'assets/images/video_icon.svg'),

          // 2. ADD 10.0 PIXELS OF SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // 3. ELLIPSE WITH SPACES IN THE STROKE
          ProgressCircle(
            percent: usr != null ? 0.5 : 0.0,
            progress: usr != null
                ? 'Ugeze kukigero cya 50% wiga!'
                : 'Nturatangira kwiga!',
            usr: usr,
          ),

          if (usr != null)
            Column(
              children: [
                ViewLoggedIn(
                    title: 'IBYAPA BYO KUMIHANDA',
                    description:
                        'Ibyapa byo kumuhanda bigira uruhare runini mukurinda umutekano mumihanda yacu...',
                    progress: 0.75),
                ViewLoggedIn(
                    title: 'IBYAPA BYO MUMUHANDA',
                    description:
                        'Ibimenyetso byo mumuhanda ni imirongo cyangwa inyuguti bishushanyije mumuhanda...',
                    progress: 2.8),
                ViewLoggedIn(
                    title: 'IMPANUKA',
                    description:
                        'Hari amategeko yihariye ajyena uko umuyobozi agomba kwitwara mubihe by\'impanuka...',
                    progress: 0.0),
              ],
            )
          else
            const ViewNotLoggedIn(),
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
