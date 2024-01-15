import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/ibibazo_bibaza_db.dart';
import 'package:tegura/models/ibibazo_bibaza.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/bibaza/faq.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/utilities/loading_widget.dart';

class Bibaza extends StatefulWidget {
  const Bibaza({super.key});

  @override
  State<Bibaza> createState() => _BibazaState();
}

class _BibazaState extends State<Bibaza> {
  bool loading = false;
  // STATE
  final List<Map<String, dynamic>> ibibazoBibaza1 = [
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // STREAM PROVIDER FOR ibibazoBibaza
        StreamProvider<List<IbibazoBibazaModel>>.value(
          value: IbibazoBibazaService().ibibazoBibaza,
          initialData: const [],
        ),
      ],
      child: Consumer<List<IbibazoBibazaModel>>(
          builder: (context, ibibazoBibaza, child) {
        print(ibibazoBibaza);
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 71, 103, 158),
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: AppBarTegura(),
            ),
            body: ListView(children: <Widget>[
              const GradientTitle(
                  title: 'IBIBAZO ABANYESHURI BIBAZA',
                  icon: 'assets/images/ibibazo_bibaza.svg'),

              // 2. DESCRIPTION
              const Description(
                  text:
                      'Ibi ni ibibazo abanyeshuli bibaza ndetse n\'ibyo batubaza cyane.'),
              // FAQS
              if (ibibazoBibaza.isEmpty)
                // LOADING
                const LoadingWidget()
              else
                for (var i = 0; i < ibibazoBibaza.length; i++)
                  Faq(
                      question: ibibazoBibaza[i].question ?? '',
                      answer: ibibazoBibaza[i].answer ?? '',
                      qIcon: 'assets/images/question.svg',
                      aIcon: 'assets/images/answer.svg'),
            ]),
            bottomNavigationBar: const RebaIbiciro());
      }),
    );
  }
}
