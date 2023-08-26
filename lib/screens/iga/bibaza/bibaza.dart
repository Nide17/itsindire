import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/bibaza/faq.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';

class Bibaza extends StatefulWidget {
  const Bibaza({Key? key}) : super(key: key);

  @override
  State<Bibaza> createState() => _BibazaState();
}

class _BibazaState extends State<Bibaza> {
  // STATE
  final List<Map<String, dynamic>> ibibazoBibaza = [
    {
      'question': 'Ese iyi App yagufasha gutsinda?',
      'answer':
          'Yego, kuko intego yambere yacu nukukwigisha ukabimenya ndetse tunagutegura gutsindira provisoire.',
      'qIcon': 'assets/images/question.svg',
      'aIcon': 'assets/images/answer.svg',
    },
    {
      'question': 'Habaho ubwoko bungahe bw\'ibyapa?',
      'answer':
          'Ubwoko bw\'ibyapa ni butanu (5).\n 1. Ibyapa biburira\n 2. Ibyapa byo gutambuka mbere\n 3. Ibyapa bibuza\n 4. Ibyapa bitegeka\n 5.Ibyapa ndanga cg biyobora',
      'qIcon': 'assets/images/question.svg',
      'aIcon': 'assets/images/answer.svg',
    }
  ];

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
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
              title: 'IBIBAZO ABANYESHURI BIBAZA',
              icon: 'assets/images/ibibazo_bibaza.svg'),

          // 2. DESCRIPTION
          const Description(
              text:
                  'Ibi ni ibibazo abanyeshuli bibaza ndetse n\'ibyo batubaza cyane.'),
          // FAQS
          for (var i = 0; i < ibibazoBibaza.length; i++)
            Faq(
                question: ibibazoBibaza[i]['question'],
                answer: ibibazoBibaza[i]['answer'],
                qIcon: ibibazoBibaza[i]['qIcon'],
                aIcon: ibibazoBibaza[i]['aIcon']),
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
