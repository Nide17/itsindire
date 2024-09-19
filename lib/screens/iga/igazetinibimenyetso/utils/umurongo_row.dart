import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class UmurongoRow extends StatelessWidget {
  final String title;
  final String txt;
  final String topTxt;
  final String imgUrl;
  const UmurongoRow(
      {required this.title,
      required this.txt,
      required this.topTxt,
      required this.imgUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spansText = formatText(txt);
    List<TextSpan> spansTopTxt = formatText(topTxt);

    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 230, 230),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff16A799),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          //  umurongo title
          title == ''
              ? Container()
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    // img & title
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.048,
                            0,
                            MediaQuery.of(context).size.width * 0.024,
                            0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius as needed
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image:
                                'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/imirongo%2Ftitle.png?alt=media&token=ea01425f-45fa-4187-a0b6-6a6d168daf4d',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),

                      //   umurongo title
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width * 0.042,
                            fontWeight:
                                MediaQuery.of(context).size.width * 0.04 > 20
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          //  umurongo top text
          topTxt == ''
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.024,
                  ),
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.width * 0.02,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,

                  //   umurongo top text
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: spansTopTxt,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                ),

          //   umurongo img
          imgUrl == ''
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imgUrl,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.cover,
                  ),
                ),

          //   umurongo text
          txt == ''
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.024,
                  ),
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.width * 0.02,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,

                  //   umurongo text
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: spansText,
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
  RegExp regex =
      RegExp(r'«(.*?)» | "(.*?)" | “(.*?)” | ‘(.*?)’ | ‘(.*?)’ | `(.*?)`');
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
