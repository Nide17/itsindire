import 'package:flutter/material.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:transparent_image/transparent_image.dart';

class OptionContent extends StatelessWidget {
  final Option? option;

  const OptionContent({super.key, this.option});

  @override
  Widget build(BuildContext context) {
    // SPLIT THE TEXT INTO PARTS AND CREATE A LIST OF TEXT SPANS TO BE RETURNED
    final parts = option?.text?.split('*') ?? [];
    final spans = <TextSpan>[];

    // CREATE TEXTSPANS WITH DIFFERENT STYLES FOR EACH PART OF THE TEXT
    for (var i = 0; i < parts.length; i++) {
      // IF THE PART IS EVEN, IT'S A NORMAL TEXT
      final isBold = i % 2 == 1;

      // ADD THE TEXTSPAN TO THE LIST OF TEXTSPANS
      spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)));
    }

    return Column(children: [
      // IF OPTION HAS title
      if (option?.title != null && option?.title != '')
        // SIZEBOX
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.015),
            child: Row(
              children: [
                // IF OPTION HAS leftImageUrl
                if (option?.leftImageUrl != null && option?.leftImageUrl != '')
                  Flexible(
                    // OCCUPY 1/5 OF THE SPACE
                    flex: 1,
                    // LOOSE FIT
                    fit: FlexFit.loose,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.025),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: option!.leftImageUrl!,
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.001,
                        ),
                      ),
                    ),
                  ),

                Flexible(
                  // OCCUPY 4/5 OF THE SPACE
                  flex: 4,
                  child: Text.rich(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025),
                      TextSpan(
                        children: [
                          // OPTION TITLE
                          if (option?.title != null && option?.title != '')
                            TextSpan(
                              text: '${option?.title}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          // OPTION TEXT IF ANY
                          if (option?.text != null)
                            TextSpan(
                              children: spans,
                            ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),

      // OPTION IMAGE IF ANY
      if (option?.imageUrl != null && option?.imageUrl != '')
        Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Set the desired border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //COLOR OF SHADOW
                    spreadRadius: 5, //SPREAD RADIUS OF SHADOW
                    blurRadius: 7, //BLUR RADIUS OF SHADOW
                    offset: const Offset(0, 3), //OFFSET OF SHADOW
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10.0), // Set the desired border radius
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: option!.imageUrl!,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
    ]);
  }
}
