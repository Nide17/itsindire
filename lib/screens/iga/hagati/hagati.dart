import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/view_logged_in.dart';
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

    // GET THE AMASOMO DATA - IsomoService().getAllAmasomo(FirebaseAuth.instance.currentUser?.uid
    final amasomo = Provider.of<List<IsomoModel?>?>(context);
    
    // BUILD ViewLoggedIn WIDGETS WITH THE AMASOMO DATA ELEMENTS
    final amasomoWidgets = amasomo?.map((isomo) => ViewLoggedIn(
          isomo: isomo ??
              IsomoModel(
                title: 'Nta somo ryabonetse',
                description: 'Nta somo ryabonetse',
                introText: 'Nta somo ryabonetse',
                id: 0,
                conclusion: 'Nta somo ryabonetse',
              ),
          userId: usr!.uid,
        ));

    // RETURN THE WIDGETS
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
              title: 'AMASOMO UGEZEMO HAGATI',
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

          if (usr != null && amasomo != null)
            Column(
              children: amasomoWidgets!.toList(),
            )
          else
            const ViewNotLoggedIn(),
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
