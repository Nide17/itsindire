import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/screens/iga/amasuzuma/amasuzuma_card.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';

class Amasuzumabumenyi extends StatefulWidget {
  const Amasuzumabumenyi({super.key});

  @override
  State<Amasuzumabumenyi> createState() => _AmasuzumabumenyiState();
}

class _AmasuzumabumenyiState extends State<Amasuzumabumenyi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<IsuzumaModel>?>(
        builder: (context, amasuzumabumenyi, _) {
      // SORT THE AMASUZUMABUMENYI
      amasuzumabumenyi =
          amasuzumabumenyi != null ? sortIsuzuma(amasuzumabumenyi) : [];
    
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 71, 103, 158),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(58.0),
            child: AppBarTegura(),
          ),
          body: ListView(children: <Widget>[
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
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '            ',
                      children: <TextSpan>[
                        TextSpan(
                          text: 'AMANOTA',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.04,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFFFFBD59),
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    
            // 3. AMASUZUMABUMENYI CARDS
            for (var i = 0; i < amasuzumabumenyi.length; i++)
              AmasuzumaCard(isuzuma: amasuzumabumenyi[i])
          ]),
          bottomNavigationBar: const RebaIbiciro());
    });
  }
}

// sort the amasuzumabumenyi by id:
List<IsuzumaModel> sortIsuzuma(List<IsuzumaModel> amasuzumabumenyi) {
  amasuzumabumenyi.sort((a, b) => int.parse(a.title.split(' ')[2])
      .compareTo(int.parse(b.title.split(' ')[2])));
  return amasuzumabumenyi;
}
