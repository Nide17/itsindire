import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/utilities/snackbar_util.dart';
import '../../../utilities/route_action_button.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _message;
  bool isLoading = false;

  void showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    SnackbarUtil.showSnackBar(context, message, backgroundColor);
  }

  Future<void> sendEmail() async {
    setState(() => isLoading = true);

    try {
      final isSent = await EmailService.sendMail(
        name: _name!,
        email: _email!,
        message: _message!,
      );

      final snackBarMessage =
          isSent ? 'Ubutumwa bwawe bwagiye!' : 'Ubutumwa bwawe ntibwagiye!';

      showSnackBar(
        snackBarMessage,
        backgroundColor: isSent ? const Color(0xFF00A651) : Colors.red,
      );

      if (isSent && _formKey.currentState != null) {
        _formKey.currentState!.reset();
      }
    } catch (e) {
      showSnackBar(
        'Error sending email. Please try again.',
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.16),
            child: const LoadingWidget())
        : MultiProvider(
            providers: [
              StreamProvider<ProfileModel?>.value(
                value: FirebaseAuth.instance.currentUser != null
                    ? ProfileService().getCurrentProfileByID(
                        FirebaseAuth.instance.currentUser!.uid)
                    : null,
                initialData: null,
                catchError: (context, error) => null,
              ),
            ],
            child: Consumer<ProfileModel?>(builder: (context, profile, _) {
              if (profile != null) {
                _name = profile.username;
                _email = profile.email;
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.048),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profile?.username == null
                          ? DefaultInput(
                              placeholder: 'Izina',
                              validation: 'Izina ryawe rirakenewe!',
                              onChanged: (value) =>
                                  setState(() => _name = value),
                            )
                          : Container(),
                      profile?.email == null
                          ? DefaultInput(
                              placeholder: 'Imeyili',
                              validation: 'Imeyili yawe irakenewe!',
                              enabled: profile?.email == null,
                              onChanged: (value) =>
                                  setState(() => _email = value),
                            )
                          : Container(),
                      DefaultInput(
                        placeholder: 'Ubutumwa',
                        validation: 'Ubutumwa bwawe burakenewe!',
                        maxLines: 5,
                        onChanged: (value) => setState(() => _message = value),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RouteActionButton(
                          btnText: 'Ohereza',
                          action: () => _formKey.currentState!.validate()
                              ? sendEmail()
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
  }
}

class EmailService {
  static Future<bool> sendMail({
    required String name,
    required String email,
    required String message,
  }) async {
    String? username = dotenv.env['GMAIL_EMAIL'];
    String? password = dotenv.env['GMAIL_PASSWORD'];

    if (username == null || password == null) {
      print('Error: Missing environment variables for email credentials.');
      return false;
    }

    final smtpServer = gmail(username, password);

    final emailMessage = Message()
      ..from = Address(email, name)
      ..recipients.add('itsindire.rw@gmail.com')
      ..ccRecipients.addAll(['quizblog.rw@gmail.com', 'info@quizblog.rw'])
      ..subject = 'Message from $name [$email]'
      ..text = message;

    try {
      await send(emailMessage, smtpServer);
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
