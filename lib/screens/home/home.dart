import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/utilities/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER PROFILE
    final profile = Provider.of<ProfileModel?>(context);
    final usr = Provider.of<UserModel?>(context);

    // TEXT TO DISPLAY ON THE SCREEN AS WELCOME - TIME SENSITIVE
    String msg = DateTime.now().hour < 12 ? 'Mwaramutse' : 'Mwiriwe';
    String? displayMsg =
        (usr != null && profile != null && profile.username != '')
            ? '$msg, ${capitalizeWords(profile.username!.split(' ')[0])}!'
            : '$msg!';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 71, 103, 158),

      // APP BAR
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarTegura(),
      ),

      // PAGE BODY
      body: ListView(
        // CHILDREN OF THE COLUMN WIDGET
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
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

          // TEXT WIDGET TO DISPLAY THE TEXT
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

          // BOTTOM BORDER OF THE ABOVE SECTION
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: MediaQuery.of(context).size.height * 0.008,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
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

          // BOTTOM BORDER OF THE ABOVE SECTION
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: MediaQuery.of(context).size.height * 0.008,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.048,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Text(
            "Kanda aha utangire kwiga",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),

          // DOWN ARROW ICON SVG
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

          // IGA ROUNDED GREEN BUTTON WITH YELLOW TEXT
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
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: Text(
                'IGA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.032,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Text(
            "Kanda aha ubone ibiciro byo kwiga",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          // DOWN ARROW ICON SVG
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

          // IBICIRO ROUNDED GREEN BUTTON WITH YELLOW TEXT
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
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: Text(
                'IBICIRO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
