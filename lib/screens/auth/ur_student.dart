import "package:flutter/material.dart";
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/utilities/cta_button.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/firebase_services/auth.dart';

class UrStudent extends StatefulWidget {
  const UrStudent({super.key});

  @override
  State<UrStudent> createState() => _UrStudentState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _UrStudentState extends State<UrStudent> {
  final AuthService _authInstance = AuthService();
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String error = '';
  String regNbr = '';
  final List<String> _items = [
    'REMERA',
    'GIKONDO',
    'HUYE',
    'RWAMAGANA',
    'NYAGATARE',
    'BUSOGO',
    'RUSIZI',
    'NYARUGENGE',
    'RUKARA'
  ];
  String _selectedCampus = '';

  @override
  Widget build(BuildContext context) {
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
              const GradientTitle(
                  title: 'REGISTER AS UR STUDENT',
                  icon: 'assets/images/ur_student.svg'),
              const Description(
                  text:
                      'Register as UR student and get a discount up to 50% of regular cost!'),
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
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
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
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      DefaultInput(
                        placeholder: 'Registration number',
                        validation: 'Please enter your registration number!',

                        // ON CHANGED
                        onChanged: (val) {
                          setState(() => regNbr = val);
                        },
                      ),
                      DefaultInput(
                        placeholder: 'Names',
                        validation: 'Please enter your names!',
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      DefaultInput(
                        placeholder: 'E-mail',
                        validation: 'Please enter your e-mail!',

                        // ON CHANGED
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      DefaultInput(
                          placeholder: 'Password',
                          validation: 'Please enter your password!',
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      CtaButton(
                        text: 'Register',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic resSignUp = await _authInstance
                                .registerWithEmailAndPassword(username, email,
                                    password, true, regNbr, _selectedCampus);
                            if (resSignUp == null) {
                              setState(() {
                                error =
                                    'Please supply a valid email and password';
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TeguraAlert(
                                      errorTitle: 'Error signing up!',
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
