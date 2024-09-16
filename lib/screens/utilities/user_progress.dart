import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserProgress extends StatelessWidget {
  // INSTANCE VARIABLES
  double percent = 0.0;
  String title = "";
  String description = "";

  UserProgress(
      {super.key,
      required this.percent,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFF2C64C6),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.04,
        ),
        child: Column(
          children: [
            // TITLE
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // BOTTOM BORDER OF THE ABOVE SECTION
            Container(
              color: const Color(0xFFFFBD59),
              height: MediaQuery.of(context).size.height * 0.009,
            ),

            // VERTICAL SPACE
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),

            // DESCRIPTION
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  color: Colors.white,
                ),
              ),
            ),

            // VERTICAL SPACE
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),

            // PROGRESS BAR WITH CTA BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PROGRESS BAR
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.4,
                  animation: true,
                  lineHeight: MediaQuery.of(context).size.height * 0.032,
                  animationDuration: 2500,
                  percent: percent,
                  center: Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                  barRadius: const Radius.circular(16.0),
                  backgroundColor: const Color(0xFF494F56),
                  progressColor: percent > 0.5
                      ? const Color(0xFF00A651)
                      : const Color(0xFFFF3131),
                ),

                // CTA BUTTON
                if (percent != 1.0)
                  GestureDetector(
                    // NAVIGATE TO IGA
                    onTap: () {
                      Navigator.pushNamed(context, '/iga');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.033,
                      decoration: BoxDecoration(
                        color: const Color(0XFF00CCE5),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          (percent == 0.0) ? "TANGIRA" : "KOMEZA",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
