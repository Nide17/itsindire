import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/ifatabuguzi.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/auth/iyandikishe.dart';
import 'package:tegura/screens/ibiciro/processing_ishyura.dart';

class Subscription extends StatelessWidget {
  final String title;
  final IfatabuguziModel ifatabuguzi;
  final String curWidget;

  const Subscription(
      {super.key,
      required this.title,
      required this.ifatabuguzi,
      required this.curWidget});

  @override
  Widget build(BuildContext context) {
    // USER
    final usr = Provider.of<UserModel?>(context);

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        // TEXT WIDGET TO DISPLAY THE TEXT
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFFFBD59),
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: curWidget == '_IbiciroState'
                        ? const Color.fromARGB(255, 62, 103, 126)
                        : const Color.fromARGB(255, 43, 120, 236),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TITLE
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.016,
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: curWidget == '_IbiciroState'
                                ? Colors.white
                                : const Color.fromARGB(255, 14, 13, 13),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      // BOTTOM BORDER OF THE ABOVE SECTION
                      Container(
                        decoration: BoxDecoration(
                            color: curWidget == '_IbiciroState'
                                ? const Color.fromARGB(255, 25, 22, 199)
                                : const Color.fromARGB(255, 187, 189, 99),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            )),
                        child: Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Time: ${ifatabuguzi.igihe.toUpperCase()} \n\nPrice: ${ifatabuguzi.igiciro} RWF     ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.032,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: curWidget == '_IbiciroState'
                                          ? '${ifatabuguzi.igiciro * 2} RWF'
                                          : '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.032,
                                        color: curWidget == '_IbiciroState'
                                            ? const Color(0xFFFAD201)
                                            : const Color.fromARGB(
                                                255, 14, 13, 13),
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                        decorationThickness: 4.0,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.038,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),

                            // ISHYURA BUTTON
                            curWidget == '_IbiciroState'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00CCE5),
                                          border: Border.all(
                                            color: const Color(0xFF00CCE5),
                                            width: 4.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(0, 7),
                                              blurRadius: 4,
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          // NAVIGATE TO THE CHILD PAGE
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return usr != null
                                                  ? ProcessingIshyura(
                                                      ifatabuguzi: ifatabuguzi)
                                                  : const Iyandikishe(
                                                      message:
                                                          "Register first, then pay and start learning!",
                                                    );
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 0.05),
                                            child: Text(
                                              'PAY NOW',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                      ),
                                    ],
                                  )
                                : const Row(
                                    children: [],
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // HARIMO RECTANGLE
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 8.0),
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'INCLUDES:',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                ),

                // TEXT CONTAINER
                Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(
                    color: curWidget == '_IbiciroState'
                        ? const Color(0xFF00CCE5)
                        : const Color(0xFF00A651),
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
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: ListView(
                      children: [
                        // ORDERED LIST OF IBIRIMO
                        ifatabuguzi.ibirimo.isNotEmpty
                            ? Column(
                                children: ifatabuguzi.ibirimo
                                    .asMap()
                                    .entries
                                    .map((entry) => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${entry.key + 1}. ${entry.value}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.038,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              )
                            : const Text(''),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          ifatabuguzi.ubusobanuro,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }
}
