import "package:flutter/material.dart";
import "package:tegura/screens/utilities/cta_button.dart";
import "package:tegura/screens/utilities/cta_link.dart";
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
                      placeholder: 'Nomero za telefone',
                      validation: 'Injiza numero za telefone!',
                    ),

                    // IJAMBOBANGA
                    DefaultInput(
                      placeholder: 'Ijambobanga',
                      validation: 'Injiza ijambobanga!',
                    ),

                    // CTA BUTTON
                    CtaButton(
                      text: 'Injira',
                      formKey: _formKey,
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
