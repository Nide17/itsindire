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
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (usr != null)
            Expanded(
              child: Text(progress,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                  textAlign: TextAlign.center), // Center the text
            )
          else
            SizedBox.shrink(),
          Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,),
            child: CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width * 0.12,
                lineWidth: MediaQuery.of(context).size.width * 0.032,
                animation: true,
                animationDuration: 800,
                restartAnimation: false,
                percent: percent,
                center: Text(
                  '${(percent * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.068,
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
                            MediaQuery.of(context).size.width * 0.05),
                        overflow: TextOverflow.visible,
                      ),
                      )
                    : SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
