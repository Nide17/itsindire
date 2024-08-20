import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCircle extends StatelessWidget {
  final double percent;
  final String progress;
  final User? usr;

  const ProgressCircle(
      {super.key,
      required this.percent,
      required this.progress,
      required this.usr});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: usr != null
                ? MediaQuery.of(context).size.height * 0.2
                : MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. TEXT OUTPUT
                if (usr != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                    child: Text(progress,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        )),
                  )
                else
                  Container(),

                // 2. CIRCULAR PERCENT INDICATOR
                CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width * 0.14,
                  lineWidth: MediaQuery.of(context).size.width * 0.035,
                  animation: true,
                  animationDuration: 1000,
                  restartAnimation: true,
                  percent: percent,
                  center: Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  progressColor: const Color(0xFF9D14DD),
                  backgroundColor: const Color(0xFFBCCCBF),
                  footer: usr == null
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03),
                          child: Text(
                            progress,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
