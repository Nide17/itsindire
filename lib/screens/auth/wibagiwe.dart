import "package:flutter/material.dart";
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/firebase_services/auth.dart';

class Wibagiwe extends StatefulWidget {
  const Wibagiwe({Key? key}) : super(key: key);

  @override
  State<Wibagiwe> createState() => _WibagiweState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _WibagiweState extends State<Wibagiwe> {
  // AUTH SERVICE INSTANCE
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: AppBarTegura(),
        ),

        // PAGE BODY
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff14e4ff), Color(0xFF5B8BDF)],
              stops: [0.01, 0.6],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: ListView(
            children: [
              // 1. GRADIENT TITLE
              const GradientTitle(
                  title: 'WIBAGIWE IJAMBOBANGA?',
                  icon: 'assets/images/wibagiwe.svg'),

              // 2. DESCRIPTION
              const Description(
                  text:
                      'Andika nimero zawe za telephone wohereze niba wibagiwe ijambobanga ryawe, tugufashe kubona irindi.'),

              // CENTERED IMAGE
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/padlock.png',
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ]),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMERO ZA TELEPHONE
                      const DefaultInput(
                        placeholder: 'Nomero za telefone',
                        validation: 'Injiza numero za telefone!',
                      ),

                      // CTA BUTTON
                      CtaButton(
                        text: 'Bona ijambobanga rishya',

                        // ON PRESSED
                        onPressed: () async {
                          // VALIDATE FORM
                          if (_formKey.currentState!.validate()) {
                            print('Validated');
                          } else {
                            print('Not validated');
                          }
                        },
                      ),

                      // VERTICAL SPACE
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      // CTA LINK
                      const CtaLink(
                        text1: 'Niba wariyandikishije, ',
                        text2: 'injira',
                        color1: Color.fromARGB(255, 255, 255, 255),
                        color2: Color.fromARGB(255, 0, 27, 116),
                        route: '/injira',
                      ),

                      // VERTICAL SPACE
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      // CTA LINK
                      const CtaLink(
                        text1: 'Niba utariyandikisha, ',
                        color1: Color.fromARGB(255, 0, 27, 116),
                        color2: Color.fromARGB(255, 255, 255, 255),
                        text2: 'iyandikishe',
                        route: '/iyandikishe',
                      ),
                    ],
                  ),
                ),
              ),

              // ANONYMOUS SIGN IN BUTTON
              Container(
                padding: const EdgeInsets.all(40.0),

                // RAISED BUTTON
                child: ElevatedButton(
                  onPressed: () async {
                    // SIGN IN
                    dynamic result = await _auth
                        .signInAnon(); // DYNAMIC TYPE - CAN USER OR NULL

                    if (result == null) {
                      print('Error signing in');
                    } else {
                      print('Signed in');
                      print(result.uid);
                    }
                  },
                  child: const Text('Sign In Anonymously'),
                ),
              ),
            ],
          ),
        ));
  }
}
