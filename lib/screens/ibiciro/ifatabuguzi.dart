import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/models/ifatabuguzi.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/screens/auth/iyandikishe.dart';
import 'package:itsindire/screens/ibiciro/processing_ishyura.dart';

class Ifatabuguzi extends StatelessWidget {
  final int index;
  final IfatabuguziModel ifatabuguzi;
  final String curWidget;

  const Ifatabuguzi(
      {super.key,
      required this.index,
      required this.ifatabuguzi,
      required this.curWidget});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel?>(context);
    final bool isUrStudent = profile?.urStudent ?? false;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFFFBD59),
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.02),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: curWidget == '_IbiciroState'
                        ? const Color.fromARGB(255, 62, 103, 126)
                        : const Color.fromARGB(255, 43, 120, 236),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.016,
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Text(
                          isUrStudent
                              ? 'PACK NO ${index + 1}'
                              : 'IFATABUGUZI RYA ${index + 1}',
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width * 0.038,
                            color: curWidget == '_IbiciroState'
                                ? Colors.white
                                : const Color.fromARGB(255, 14, 13, 13),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: curWidget == '_IbiciroState'
                              ? const Color.fromARGB(255, 25, 22, 199)
                              : const Color.fromARGB(255, 187, 189, 99),
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02),
                        ),
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
                                      text: isUrStudent == true
                                          ? 'Period: ${ifatabuguzi.igihe.toUpperCase()} \n\nPrice: ${ifatabuguzi.igiciro} RWF     '
                                          : 'Igihe: ${ifatabuguzi.igihe.toUpperCase()} \n\nIgiciro: ${ifatabuguzi.igiciro} RWF     ',
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
                            curWidget == '_IbiciroState'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00CCE5),
                                          border: Border.all(
                                            color: const Color(0xFF00CCE5),
                                            width: 4.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
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
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return FirebaseAuth.instance
                                                          .currentUser !=
                                                      null
                                                  ? ProcessingIshyura(
                                                      ifatabuguzi: ifatabuguzi)
                                                  : Iyandikishe(
                                                      message: isUrStudent ==
                                                              true
                                                          ? "Register first, then pay and start learning!"
                                                          : "Banza wiyandikishe, ubone kwishyura wige!",
                                                    );
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 0.05),
                                            child: Text(
                                              isUrStudent == true
                                                  ? 'PAY NOW'
                                                  : 'ISHYURA',
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
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.004),
                  decoration: BoxDecoration(
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
                      isUrStudent == true ? 'INCLUDES:' : 'HARIMO:',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                ),
                Container(
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
                    child: Column(
                      children: [
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Text(
                            ifatabuguzi.ubusobanuro,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
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
