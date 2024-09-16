import 'package:flutter/material.dart';

class ContentTitlenText extends StatelessWidget {
  // INSTANCE VARIABLES
  final String? title;
  final String? text;

  // CONSTRUCTOR
  const ContentTitlenText({super.key, this.text, this.title});

  @override
  Widget build(BuildContext context) {
    // SPLIT THE TEXT INTO PARTS AND CREATE A LIST OF TEXT SPANS TO BE RETURNED
    final parts = text?.split('*');
    final spans = <TextSpan>[];

    // CREATE TEXTSPANS WITH DIFFERENT STYLES FOR EACH PART OF THE TEXT
    for (var i = 0; i < parts!.length; i++) {
      // IF THE PART IS EVEN, IT'S A NORMAL TEXT
      final isBold = i % 2 == 1;

      // ADD THE TEXTSPAN TO THE LIST OF TEXTSPANS
      spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)));
    }

    return Text.rich(
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.027),
      TextSpan(
          text: title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: spans),
    );
  }
}
