import 'package:flutter/material.dart';
import 'package:tegura/screens/utilities/user_progress.dart';

class ViewLoggedIn extends StatelessWidget {
  // INSTANCE VARIABLES
  double progress;
  String description;
  String title;

  // CONSTRUCTOR
  ViewLoggedIn(
      {super.key,
      required this.progress,
      required this.description,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserProgress(
          title: title,
          description: description,
          percent: progress,
        ),

        // VERTICAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
      ],
    );
  }
}
