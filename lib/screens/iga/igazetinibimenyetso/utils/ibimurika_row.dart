import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class IbimurikaRow extends StatelessWidget {
  final String title;
  final String txt;
  final String imgUrl;
  final String color;
  const IbimurikaRow(
      {super.key,
      required this.title,
      required this.txt,
      required this.imgUrl,
      required this.color});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = formatText(txt);

    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.048,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: color == 'green'
              ? Colors.green
              : color == 'red'
                  ? Colors.red
                  : const Color.fromARGB(255, 250, 229, 44),
          width: MediaQuery.of(context).size.width * 0.008,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Container(
            //   icyapa img
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.24,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Center(
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imgUrl,
                    fit: BoxFit.cover,
                    width: 100)),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.024,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.width * 0.02,
              bottom: MediaQuery.of(context).size.width * 0.02,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF157A6E),
                  width: MediaQuery.of(context).size.width * 0.008,
                ),
              ),
            ),
            //   icyapa text
            width: MediaQuery.of(context).size.width * 0.7,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  spans[0],
                ],
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<TextSpan> formatText(String input) {
  List<TextSpan> formattedText = [];
  // Match all text inside: single quotes, double quotes, backticks, ”, “, «, »
  // RegExp regex = RegExp(r'''(['"`“”«»“”])(.*?)\1''');
  // full form
  RegExp regex = RegExp(
      r'«(.*?)» | "(.*?)" | “(.*?)” | ‘(.*?)’ | ‘(.*?)’ | `(.*?)` | (.*?)\n');
  Iterable<Match> matches = regex.allMatches(input);

  int start = 0;
  for (Match match in matches) {
    // Add non-bold text
    if (match.start > start) {
      formattedText.add(TextSpan(text: input.substring(start, match.start)));
    }

    // Add bold text inside quotes
    formattedText.add(TextSpan(
      text: match.group(0),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));

    start = match.end;
  }

  // Add the remaining non-bold text
  if (start < input.length) {
    formattedText.add(TextSpan(text: input.substring(start)));
  }

  return formattedText;
}
