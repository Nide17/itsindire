import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:itsindire/main.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/cta_link.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/firebase_services/auth.dart';

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
      if (Provider.of<AuthState>(context, listen: false).currentUser != null) {
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
                widget.message != null
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.03,
                        ),
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDE59),
                          border: Border.all(
                            width: 2.0,
                            color: const Color.fromARGB(255, 255, 204, 0),
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 59, 57, 77),
                              offset: Offset(0, 3),
                              blurRadius: 8,
                              spreadRadius: -7,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.message!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w900,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const GradientTitle(
                    title: 'IYANDIKISHE',
                    icon: 'assets/images/iyandikishe.svg'),
                const Description(
                    text:
                        'Iyandikishe ubundi, wige, umenye utsindire provisoire!'),
                loading == true
                    ? const LoadingWidget()
                    : Row(
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
                        DefaultInput(
                          placeholder: 'Izina',
                          validation: 'Injiza izina ryawe!',
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                        DefaultInput(
                          placeholder: 'Imeyili',
                          validation: 'Injiza imeyili yawe!',
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),

                        // IJAMBOBANGA
                        DefaultInput(
                          placeholder: 'Ijambobanga',
                          validation: 'Injiza ijambobanga!',
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        CtaButton(
                          text: 'Iyandikishe',
                          onPressed: () async {
                            setState(() => loading = true);
                            if (_formKey.currentState!.validate()) {
                              ReturnedResult result =
                                  await authState.registerNewUser(
                                      username, email, password, false, '', '');

                              if (result.value != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Kwiyandikisha byagenze neza, Injira!'),
                                        backgroundColor: Color(0xFF00A651)));

                                if (!mounted) return;
                                setState(() => loading = false);
                                Navigator.pushReplacementNamed(
                                    context, '/injira');
                              } else {
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ItsindireAlert(
                                      errorTitle:
                                          'Kwiyandisha ntibyagenze neza!',
                                      errorMsg: result.error ??
                                          'Kwiyandisha ntibyagenze neza, hamagara 0794033360 tugufashe!',
                                      alertType: 'error',
                                      secondButtonTitle: 'Injira',
                                      secondButtonFunction: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/injira');
                                      },
                                      secondButtonColor: Color(0xFF00A651),
                                    );
                                  },
                                );
                              }
                            }
                          },
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
}
