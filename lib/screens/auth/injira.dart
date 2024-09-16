import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/firebase_services/auth.dart';
import 'package:tegura/utilities/loading_widget.dart';

class Injira extends StatefulWidget {
  final String? message;
  final ConnectionStatus? connectionStatus;
  const Injira({super.key, this.message, this.connectionStatus});

  @override
  State<Injira> createState() => _InjiraState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _InjiraState extends State<Injira> {
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

  // INITIALLY IF ALREADY LOGGED IN, GO TO THE HOME PAGE
  @override
  void initState() {
    super.initState();
    if (_authInstance.currentUser() != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // IF THE USER IS LOGGED IN, POP THE CURRENT PAGE
    if (_authInstance.currentUser() != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    return loading
        ? const LoadingWidget()
        : Scaffold(
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
                          DefaultInput(
                            placeholder: 'Imeyili',
                            validation: 'Injiza imeyili yawe!',
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),

                          DefaultInput(
                            placeholder: 'Ijambobanga',
                            validation: 'Injiza ijambobanga!',
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          CtaButton(
                            text: 'Injira',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() => loading = true);
                                dynamic loginRes = await _authInstance
                                    .loginWithEmailAndPassword(email, password);
                                if (loginRes == null) {
                                  setState(() {
                                    error = 'Injiza ibisabwa byanyabyo!';
                                    loading = false;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return TeguraAlert(
                                              errorTitle:
                                                  'Kwinjira ntibyakunze.',
                                              errorMsg: error,
                                              alertType: 'error',
                                          );
                                        });
                                  });
                                } else {
                                  await _loadProfileData();

                                  setState(() => loading = false);
                                  if (!mounted) return;
                                  if (ModalRoute.of(context)!.settings.name ==
                                          '/injira' ||
                                      ModalRoute.of(context)!.settings.name ==
                                          '/iyandikishe' ||
                                      ModalRoute.of(context)!.settings.name ==
                                          '/wibagiwe') {
                                    Navigator.pushNamed(
                                        context, '/iga-landing');
                                  } else {
                                    Navigator.pop(context);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Kwinjira byagenze neza!'),
                                          backgroundColor: Color(0xFF00A651)));
                                }
                              } else {
                                print('\nSigned in!!\n');
                              }
                            },
                          ),

                          // SIZED BOX
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          // CTA LINK
                          const CtaAuthLink(
                            text1: 'Wibagiwe ijambobanga? ',
                            text2: 'Risabe',
                            color1: Color.fromARGB(255, 255, 255, 255),
                            color2: Color.fromARGB(255, 0, 27, 116),
                            route: '/wibagiwe',
                          ),

                          // SIZED BOX
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
  }
}
