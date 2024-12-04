import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String text;
  const Description({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: _getPadding(context),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: _getTextStyle(context),
        ),
      ),
      Container(
        color: const Color(0xFF000000),
        height: MediaQuery.of(context).size.height * 0.01,
      ),
    ]);
  }

  EdgeInsets _getPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.05,
      horizontal: MediaQuery.of(context).size.width * 0.05,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.05,
      color: const Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w600,
    );
  }
}
