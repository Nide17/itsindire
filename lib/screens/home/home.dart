import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/route_action_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      String msg = DateTime.now().hour < 12 ? 'Mwaramutse' : 'Mwiriwe';
      String username = authState.currentProfile?.username ?? '';
      String? displayMsg = (username != '')
          ? '$msg, ${capitalizeWords(username.split(' ')[0])}!'
          : '$msg!';

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              displayMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Text(
                "Iga amategeko y'umuhanda utavunitse kandi udahenzwe!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.054,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                bottom: BorderSide(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.03,
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Text(
                  "Amasomo ateguwe muburyo bufasha umunyeshuri gusobanukirwa neza amategeko y'umuhanda ndetse agategurwa kuzakora ikizamini cya provisoire, agatsinda ntankomyi!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.042,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            KandaSection(
                titleText: "Kanda aha utangire kwiga",
                btnText: 'KWIGA',
                route: '/iga-landing'),
            KandaSection(
              titleText: 'Kanda aha ubone ibiciro byo kwiga',
              btnText: 'IBICIRO',
              route: '/ibiciro',
            ),
          ],
        ),
      );
    });
  }

  String capitalizeWords(String input) {
    List<String> words = input.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        capitalizedWords
            .add('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
      } else {
        capitalizedWords.add(word);
      }
    }
    return capitalizedWords.join(' ');
  }
}

// Reusable button widget for navigating to the 'Iga' and 'Ibiciro' screens
class KandaSection extends StatelessWidget {
  final String titleText;
  final String btnText;
  final String route;

  const KandaSection(
      {required this.titleText, required this.btnText, required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.032,
        ),
        Text(
          titleText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.016,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: SvgPicture.asset(
            'assets/images/down_arrow.svg',
            height: MediaQuery.of(context).size.height * 0.04,
          ),
        ),
        RouteActionButton(btnText: btnText, route: route)
      ],
    );
  }
}
