import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/user.dart';
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

class _InjiraState extends State<Injira> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';
  String password = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.connectionStatus != null) {
      widget.connectionStatus!.setOnline();
    }
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/iga-landing');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingWidget()
        : StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data?.uid != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/iga-landing');
                  }
                });
              }

              return Consumer<AuthState>(builder: (context, authState, _) {
                return Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: const Color.fromARGB(255, 71, 103, 158),
                    appBar: PreferredSize(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDE59),
                                    border: Border.all(
                                      width: 2.0,
                                      color: const Color.fromARGB(
                                          255, 255, 204, 0),
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
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.w900,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          const GradientTitle(
                              title: 'INJIRA',
                              icon: 'assets/images/injira.svg'),
                          const Description(
                              text: 'Injira kugirango ubashe kubona byose!'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/house_keys.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                ),
                              ]),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical: 0.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultInput(
                                    placeholder: 'Imeyili',
                                    validation: 'Injiza imeyili yawe!',
                                    onChanged: (value) {
                                      setState(() => email = value);
                                    },
                                  ),
                                  DefaultInput(
                                    placeholder: 'Ijambobanga',
                                    validation: 'Injiza ijambobanga!',
                                    onChanged: (value) =>
                                        setState(() => password = value),
                                  ),
                                  CtaButton(
                                    text: 'Injira - Login',
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        setState(() => loading = true);

                                        dynamic result = await authState
                                            .userLogin(email, password);

                                        setState(() => loading = false);

                                        print('\nResult: $result\n');

                                        if (!mounted) return;

                                        if (result == null) {
                                          print(
                                              '\nKwinjira ntibyagenze neza!\n');
                                          showCustomSnackBar(
                                              context,
                                              'Kwinjira ntibyagenze neza, hamagara 0794033360 tugufashe!',
                                              Colors.red);
                                        } else if (result.runtimeType !=
                                                UserModel &&
                                            result.error != null) {
                                          print('\nError: ${result.error}\n');
                                          authState.logOut();
                                          // showCustomSnackBar(context,
                                          //     result.error, Colors.red);

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Ijambo banga!'),
                                                content: Text(result.error),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Oya'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if (result.runtimeType !=
                                                UserModel &&
                                            result.warning != null) {
                                          print(
                                              '\nWarning: ${result.warning}\n');

                                          authState.logOut();
                                          showCustomSnackBar(context,
                                              result.warning, Colors.orange);
                                        } else {
                                          showCustomSnackBar(
                                              context,
                                              'Kwinjira byagenze neza!',
                                              Colors.green);
                                          print('\nKwinjira-User: ${result}\n');
                                          authState.setCurrentUser(FirebaseAuth
                                              .instance.currentUser);
                                        }
                                      }
                                    },
                                  ),

                                  // SIZED BOX
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
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
            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showCustomSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
