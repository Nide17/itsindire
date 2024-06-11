import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QBAppBar extends StatelessWidget {
  const QBAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFD9D9D9),
      toolbarHeight: MediaQuery.of(context).size.height * 0.16,
      title: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF157A6E),
              width: MediaQuery.of(context).size.height * 0.005,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // THE QUIZ-BLOG LOGO
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.02,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF157A6E),
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Quiz-Blog\n',
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Skills & Education',
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: MediaQuery.of(context).size.width * 0.018,
                          fontWeight: FontWeight.bold,
                          height: MediaQuery.of(context).size.height * 0.0012,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Text(
              'In collaboration with',
              style: TextStyle(
                color: const Color(0xFF000000),
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),

            // THE OTHER CONTENTS OF THE TOP BAR
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.005,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF157A6E),
                              width: MediaQuery.of(context).size.width * 0.009,
                            ),
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
                          ),
                          child: Row(
                            children: [
                              // ARRAY OF WIDGETS - ROW
                              SvgPicture.asset(
                                'assets/images/car.svg',
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                color: const Color(0xFF157A6E),
                              ),

                              // SPACING BETWEEN THE TWO WIDGETS
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.008,
                              ),
                              Text('Tegura.rw', // TEXT WIDGET
                                  style: TextStyle(
                                    color: const Color(0xFFFFBD59),
                                    fontWeight: FontWeight.w900,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.032,
                                  )),
                                  // SPACING BETWEEN THE TWO WIDGETS
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.008,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Iga, Umenye, Utsinde!',
                          style: TextStyle(
                            color: const Color(0xFF00A1DE),
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.bold,
                            height: MediaQuery.of(context).size.height * 0.002,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/phone.svg',
                      height: MediaQuery.of(context).size.height * 0.026,
                    ),
                    Text(
                      '\t\t+250 794 033 360',
                      style: TextStyle(
                        color: const Color(0xFF000000),
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
      floating: true,
      pinned: true,
      snap: true,
    );
  }
}
