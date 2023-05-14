import "package:flutter/material.dart";
import 'package:tegura/screens/utilities/my_appbar.dart';
import "package:tegura/services/auth.dart";

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _SignInState extends State<SignIn> {

  // AUTH SERVICE INSTANCE
  final AuthService _auth = AuthService();

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
        body: Container(
          padding: const EdgeInsets.all(40.0),

          // RAISED BUTTON
          child: ElevatedButton(
            onPressed: () async {
              
              // SIGN IN
              dynamic result =
                  await _auth.signInAnon(); // DYNAMIC TYPE - CAN USER OR NULL
                  
              if (result == null) {
                print('Error signing in');
              } else {
                print('Signed in');
                print(result.uid);
              }
            },
            child: const Text('Sign In Anonymously'),
          ),
        ));
  }
}
