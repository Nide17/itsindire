import "package:flutter/material.dart";
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/cta_link.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/spinner.dart';
import 'package:tegura/firebase_services/auth.dart';

class Injira extends StatefulWidget {
  const Injira({Key? key}) : super(key: key);

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

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Spinner()
        : Scaffold(
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
                    title: 'INJIRA', icon: 'assets/images/injira.svg'),

                // 2. DESCRIPTION
                const Description(
                    text: 'Injira kugirango ubashe kubona amasomo yose!'),

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

                              print('\nLogin result:');
                              print(loginRes.toString());

                              // CHECK IF LOGIN SUCCESSFUL
                              if (loginRes == null) {
                                print('\nError signing in!\n');
                                setState(() {
                                  error = 'Please supply valid credentials!';
                                  loading = false;
                                  print('\nError signing in!\n');

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
                              }
                              else {
                                print('\nSigned in!!\n');

                                // SET THE LOADING STATE TO FALSE
                                setState(() => loading = false);

                                // NAVIGATE TO THE PREVIOUS PAGE
                                if(!mounted) return;

                                Navigator.pop(context);

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
                          height: MediaQuery.of(context).size.height * 0.08,
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
                        print('\nError signing in!\n');
                      } else {
                        print('\nUser signed in successfully\n');
                        print(result.uid);
                      }
                    },
                    child: const Text('Sign In Anonymously'),
                  ),
                ),
              ],
            ));
  }
}
