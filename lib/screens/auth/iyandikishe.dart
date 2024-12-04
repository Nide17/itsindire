import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:itsindire/main.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/cta_link.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/screens/auth/message_container.dart';
import 'package:itsindire/screens/auth/form_fields.dart';

class Iyandikishe extends StatefulWidget {
  final String? message;
  const Iyandikishe({super.key, this.message});

  @override
  State<Iyandikishe> createState() => _IyandikisheState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _IyandikisheState extends State<Iyandikishe> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('roles');
  bool loading = false;

  // FORM FIELD VALUES STATE
  String username = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthState>(context, listen: false).currentUser;
      if (user != null && user.refreshToken != null) {
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
                if (widget.message != null)
                  MessageContainer(message: widget.message!),
                const GradientTitle(
                    title: 'IYANDIKISHE',
                    icon: 'assets/images/iyandikishe.svg'),
                const Description(
                    text:
                        'Iyandikishe ubundi, wige, umenye utsindire provisoire!'),
                if (loading) const LoadingWidget(),
                if (!loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/house_keys.png',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFields(
                          onUsernameChanged: (val) =>
                              setState(() => username = val),
                          onEmailChanged: (val) => setState(() => email = val),
                          onPasswordChanged: (val) =>
                              setState(() => password = val),
                        ),
                        CtaButton(
                          text: 'Iyandikishe',
                          onPressed: () => _registerUser(authState),
                        ),
                        const CtaAuthLink(
                          text1: 'Niba wariyandikishije, ',
                          text2: 'injira',
                          color1: Color.fromARGB(255, 255, 255, 255),
                          color2: Color.fromARGB(255, 0, 27, 116),
                          route: '/injira',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C64C6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 3.0,
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/ur-student');
                              },
                              child: const Text(
                                'Register as UR student',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Image.asset(
                              'assets/images/50off.png',
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
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
    });
  }

  void _registerUser(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      try {
        ReturnedResult registerResult = await authState.registerNewUser(
            username, email, password, false, '', '');

        if (registerResult.value != null) {
          await _loginUser(authState);
        } else {
          _showErrorDialog(
              'Kwiyandikisha ntibyagenze neza!',
              registerResult.error ??
                  'Kwiyandikisha ntibyagenze neza, hamagara 0794033360 tugufashe!');
        }
      } catch (e) {
        _showErrorDialog('Kwiyandikisha ntibyagenze neza!',
            'Hari ikibazo cya network, gerageza nanone!');
      } finally {
        setState(() => loading = false);
      }
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> _loginUser(AuthState authState) async {
    ReturnedResult loginResult = await authState.userLogin(email, password);

    if (loginResult.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Kwiyandikisha byagenze neza!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: Color(0xFF00A651)));

      Navigator.pushReplacementNamed(context, '/iga-landing');
    } else {
      _showErrorDialog('Kwinjira ntibyagenze neza!',
          loginResult.error ?? 'Kwinjira ntibyagenze neza, Injira nanone!');
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
          secondButtonTitle: 'Injira',
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
