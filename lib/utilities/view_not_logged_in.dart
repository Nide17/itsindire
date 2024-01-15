import 'package:flutter/material.dart';

class ViewNotLoggedIn extends StatelessWidget {
  const ViewNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 4. TEXT Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            'Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.white,
            ),
          ),
        ),

        // 5. ADD 10.0 PIXELS OF SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),

        // 6. BUTTONS FOR INJIRA & IYANDIKISHE
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 6.1. INJIRA
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/injira');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                  backgroundColor: const Color(0xFF00CCE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                      elevation: 8.0,
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Text(
                  'Injira',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),

              // 6.2. IYANDIKISHE
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/iyandikishe');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                  backgroundColor: const Color(0xFF00CCE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  elevation: 8.0,
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Text(
                  'Iyandikishe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
