import "package:flutter/material.dart";
import "package:tegura/screens/utilities/default_input.dart";
import 'package:tegura/screens/utilities/description.dart';
import "package:tegura/screens/iga/gradient_title.dart";
import 'package:tegura/screens/utilities/my_appbar.dart';
import "package:tegura/services/auth.dart";

class UrStudent extends StatefulWidget {
  const UrStudent({Key? key}) : super(key: key);

  @override
  _UrStudentState createState() => _UrStudentState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _UrStudentState extends State<UrStudent> {
  // AUTH SERVICE INSTANCE
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _selectedItem = '';
  final List<String> _items = ['CST', 'CBE', 'CMHS', 'CE', 'CAVM'];

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
                          _selectedItem = value!;
                        });
                      },
                      value: _selectedItem.isNotEmpty ? _selectedItem : null,
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
                    ),

                    // NOMERO ZA TELEPHONE
                    DefaultInput(
                      placeholder: 'Names',
                      validation: 'Please enter your names!',
                    ),

                    // IJAMBOBANGA
                    DefaultInput(
                      placeholder: 'Phone number',
                      validation: 'Please enter your phone number!',
                    ),

                    // IJAMBOBANGA
                    DefaultInput(
                      placeholder: 'Password',
                      validation: 'Please enter your password!',
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
                          'Register',
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

                    // VERTICAL SPACE
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),

                    // 4. BUTTON
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
                            onPressed: () {
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
