import "package:flutter/material.dart";
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/firebase_services/auth.dart';

class UrStudent extends StatefulWidget {
  const UrStudent({Key? key}) : super(key: key);

  @override
  State<UrStudent> createState() => _UrStudentState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _UrStudentState extends State<UrStudent> {
  // AUTH SERVICE INSTANCE
  final AuthService _authInstance = AuthService();
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String error = '';
  String regNbr = '';
  final List<String> _items = ['CST', 'CBE', 'CMHS', 'CE', 'CAVM'];
  String _selectedCampus = '';

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    
    // IF THE USER IS LOGGED IN, POP THE CURRENT PAGE
    if (_authInstance.currentUser() != null) {
      Navigator.pop(context);
    }
    
    return Scaffold(
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
              // 1. GRADIENT TITLE
              const GradientTitle(
                  title: 'REGISTER AS UR STUDENT',
                  icon: 'assets/images/ur_student.svg'),

              // 2. DESCRIPTION
              const Description(
                  text:
                      'Register as UR student and get a discount up to 50% of regular cost!'),

              // CENTERED IMAGE
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/50off.png',
                      height: MediaQuery.of(context).size.height * 0.15,
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
                      // FORM DROPDOWN
                      DropdownButtonFormField<String>(
                        items: _items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Color(0xFF7FC8DF),
                              ),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          'Choose your campus',
                          style: TextStyle(
                            color: Color(0xFF7FC8DF),
                          ),
                        ),
                        decoration: const InputDecoration(
                          // BACKGROUND COLOR
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),

                          // HEIGHT
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCampus = value!;
                          });
                        },
                        value:
                            _selectedCampus.isNotEmpty ? _selectedCampus : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose your campus';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // do something with the selected value
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // NOMERO ZA TELEPHONE
                      DefaultInput(
                        placeholder: 'Registration number',
                        validation: 'Please enter your registration number!',

                        // ON CHANGED
                        onChanged: (val) {
                          setState(() => regNbr = val);
                        },
                      ),

                      // AMAZINA
                      DefaultInput(
                        placeholder: 'Names',
                        validation: 'Please enter your names!',
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
                        placeholder: 'Password',
                        validation: 'Please enter your password!',
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        // OBSCURE TEXT
                        obscureText: true,
                      ),

                      // CTA BUTTON
                      CtaButton(
                        text: 'Register',

                        // ON PRESSED
                        onPressed: () async {
                          // VALIDATE FORM
                          if (_formKey.currentState!.validate()) {
                            // REGISTER USER
                            dynamic resSignUp = await _authInstance
                                .registerWithEmailAndPassword(username, email,
                                    password, true, regNbr, _selectedCampus);

                            // CHECK IF USER IS REGISTERED
                            if (resSignUp == null) {
                              setState(() {
                                error =
                                    'Please supply a valid email and password';

                                // SHOW ERROR DIALOG
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
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            } else {
                              // LOGOUT USER
                              await _authInstance.logOut();

                              // REDIRECT TO LOGIN PAGE AFTER SUCCESSFUL REGISTRATION
                              if (!mounted) return;

                              Navigator.pushReplacementNamed(
                                  context, '/injira');
                            }
                          }
                        },
                      ),

                      // VERTICAL SPACE
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.002,
                      ),

                      // BISANZWE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C64C6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  )),
                              onPressed: () async {
                                Navigator.pushReplacementNamed(
                                    context, '/iyandikishe');
                              },
                              child: const Text(
                                'Iyandikishe bisanzwe',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
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
