import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/utilities/snackbar_util.dart';

import '../../main.dart';

class UrStudent extends StatefulWidget {
  const UrStudent({super.key});

  @override
  State<UrStudent> createState() => _UrStudentState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _UrStudentState extends State<UrStudent> {
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
  bool loading = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      currentUser = Provider.of<AuthState>(context, listen: false).currentUser;
    });
      if (currentUser != null) {
        Navigator.pushReplacementNamed(context, '/iga-landing');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
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
              if (loading) const LoadingWidget(),
              if (!loading) _buildImage(context),
              _buildForm(context, authState),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/50off.png',
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.2,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Image not available');
          },
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, AuthState authState) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 0.0),
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
                setState(() => _selectedCampus = value ?? '');
              },
              value: _selectedCampus.isNotEmpty ? _selectedCampus : null,
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
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            DefaultInput(
              placeholder: 'Password',
              validation: 'Please enter your password!',
              isPassword: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            CtaButton(
              text: 'Register',
              onPressed: () => _registerUser(authState),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.002,
            ),
            _buildRegisterAsRegularButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterAsRegularButton(BuildContext context) {
    return Row(
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
              Navigator.pushReplacementNamed(context, '/iyandikishe');
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
    );
  }

  void _registerUser(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      try {
        ReturnedResult registerResult = await authState.registerNewUser(
            username, email, password, true, regNbr, _selectedCampus);

        if (registerResult.value != null) {
          SnackbarUtil.showSnackBar(context, 'Registered successfully!', const Color(0xFF00A651));

          await _loginUser(authState);
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ItsindireAlert(
                errorTitle: 'Register failed!',
                errorMsg: registerResult.error ==
                        'Ijambo banga ntiryujuje ibisabwa!'
                    ? 'Weak password!'
                    : registerResult.error ==
                            'Iyi imeyili yarakoreshejwe! Injira!'
                        ? 'Email already in use! Login!'
                        : 'Unknown error occurred! Call 0794033360 for help!',
                alertType: 'error',
                firstButtonTitle: 'Close',
                firstButtonFunction: () {
                  Navigator.pop(context);
                },
                secondButtonTitle: 'Login',
                secondButtonFunction: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/injira');
                },
                secondButtonColor: Color(0xFF00A651),
              );
            },
          );
        }
      } catch (e) {
        _showErrorDialog('Kwiyandikisha ntibyagenze neza!',
            'Habayeho ikibazo, gerageza nanone! Error: $e');
      } finally {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _loginUser(AuthState authState) async {
    ReturnedResult loginResult = await authState.userLogin(email, password);

    if (loginResult.value != null) {
      SnackbarUtil.showSnackBar(context, 'Register successful!', const Color(0xFF00A651));

      Navigator.pushReplacementNamed(context, '/iga-landing');

      if (loginResult.value!.email != null &&
          loginResult.value!.email != 'testing@mail.com' &&
          loginResult.value!.email != 'nidehazard10@gmail.com') {
        SnackbarUtil.showSnackBar(context, 'YOU HAVE NOW STARTED A 30 MINUTES TRIAL PERIOD', const Color.fromARGB(255, 250, 213, 6));
      }
    } else {
      _showErrorDialog('Logging in failed!',
          loginResult.error ?? 'Logging in failed, Try again!');
    }
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ItsindireAlert(
          errorTitle: title,
          errorMsg: message,
          alertType: 'error',
          secondButtonTitle: 'Login',
          secondButtonFunction: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/injira');
          },
          secondButtonColor: Color(0xFF00A651),
        );
      },
    );
  }
}
