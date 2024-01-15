// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/firebase_services/auth.dart';

class Iyandikishe extends StatefulWidget {
  final String? message;
  const Iyandikishe({super.key, this.message});

  @override
  State<Iyandikishe> createState() => _IyandikisheState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _IyandikisheState extends State<Iyandikishe> {
  final AuthService _authInstance = AuthService();
  final _formKey = GlobalKey<FormState>();

  // FORM FIELD VALUES STATE
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    // IF THE USER IS LOGGED IN, POP THE CURRENT PAGE
    if (_authInstance.currentUser() != null) {
      Navigator.pop(context);
    }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarTegura(),
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
              widget.message != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDE59),
                        border: Border.all(
                          width: 2.0,
                          color: const Color.fromARGB(255, 255, 204, 0),
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 59, 57, 77),
                            offset: Offset(0, 3),
                            blurRadius: 8,
                            spreadRadius: -7,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w900,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const GradientTitle(
                  title: 'IYANDIKISHE', icon: 'assets/images/iyandikishe.svg'),
              const Description(
                  text:
                      'Iyandikishe ubundi, wige, umenye utsindire provisoire!'),
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
                      DefaultInput(
                        placeholder: 'Izina',
                        validation: 'Injiza izina ryawe!',
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      DefaultInput(
                        placeholder: 'Imeyili',
                        validation: 'Injiza imeyili yawe!',
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),

                      // IJAMBOBANGA
                      DefaultInput(
                        placeholder: 'Ijambobanga',
                        validation: 'Injiza ijambobanga!',
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      CtaButton(
                        text: 'Iyandikishe',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic resSignUp;
                            try {
                              resSignUp = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('Ijambobanga ntiryujuje ibisabwa.');
                              } else if (e.code == 'email-already-in-use') {
                                setState(() {
                                  error = 'Iyi imeyili yarakoreshejwe!';
                                });
                              }
                            } catch (e) {
                              print(e);

                              setState(() {
                                error = e.toString();
                              });
                            }
                            if (resSignUp == null) {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TeguraAlert(
                                      errorTitle: 'Kwiyandikisha ntibikunze!',
                                      errorMsg: error,
                                      alertType: 'error',
                                    );
                                  },
                                );
                              });
                            } else {
                              await _authInstance.logOut();
                              if (!mounted) return;
                              Navigator.pushReplacementNamed(
                                  context, '/injira');
                            }
                          }
                        },
                      ),
                      const CtaAuthLink(
                        text1: 'Niba wariyandikishije, ',
                        text2: 'injira',
                        color1: Color.fromARGB(255, 255, 255, 255),
                        color2: Color.fromARGB(255, 0, 27, 116),
                        route: '/injira',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C64C6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 3.0,
                                  ),
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
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
          ),
        ));
  }
}
