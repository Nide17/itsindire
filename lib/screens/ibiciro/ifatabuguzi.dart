import 'package:flutter/material.dart';

class Ifatabuguzi extends StatelessWidget {
  // INSTANCE VARIABLES
  final int umubare;
  final String igihe;
  final String igiciro;
  final String detailsList;
  final String detailsText;

  // CONSTRUCTOR
  const Ifatabuguzi(
      {super.key,
      required this.umubare,
      required this.igihe,
      required this.igiciro,
      required this.detailsList,
      required this.detailsText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        // TEXT WIDGET TO DISPLAY THE TEXT
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0,
              12.0), // Add 16.0 pixels of padding to all sides
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 51, 91, 112),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TITLE
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 12.0),
                      child: Text(
                        'IFATABUGUZI RYA $umubare',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.038,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    // BOTTOM BORDER OF THE ABOVE SECTION
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0500E5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Igihe: $igihe \n\nIgiciro: $igiciro',
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),

                          // ISHYURA BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00CCE5),
                                  border: Border.all(
                                    color: const Color(0xFF00CCE5),
                                    width: 4.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0, 7),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 0.05),
                                  child: Text(
                                    'ISHYURA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                              // VERTICAL SPACE
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // HARIMO RECTANGLE
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: BoxDecoration(
                  // THE GRADIENT
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF00CCE5),
                      Color(0xFF0500E5),
                    ],
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 4.0,
                  ),
                ),
                child: Text(
                  'HARIMO:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),

              // TEXT CONTAINER
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF00CCE5),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 7),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: ListView(
                    children: [
                      Text(
                        detailsList,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.038,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        detailsText,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.038,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
