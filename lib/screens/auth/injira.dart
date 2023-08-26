import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/spinner.dart';
import 'package:tegura/firebase_services/auth.dart';

class Injira extends StatefulWidget {
  final String? message;
  final ConnectionStatus? connectionStatus;
  const Injira({Key? key, this.message, this.connectionStatus}) : super(key: key);

  @override
  State<Injira> createState() => _InjiraState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _InjiraState extends State<Injira> {
  // AUTH SERVICE INSTANCE - TO ACCESS THE AUTH METHODS
  final AuthService _authInstance = AuthService();

// DECLARE FORM KEY TO VALIDATE THE FORM
  final _formKey = GlobalKey<FormState>();

  // FORM FIELD VALUES STATE
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  dynamic profile;

  Future<void> _loadProfileData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      ProfileModel prfl = await ProfileService()
          .getAppBarProfileData(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        profile = prfl;
      });
    }
  }

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Spinner()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 71, 103, 158),

            // APP BAR
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(58.0),
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
                  widget.message != null
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
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
                  // 1. GRADIENT TITLE
                  const GradientTitle(
                      title: 'INJIRA', icon: 'assets/images/injira.svg'),

                  // 2. DESCRIPTION
                  const Description(
                      text: 'Injira kugirango ubashe kubona byose!'),

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

// FORM
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: 0.0),
                    child: Form(
                      key: _formKey, // FORM KEY TO VALIDATE THE FORM
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // EMAIL
                          DefaultInput(
                            placeholder: 'Imeyili',
                            validation: 'Injiza imeyili yawe!',

                            // ON CHANGED
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },

                            obscureText: false,
                          ),

                          // IJAMBOBANGA
                          DefaultInput(
                            placeholder: 'Ijambobanga',
                            validation: 'Injiza ijambobanga!',

                            // ON CHANGED
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: true,
                          ),

                          // CTA BUTTON
                          CtaButton(
                            text: 'Injira',
                            onPressed: () async {
                              //VALIDATING THE FORM FIELDS
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // SET THE LOADING STATE TO TRUE
                                setState(() => loading = true);

                                // LOGIN THE USER
                                dynamic loginRes = await _authInstance
                                    .loginWithEmailAndPassword(email, password);

                                // CHECK IF LOGIN SUCCESSFUL
                                if (loginRes == null) {
                                  setState(() {
                                    error = 'Please supply valid credentials!';
                                    loading = false;

                                    // SHOW ALERT DIALOG
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(error),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'))
                                            ],
                                          );
                                        });
                                  });
                                } else {
                                  // LOAD PROFILE DATA
                                  await _loadProfileData();

                                  // SET THE LOADING STATE TO FALSE
                                  setState(() => loading = false);

                                  // NAVIGATE TO THE PREVIOUS PAGE
                                  if (!mounted) return;

                                  Navigator.pop(context);

                                  // SHOW SNACKBAR TO SHOW SUCCESSFUL LOGIN
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Kwinjira byagenze neza!'),
                                    backgroundColor: Colors.green,
                                  ));
                                }
                              } else {
                                print('\nSigned in!!\n');
                              }
                            },
                          ),

                          // CTA LINK
                          const CtaLink(
                            text1: 'Wibagiwe ijambobanga? ',
                            text2: 'hindura',
                            color1: Color.fromARGB(255, 255, 255, 255),
                            color2: Color.fromARGB(255, 0, 27, 116),
                            route: '/wibagiwe',
                          ),

                          // SIZED BOX
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
                        // SIGN IN ANONYMOUSLY USING THE AUTH SERVICE INSTANCE - AUTH CLASS
                        dynamic result = await _authInstance
                            .signInAnon(); // DYNAMIC TYPE - CAN BE USER OR NULL

                        if (result == null) {
                        } else {
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
