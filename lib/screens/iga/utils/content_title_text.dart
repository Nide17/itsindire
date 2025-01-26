import 'package:flutter/material.dart';

class ContentTitlenText extends StatefulWidget {
  final String? title;
  final String? text;

  const ContentTitlenText({super.key, this.text, this.title});

  @override
  State<ContentTitlenText> createState() => _ContentTitlenTextState();
}

class _ContentTitlenTextState extends State<ContentTitlenText> {
  @override
  Widget build(BuildContext context) {
    // Split the text into parts and create a list of text spans to be returned
    final parts = widget.text?.split('*') ?? [];
    final spans = <TextSpan>[];

    // Create TextSpans with different styles for each part of the text
    for (var i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ));
    }

    return Text.rich(
      TextSpan(
        text: widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        children: spans,
      ),
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
    );
  }
}
