import "package:flutter/material.dart";
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/cta_link.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/firebase_services/auth.dart';

class Wibagiwe extends StatefulWidget {
  const Wibagiwe({super.key});

  @override
  State<Wibagiwe> createState() => _WibagiweState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _WibagiweState extends State<Wibagiwe> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String output = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 71, 103, 158),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(58.0),
            child: AppBarItsindire(),
          ),
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
                const GradientTitle(
                    title: 'WIBAGIWE IJAMBOBANGA?',
                    icon: 'assets/images/wibagiwe.svg'),

                // 2. DESCRIPTION
                const Description(
                    text:
                        'Andika imeyili wohereze niba wibagiwe ijambobanga ryawe, tugufashe kubona irindi.'),

                // CENTERED IMAGE
                loading == true
                    ? const LoadingWidget()
                    : Row(
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
                        // EMAIL INPUT
                        DefaultInput(
                          placeholder: 'Imeyili',
                          validation: 'Injiza imeyili yawe hano!',
                          // ON CHANGED
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),

                        // CTA BUTTON
                        CtaButton(
                          text: 'Bona ijambobanga rishya',

                          // ON PRESSED
                          onPressed: () async {
                            // SET LOADING TO TRUE
                            setState(() => loading = true);

                            // VALIDATE FORM
                            if (_formKey.currentState!.validate()) {
                              dynamic resetResult =
                                  await authState.resetPassword(email);

                              if (resetResult == null) {
                                setState(() => output =
                                    'Imeyili ntibigenze, subira ugerageze!');
                              } else {
                                setState(() => output =
                                    'Kurikiza amabwiriza aje kuri imeyili yawe!');

                                // GO TO SIGN IN PAGE
                                if (context.mounted) {
                                  // SET LOADING TO FALSE
                                  setState(() => loading = false);
                                  Navigator.pushNamed(context, '/injira');
                                }
                              }

                              // SHOW SNACKBAR IF OUTPUT IS NOT EMPTY
                              if (output.isNotEmpty && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      output,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 10),
                                    backgroundColor: const Color(0xFFFFBD59),
                                  ),
                                );
                              }
                            }
                          },
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        // CTA LINK
                        const CtaAuthLink(
                          text1: 'Niba wariyandikishije, ',
                          text2: 'injira',
                          color1: Color.fromARGB(255, 255, 255, 255),
                          color2: Color.fromARGB(255, 0, 27, 116),
                          route: '/injira',
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        // CTA LINK
                        const CtaAuthLink(
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
              ],
            ),
          ));
    });
  }
}
