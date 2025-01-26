import 'package:flutter/material.dart';
import 'package:itsindire/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/screens/iga/iga_card.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/ibimurika.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/ibyapa.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/imirongo.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/inyongera.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/igazeti.dart';
import 'package:itsindire/utilities/app_bar.dart';

class Igazeti extends StatefulWidget {
  const Igazeti({super.key});

  @override
  State<Igazeti> createState() => _IgazetiState();
}

class _IgazetiState extends State<Igazeti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          child: ListView(children: <Widget>[
            const GradientTitle(
                title: 'IGAZETI N\'IBIMENYETSO',
                icon: 'assets/images/igazeti.svg'),

            // Vertical space
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            // Cards row for IGAZETI and IBYAPA
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

            // Vertical space
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            // Cards row for IMIRONGO and IBIMURIKA
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
            ),

            // Vertical space
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            // Cards row for IBYAPA NYONGERA N'IBINTU NGOBOKA
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IgaCard(
                  title: 'IBYAPA NYONGERA N\'IBINTU NGOBOKA',
                  icon: 'assets/images/Ahari ubutabazi.png',
                  screen: IgazetiInyongera(),
                ),
              ],
            ),
          ]),
        ),
        bottomNavigationBar: const RebaIbiciro());
  }
}
