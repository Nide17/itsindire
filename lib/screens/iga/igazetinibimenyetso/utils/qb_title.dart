import 'package:flutter/material.dart';

class QBTitle extends StatelessWidget {
  final String title;

  const QBTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.04,
      ),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
