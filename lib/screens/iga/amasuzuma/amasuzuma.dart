import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/amasuzuma/amanota.dart';
import 'package:tegura/screens/iga/gradient_title.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_book.dart';
import 'package:tegura/screens/iga/iga_card.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_imirongo.dart';
import 'package:tegura/screens/utilities/my_appbar.dart';

class Amasuzumabumenyi extends StatefulWidget {
  const Amasuzumabumenyi({Key? key}) : super(key: key);

  @override
  AmasuzumabumenyiState createState() => AmasuzumabumenyiState();
}

class AmasuzumabumenyiState extends State<Amasuzumabumenyi> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    // const usr = null;
    if (kDebugMode) {
      print(usr?.uid);
    }

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
              title: 'Amasuzumabumenyi yose',
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

          // CARDS ROW FOR IGAZETI, AND IBYAPA - FLEX 50%
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              IgaCard(
                title: 'ISUZUMABUMENYI RYA 1',
                icon: 'assets/images/isuzuma.png',
                screen: IgazetiBook(),
              ),
              Amanota(
                score: 12,
                maxScore: 20,
              ),
            ],
          ),

          // 3. VERTICAL SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          // CARDS ROW FOR IMIRONGO, AND IBIMURIKA - FLEX 50%
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              IgaCard(
                title: 'ISUZUMABUMENYI RYA 2',
                icon: 'assets/images/isuzuma.png',
                screen: IgazetiImirongo(),
              ),
              Amanota(
                score: 0,
                maxScore: 20,
              ),
            ],
          )
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
