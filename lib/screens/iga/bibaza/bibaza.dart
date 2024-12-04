import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/ibibazo_bibaza_db.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/ibibazo_bibaza.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:itsindire/screens/iga/bibaza/faq.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class Bibaza extends StatefulWidget {
  const Bibaza({super.key});

  @override
  State<Bibaza> createState() => _BibazaState();
}

class _BibazaState extends State<Bibaza> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<IbibazoBibazaModel?>?>.value(
          value: IbibazoBibazaService().ibibazoBibaza,
          initialData: const [],
          catchError: (context, error) => const [],
        ),
      ],
      child: Consumer<List<IbibazoBibazaModel?>?>(
          builder: (context, ibibazoBibaza, child) {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 71, 103, 158),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: AppBarItsindire(),
            ),
            body: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(Color(0xFFFFBD59)),
              ),
              child: Scrollbar(
                child: ListView(children: <Widget>[
                  const GradientTitle(
                      title: 'IBIBAZO ABANYESHURI BIBAZA',
                      icon: 'assets/images/ibibazo_bibaza.svg'),
                  const Description(
                      text:
                          'Ibi ni ibibazo abanyeshuli bibaza ndetse n\'ibyo batubaza cyane.'),
                  if (ibibazoBibaza == null || ibibazoBibaza.isEmpty)
                    const LoadingWidget()
                  else
                    for (var i = 0; i < ibibazoBibaza.length; i++)
                      Faq(
                          question: ibibazoBibaza[i]?.question ?? '',
                          answer: ibibazoBibaza[i]?.answer ?? '',
                          qIcon: 'assets/images/question.svg',
                          aIcon: 'assets/images/answer.svg'),
                ]),
              ),
            ),
            bottomNavigationBar: const RebaIbiciro());
      }),
    );
  }
}
