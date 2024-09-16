import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/screens/iga/gradient_title.dart';

class ContentDetails extends StatelessWidget {
// INSTANCE VARIABLES
  final IsomoModel isomo;
  final int pageNumber = 1;
  final int? limit = 1;
  final int? skip = 1;

  // CONSTRUCTOR
  const ContentDetails({
    super.key,
    required this.isomo,
  });

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // PROVIDERS
    // GET THE INGINGOS
    final ingingos = Provider.of<List<IngingoModel>?>(context);
    print('INGINGOS: $ingingos');

    // RETURN THE WIDGETS
    return Column(children: <Widget>[
      // 1. GRADIENT TITLE
      Container(
        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
        // height: MediaQuery.of(context).size.height * 0.1,
        decoration: const BoxDecoration(
          color: Color(0xFF5B8BDF),
        ),
        child: GradientTitle(title: isomo.title, icon: '', marginTop: 8.0),
      ),
      // 3. INGINGO LIST
      Container(
          decoration: const BoxDecoration(
            color: Color(0xFFD9D9D9),
          ),
          // 68% OF THE SCREEN HEIGHT
          height: MediaQuery.of(context).size.height * 0.64,
          child: ListView.builder(
            itemCount: ingingos?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Align(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
                child: Column(
                  children: [
                    // isomo.introText IF ANY, ON THE FIRST INGINGO
                    if (index == 0 && isomo.introText != '')
                      Text(
                        '${isomo.introText}\n\n',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                    Text.rich(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.027),
                      TextSpan(
                          text:
                              '${ingingos?[index].id}. ${ingingos?[index].title} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            // INGINGO TEXT
                            TextSpan(
                                text: '${ingingos?[index].text}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                            // IF INGINGO HAS insideTitle
                            if (ingingos?[index].insideTitle != null &&
                                ingingos?[index].insideTitle != '')
                              TextSpan(
                                text: '\n\n${ingingos?[index].insideTitle}',
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                          ]),
                    ),
                    // IF INGINGO HAS OPTIONS USING ABOVE METHOD
                    if (ingingos?[index].options != null &&
                        ingingos?[index].options != [])
                      Column(
                        children: List<Widget>.generate(
                          ingingos![index].options.length,
                          (optionIndex) {
                            // ONE OPTION
                            Option option = Option.fromJson(
                                ingingos[index].options[optionIndex]);

                            // RETURN THE WIDGETS OF THE OPTIONS
                            return Column(children: [
                              Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    children: [
                                      // OPTION TITLE
                                      TextSpan(
                                        text: '${option.title}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // OPTION TEXT IF ANY
                                      if (option.text != null)
                                        TextSpan(
                                          text: ' ${option.text}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                    ],
                                  )),

                              // OPTION IMAGE IF ANY
                              if (option.imageUrl != null &&
                                  option.imageUrl != '')
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0.0, 12.0, 0.0, 14.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set the desired border radius
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.5), //COLOR OF SHADOW
                                            spreadRadius:
                                                5, //SPREAD RADIUS OF SHADOW
                                            blurRadius:
                                                7, //BLUR RADIUS OF SHADOW
                                            offset: const Offset(
                                                0, 3), //OFFSET OF SHADOW
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set the desired border radius
                                        child: Image.network(
                                          option.imageUrl!,
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ]);
                          },
                        ).toList(),
                      ),

                    // INGINGO NB IF ANY
                    if (ingingos?[index].nb != null &&
                        ingingos?[index].nb != '')
                      Text.rich(
                        textAlign: TextAlign.left,
                        TextSpan(
                          children: [
                            const TextSpan(
                                text: '\nNB: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '${ingingos?[index].nb}'),
                          ],
                        ),
                      ),

                    // INGINGO FB STORAGE NETWORK IMAGE IF ANY
                    if (ingingos?[index].imageUrl != null &&
                        ingingos?[index].imageUrl != '')
                      Column(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the desired border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.8), // Set the shadow color
                                  spreadRadius: 2.0, // Set the spread radius
                                  blurRadius: 5.0, // Set the blur radius
                                  offset: const Offset(
                                      0, 3), // Set the shadow offset
                                ),
                              ],
                            ),
                            // BORDER RADIUS OF THE IMAGE
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the desired border radius
                              child: Image.network(
                                ingingos?[index].imageUrl ?? '',
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // INGINGO IMAGE CAPTION IF ANY
                          if (ingingos?[index].imageDesc != null &&
                              ingingos?[index].imageDesc != '')
                            Text(
                              ingingos?[index].imageDesc ?? '',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                        ],
                      ),

                    // ISOMO CONCLUSION IF ANY
                    if (index == ingingos!.length - 1 && isomo.conclusion != '')
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
                        child: Text(
                          isomo.conclusion,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                  ],
                ),
              ));
            },
          )),
    ]);
  }
}
