import 'package:flutter/material.dart';
import 'package:itsindire/models/isuzuma_score.dart';

class Amanota extends StatelessWidget {
  final IsuzumaScoreModel? userScore;
  const Amanota({super.key, required this.userScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 232, 232),
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.width * 0.02)),
        border: const Border.fromBorderSide(BorderSide(
            color: Color(0xFFFFBD59), width: 2, style: BorderStyle.solid)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(34, 34, 34, 0.247),
            offset: Offset(0, 7),
            blurRadius: 4,
          )
        ],
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.012,
          ),
          child: userScore == null
              ? Text(
                  'Nturarikora',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${userScore?.marks ?? 0}/${userScore?.totalMarks ?? 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: (userScore?.marks ?? 0) /
                                      (userScore?.totalMarks ?? 0) >=
                                  0.6
                              ? Colors.green
                              : Colors.red,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                        (userScore?.marks ?? 0) /
                                    (userScore?.totalMarks ?? 1) >=
                                0.6
                            ? "Watsinze!"
                            : "Watsinzwe!",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: Colors.black87,
                        )),
                  ],
                )),
    );
  }
}
