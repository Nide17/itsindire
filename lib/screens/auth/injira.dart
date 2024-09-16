import "package:flutter/material.dart";
import "package:tegura/screens/utilities/default_input.dart";
import 'package:tegura/screens/utilities/description.dart';
import "package:tegura/screens/iga/gradient_title.dart";
import 'package:tegura/screens/utilities/my_appbar.dart';
import "package:tegura/services/auth.dart";

class Injira extends StatefulWidget {
  const Injira({Key? key}) : super(key: key);

  @override
  _InjiraState createState() => _InjiraState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _InjiraState extends State<Injira> {
  // AUTH SERVICE INSTANCE
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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
            GradientTitle(title: 'INJIRA', icon: 'assets/images/injira.svg'),

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
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ]),

            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOMERO ZA TELEPHONE
                    DefaultInput(
                      placeholder: 'Nomero za telefone',
                      validation: 'Injiza numero za telefone!',
                    ),

                    // IJAMBOBANGA
                    DefaultInput(
                      placeholder: 'Ijambobanga',
                      validation: 'Injiza ijambobanga!',
                    ),

                    // 4. BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00CCE5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            )),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //TODO: Send the form data
                          }
                        },
                        child: const Text(
                          'Injira',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),

                    // ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Wibagiwe ijambobanga? ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        // INK WELL
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/amakuru');
                          },
                          child: const Text(
                            'Hindura',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // VERTICAL SPACE
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),

                    // ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nta jambobanga? ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        // INK WELL
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/amakuru');
                          },
                          child: const Text(
                            'Kwiyandikisha',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
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
        ));
  }
}
