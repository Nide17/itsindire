import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/amasuzuma/amasuzuma_card.dart';
import 'package:tegura/firebase_services/isuzuma_db.dart';
import 'package:tegura/firebase_services/isuzuma_score_db.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';

class Amasuzumabumenyi extends StatefulWidget {
  const Amasuzumabumenyi({Key? key}) : super(key: key);

  @override
  State<Amasuzumabumenyi> createState() => _AmasuzumabumenyiState();
}

class _AmasuzumabumenyiState extends State<Amasuzumabumenyi> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<IsuzumaModel>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: IsuzumaService().amasuzumabumenyi,
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error amasuzumabumenyi all: $error");
              print("The err: ${IsuzumaService().amasuzumabumenyi}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // SCORES BY USER
        StreamProvider<List<IsuzumaScoreModel>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: usr != null
              ? IsuzumaScoreService().getScoresByTakerID(usr.uid)
              : IsuzumaScoreService().amasuzumabumenyiScores,

          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error amasuzumabumenyi: $error");
              print(
                  "The err: ${IsuzumaScoreService().getScoresByTakerID(usr!.uid)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child: Consumer<List<IsuzumaModel>?>(
          builder: (context, amasuzumabumenyi, _) {
        return Consumer<List<IsuzumaScoreModel>?>(
            builder: (context, amaUserScores, _) {
          if (amaUserScores == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 71, 103, 158),

              // APP BAR
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(58.0),
                child: AppBarTegura(),
              ),

              // PAGE BODY
              body: ListView(children: <Widget>[
                // 1. GRADIENT TITLE
                const GradientTitle(
                    title: 'AMASUZUMABUMENYI YOSE',
                    icon: 'assets/images/amasuzumabumenyi.svg'),

                // 2. DESCRIPTION
                const Description(
                    text:
                        'Aya ni amasuzumabumenyi ateguye muburyo bugufasha kwimenyereza gukora ikizamini cya provisoire muburyo bw\'ikoranabuhanga ndetse akubiyemo ibibazo bikunze kubazwa na polisi y\'urwanda.'),

                // 2. AMANOTA TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Placeholder(
                      fallbackHeight: 0,
                      fallbackWidth: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: Text(
                        "AMANOTA",
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),

                // 3. FOR EACH AMASUZUMABUMENYI, CREATE A CARD
                for (var i = 0; i < amasuzumabumenyi!.length; i++)
                  AmasuzumaCard(
                    isuzuma: amasuzumabumenyi[i],
                    amaUserScores: amaUserScores,
                  ),
              ]),

              // BOTTOM NAVIGATION BAR
              bottomNavigationBar: const RebaIbiciro());
        });
      }),
    );
  }
}
