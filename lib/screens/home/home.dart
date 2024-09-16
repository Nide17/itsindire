import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tegura/screens/utilities/my_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
        
        // CHILDREN OF THE COLUMN WIDGET
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Text(
            "Mwiriwe neza!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0,
                8.0), // Add 16.0 pixels of padding to all sides
            child: Text(
              "Iga amategeko y'umuhanda utavunitse kandi udahenzwe!",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // BOTTOM BORDER OF THE ABOVE SECTION
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: 8.0,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0,
                8.0),
            child: Text(
              "Amasomo ateguwe muburyo bufasha umunyeshuri gusobanukirwa neza amategeko y'umuhanda ndetse agategurwa kuzakora ikizamini cya provisoire agatsinda ntankomyi!",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // BOTTOM BORDER OF THE ABOVE SECTION
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: MediaQuery.of(context).size.height * 0.016,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0,
                8.0), // Add 16.0 pixels of padding to all sides
            child: Text(
              "Kanda aha utangire kwiga",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // DOWN ARROW ICON SVG
          SvgPicture.asset(
            'assets/images/down_arrow.svg',
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // IGA ROUNDED GREEN BUTTON WITH YELLOW TEXT
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/iga');
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(124, 32),
                backgroundColor: const Color(0XFF00A651),
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
                  color: const Color(0xFFFFBD59),
                ),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
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

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // DOWN ARROW ICON SVG
          SvgPicture.asset(
            'assets/images/down_arrow.svg',
            height: MediaQuery.of(context).size.height * 0.04,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // IBICIRO ROUNDED GREEN BUTTON WITH YELLOW TEXT
            Center(
              child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ibiciro');
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(124, 32),
                backgroundColor: const Color(0XFF00A651),
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
                  color: const Color(0xFFFFBD59),
                ),
              ),
                      ),
            ),
        ],
      ),
    );
  }
}
