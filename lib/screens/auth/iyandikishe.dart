import "package:flutter/material.dart";
import "package:tegura/screens/utilities/default_input.dart";
import 'package:tegura/screens/utilities/description.dart';
import "package:tegura/screens/iga/gradient_title.dart";
import 'package:tegura/screens/utilities/my_appbar.dart';
import "package:tegura/services/auth.dart";

class Iyandikishe extends StatefulWidget {
  const Iyandikishe({Key? key}) : super(key: key);

  @override
  _IyandikisheState createState() => _IyandikisheState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _IyandikisheState extends State<Iyandikishe> {
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
            GradientTitle(
                title: 'Iyandikishe', icon: 'assets/images/iyandikishe.svg'),

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
                    ),

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
                          'Iyandikishe',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),

                    // VERTICAL SPACE
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),

                    // ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Niba wariyandikishije, ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),

                        // INK WELL
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/injira');
                          },
                          child: const Text(
                            'Injira',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 27, 116),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // VERTICAL SPACE
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),

                    // 4. BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C64C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            )),
                        onPressed: () {
                          // Navigator.pushNamed(context, '/ur-student');
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
