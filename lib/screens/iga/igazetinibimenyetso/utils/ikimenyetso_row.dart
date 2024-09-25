import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class IkimenyetsoRow extends StatelessWidget {
  final String txt;
  final String imgUrl;
  const IkimenyetsoRow({required this.txt, required this.imgUrl, super.key});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = formatText(txt);
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _showZoomDialog(context, imgUrl);
            },
            child: Container(
              //   icyapa img
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.24,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Center(
                  child: FadeInImage.memoryNetwork(
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: kTransparentImage,
                      image: imgUrl,
                      fit: BoxFit.cover,
                      width: 100)),
            ),
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
                children: spans,
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

  void _showZoomDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            child: FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: kTransparentImage,
              image: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

List<TextSpan> formatText(String input) {
  List<TextSpan> formattedText = [];
  // Match all text inside: single quotes, double quotes, backticks, ”, “, «, »
  // RegExp regex = RegExp(r'''(['"`“”«»“”])(.*?)\1''');
  // full form
  RegExp regex = RegExp(
      r'«(.*?)» | “(.*?)” | “(.*?)” | "(.*?)" | “(.*?)” | ‘(.*?)’ | ‘(.*?)’ | `(.*?)` | (.*?)\n');
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
