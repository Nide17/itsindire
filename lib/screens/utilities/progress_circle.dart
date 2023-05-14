import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';

class ProgressCircle extends StatelessWidget {

  // PROPERTIES
  double percent = 0.0;
  String progress = "";
  UserModel? usr;

  // CONSTRUCTOR - TO GET THE PERCENT, AUTH STATUS
  ProgressCircle(
      {super.key,
      required this.percent,
      required this.progress,
      required this.usr});

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // print("User:$usr");

    return Center(
      child: Column(
        children: [
          
          SizedBox(
            height: usr != null ? 
            MediaQuery.of(context).size.height * 0.2 : 
            MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. TEXT OUTPUT
                if (usr != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(progress,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        )),
                  )
                else
                  Container(),

                // 2. CIRCULAR PERCENT INDICATOR
                SizedBox(
                  child: CircularPercentIndicator(
                    radius: MediaQuery.of(context).size.width * 0.14,
                    lineWidth: MediaQuery.of(context).size.width * 0.035,
                    animation: true,
                    percent: percent,
                    center: Text(
                      '${(percent * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.width * 0.075,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: const Color(0xFF9D14DD),
                    backgroundColor: const Color(0xFFBCCCBF),
                    
                    footer: usr == null
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.028),
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
                ),
              ],
            ),
          ),

          // 3. ADD 8.0 PIXELS OF SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.009,
          ),
        ],
      ),
    );
  }
}
