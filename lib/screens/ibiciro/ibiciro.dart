import 'package:flutter/material.dart';
import 'package:tegura/screens/ibiciro/ibiciro_data.dart';
import 'package:tegura/screens/ibiciro/ifatabuguzi.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/utilities/appbar.dart';

class Ibiciro extends StatefulWidget {
  const Ibiciro({Key? key}) : super(key: key);

  @override
  State<Ibiciro> createState() => _IbiciroState();
}

class _IbiciroState extends State<Ibiciro> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarTegura(),
        ),

        // PAGE BODY
        body: ListView(
          children: [
            // GRADIENT TITLE
            const GradientTitle(
                title: 'IBICIRO BYO KWIGA', icon: 'assets/images/ibiciro.svg'),

            // DESCRIPTION
            const Description(
                text:
                    'Ishyura amafaranga ahwanye n\'ifatabuguzi wifuza, uhite utangira kwiga.'),

            // IBICIRO DETAILS - ibiciroData.map in Column
            Column(
              children: ibiciroData.asMap().entries.map((entry) {
                int index = entry.key;
                final Map<String, dynamic> item = entry.value;
                return Ifatabuguzi(
                    umubare: index + 1,
                    igihe: item['igihe'],
                    igiciro: item['igiciro'],
                    detailsList: item['detailsList'],
                    detailsText: item['detailsText']);
              }).toList(),
            ),
          ],
        ));
  }
}
