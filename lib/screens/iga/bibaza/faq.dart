import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Faq extends StatelessWidget {
  // INSTANCE VARIABLES
  final String question;
  final String answer;
  final String qIcon;
  final String aIcon;

  // CONSTRUCTOR
  const Faq(
      {super.key,
      required this.question,
      required this.answer,
      required this.qIcon,
      required this.aIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HORIZONTAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),

        // CONTENT
        Row(
          children: [
            // HORIZONTAL SPACE
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.005,
            ),

            // SVG ICON
            SvgPicture.asset(
              qIcon,
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            // HORIZONTAL SPACE
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.005,
            ),

            // TEXT WIDGET
            Container(
              width: MediaQuery.of(context).size.width * 0.86,

              // STYLING
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),

                // THE GRADIENT
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.2677, 0.8325],
                  colors: [
                    Color(0xFFFFDE59),
                    Color(0xFFFFB452),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.024,
                    horizontal: MediaQuery.of(context).size.width * 0.032 
                ),
                child: Text(question,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        ),

        // HORIZONTAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.032,
        ),

        // CONTENT
        Row(
          children: <Widget>[
            // HORIZONTAL SPACE
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),

            // SVG ICON
            SvgPicture.asset(
              aIcon,
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            // HORIZONTAL SPACE
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),

            // TEXT WIDGET
            Container(
              width: MediaQuery.of(context).size.width * 0.8,

              // STYLING
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                // THE GRADIENT
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.2677, 0.8325],
                  colors: [
                    Color(0xFF0097B2),
                    Color(0xFF7ED957),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(answer,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
