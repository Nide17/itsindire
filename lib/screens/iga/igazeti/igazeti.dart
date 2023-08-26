import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_book.dart';
import 'package:tegura/screens/iga/iga_card.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_ibimurika.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_ibyapa.dart';
import 'package:tegura/screens/iga/igazeti/igazeti_imirongo.dart';
import 'package:tegura/utilities/appbar.dart';

class Igazeti extends StatefulWidget {
  const Igazeti({Key? key}) : super(key: key);

  @override
  State<Igazeti> createState() => _IgazetiState();
}

class _IgazetiState extends State<Igazeti> {
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
              title: 'IGAZETI N\'IBIMENYETSO',
              icon: 'assets/images/igazeti.svg'),

          // 2. VERTICAL SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),

          // CARDS ROW FOR IGAZETI, AND IBYAPA - FLEX 50%
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              IgaCard(
                title: 'IGAZETI',
                icon: 'assets/images/igazeti_book.png',
                screen: IgazetiBook(),
              ),
              IgaCard(
                title: 'IBYAPA',
                icon: 'assets/images/ibyapa.png',
                screen: IgazetiIbyapa(),
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
                title: 'IMIRONGO YO MUMUHANDA',
                icon: 'assets/images/imirongo.png',
                screen: IgazetiImirongo(),
              ),
              IgaCard(
                title: 'IBIMENYETSO BIMURIKA',
                icon: 'assets/images/ibimurika.png',
                screen: IgazetiIbimurika(),
              ),
            ],
          )
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
