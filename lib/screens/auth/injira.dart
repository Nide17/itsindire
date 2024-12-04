import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/main.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/cta_link.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/screens/auth/message_container.dart';

class Injira extends StatefulWidget {
  final String? message;
  final ConnectionStatus? connectionStatus;
  const Injira({super.key, this.message, this.connectionStatus});

  @override
  State<Injira> createState() => _InjiraState();
}

class _InjiraState extends State<Injira> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';
  String password = '';
  bool loading = false;
  ScaffoldMessengerState? scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    if (widget.connectionStatus != null) {
      widget.connectionStatus!.setOnline();
    }

    // Initialize scaffoldMessenger here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        scaffoldMessenger = ScaffoldMessenger.of(context);
      }
    });
  }

  @override
  void dispose() {
    // Cancel any timers or listeners here
    super.dispose();
  }

  void _showSnackbar(String message, ReturnedResult result) {

    if (scaffoldMessenger != null) {
      scaffoldMessenger!.showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: result.isSuccess == true
              ? const Color(0xFF00A651)
              : const Color.fromARGB(255, 255, 0, 0),
        ),
      );
    }
  }

  Future<void> _handleLogin(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => loading = true);
      try {
        ReturnedResult result = await authState.userLogin(email, password);

        _showSnackbar(
          result.successMessage ?? result.error ?? 'Kwinjira ntibikunze. Mwongere mugerageze!',
          result,
        );
      } finally {
        if (mounted)
        setState(() => loading = false);
      }
    } else {
      if (mounted)
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.refreshToken != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/iga-landing');
            }
          });
        }

        return Consumer<AuthState>(builder: (context, authState, _) {
          return Scaffold(
            key: _scaffoldKey,
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
                  const GradientTitle(title: 'INJIRA', icon: 'assets/images/injira.svg'),
                  const Description(text: 'Banza winjire ubone gukomeza!'),
                  loading ? const LoadingWidget() : Image.asset(
                    'assets/images/house_keys.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
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
                          DefaultInput(
                            placeholder: 'Imeyili',
                            validation: 'Injiza imeyili yawe!',
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                          ),
                          DefaultInput(
                            placeholder: 'Ijambobanga',
                            validation: 'Injiza ijambobanga!',
                            onChanged: (value) =>
                                setState(() => password = value),
                          ),
                          CtaButton(
                            text: 'Injira - Login',
                            onPressed: () => _handleLogin(authState),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const CtaAuthLink(
                            text1: 'Wibagiwe ijambobanga? ',
                            text2: 'Risabe',
                            color1: Color.fromARGB(255, 255, 255, 255),
                            color2: Color.fromARGB(255, 0, 27, 116),
                            route: '/wibagiwe',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const CtaAuthLink(
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
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
