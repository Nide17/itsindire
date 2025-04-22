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
  static const double verticalSpacing = 16.0;

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'IGAZETI',
      'icon': 'assets/images/igazeti_book.png',
      'screen': IgazetiBook(),
    },
    {
      'title': 'IBYAPA',
      'icon': 'assets/images/ibyapa.png',
      'screen': IgazetiIbyapa(),
    },
    {
      'title': 'IMIRONGO YO MUMUHANDA',
      'icon': 'assets/images/imirongo.png',
      'screen': IgazetiImirongo(),
    },
    {
      'title': 'IBIMENYETSO BIMURIKA',
      'icon': 'assets/images/ibimurika.png',
      'screen': IgazetiIbimurika(),
    },
    {
      'title': 'IBYAPA NYONGERA N\'IBINTU NGOBOKA',
      'icon': 'assets/images/Ahari ubutabazi.png',
      'screen': IgazetiInyongera(),
    },
  ];

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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const GradientTitle(
              title: 'IGAZETI N\'IBIMENYETSO',
              icon: 'assets/images/igazeti.svg',
            ),
            SizedBox(height: verticalSpacing),
            _buildCardGrid(),
          ],
        ),
      ),
      bottomNavigationBar: const RebaIbiciro(),
    );
  }

  Widget _buildCardGrid() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.spaceAround,
      children: cards.map((card) {
        return IgaCard(
          title: card['title'],
          icon: card['icon'],
          screen: card['screen'],
        );
      }).toList(),
    );
  }
}
