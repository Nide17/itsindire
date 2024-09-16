import 'package:flutter/material.dart';

class Amanota extends StatelessWidget {
  // INSTANCE VARIABLES
  final int score;
  final int maxScore;

  // CONSTRUCTOR
  const Amanota({super.key, required this.score, required this.maxScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 233, 232, 232),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.fromBorderSide(BorderSide(
          color: Color.fromARGB(255, 196, 196, 196),
        )),
        boxShadow: [
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
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$score/$maxScore",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    color:
                        (score / maxScore) >= 0.6 ? Colors.green : Colors.red,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text((score / maxScore) >= 0.6 ? "Watsinze" : "Watsinzwe",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    color: Colors.black87,
                  )),
            ],
          )),
    );
  }
}
