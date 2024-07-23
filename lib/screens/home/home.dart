import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/utilities/app_bar.dart';

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

      print("\nHome authState._currentProfile: ${authState.currentProfile}");

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
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03,
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Text(
                "Amasomo ateguwe muburyo bufasha umunyeshuri gusobanukirwa neza amategeko y'umuhanda ndetse agategurwa kuzakora ikizamini cya provisoire agatsinda ntankomyi!",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.042,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.048,
            ),
            Text(
              "Kanda aha utangire kwiga",
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/iga-landing');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.06,
                  ),
                  backgroundColor: const Color(0xFF00A651),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
                child: Text(
                  'IGA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: const Color(0xFFFFBD59),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.032,
            ),
            Text(
              "Kanda aha ubone ibiciro byo kwiga",
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ibiciro');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.06,
                  ),
                  backgroundColor: const Color(0xFF00A651),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
                child: Text(
                  'IBICIRO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: const Color(0xFFFFBD59),
                  ),
                ),
              ),
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
