import "package:flutter/material.dart";
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import "package:tegura/services/auth.dart";

class Iyandikishe extends StatefulWidget {
  const Iyandikishe({Key? key}) : super(key: key);

  @override
  State<Iyandikishe> createState() => _IyandikisheState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _IyandikisheState extends State<Iyandikishe> {
  // AUTH SERVICE INSTANCE
  final AuthService _authInstance = AuthService();
  final _formKey = GlobalKey<FormState>();

  // FORM FIELD VALUES STATE
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarTegura(),
        ),

        // PAGE BODY
        body: ListView(
          children: [
            // 1. GRADIENT TITLE
            const GradientTitle(
                title: 'IYANDIKISHE', icon: 'assets/images/iyandikishe.svg'),

            // 2. DESCRIPTION
            const Description(
                text:
                    'Iyandikishe ubundi, wige, umenye ndetse utsindire provisoire!'),

            // CENTERED IMAGE
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/house_keys.png',
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
                    DefaultInput(
                      placeholder: 'Izina',
                      validation: 'Injiza izina ryawe!',

                      // ON CHANGED
                      onChanged: (val) {
                        setState(() => username = val);
                      },
                    ),

                    // EMAIL
                    DefaultInput(
                      placeholder: 'Imeyili',
                      validation: 'Injiza imeyili yawe!',

                      // ON CHANGED
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                    // IJAMBOBANGA
                    DefaultInput(
                      placeholder: 'Ijambobanga',
                      validation: 'Injiza ijambobanga!',

                      // ON CHANGED
                      onChanged: (val) {
                        setState(() => password = val);
                      },

                      // OBSCURE TEXT
                      obscureText: true,
                    ),

                    // CTA BUTTON
                    CtaButton(
                      text: 'Iyandikishe',

                      // ON PRESSED
                      onPressed: () async {
                        // VALIDATE FORM
                        if (_formKey.currentState!.validate()) {
                          
                          // REGISTER USER
                          dynamic resSignUp = await _authInstance
                              .registerWithEmailAndPassword(username, email, password);

                          // CHECK IF USER IS REGISTERED
                          if (resSignUp == null) {
                            setState(
                                () => error = 'Please supply a valid email');
                          } else {
                            // LOGOUT USER
                            await _authInstance.logOut();

                            // REDIRECT TO LOGIN PAGE AFTER SUCCESSFUL REGISTRATION
                            if(!mounted) return;
                            
                            Navigator.pushReplacementNamed(context, '/injira');
                          }
                        }
                      },
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
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),

                    // UR STUDENT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C64C6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                )),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/ur-student');
                            },
                            child: const Text(
                              'Register as UR student',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),

                        // HORIZONTAL SPACE
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // PNG IMAGE ASSET
                        Image.asset(
                          'assets/images/50off.png',
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
