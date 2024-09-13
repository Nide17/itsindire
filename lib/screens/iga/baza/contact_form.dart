import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

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

  Future<void> sendEmail() async {
    try {
      setState(() {
        isLoading = true;
      });

      final isSent = await EmailService.sendEmail(
        name: _name!,
        email: _email!,
        message: _message!,
      );

      setState(() {
        isLoading = false;
      });

      final snackBarMessage =
          isSent ? 'Ubutumwa bwawe bwagiye!' : 'Ubutumwa bwawe ntibwagiye!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            snackBarMessage,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 10),
          backgroundColor: isSent ? const Color(0xFF00A651) : Colors.red,
        ),
      );

      if (isSent && _formKey.currentState != null) {
        _formKey.currentState!.reset();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error sending email. Please try again.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel?>(context);

    _name = profile?.username;
    _email = profile?.email;

    return isLoading
        ? Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.16),
            child: const LoadingWidget())
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.048),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultInput(
                    placeholder: _name ?? 'Izina',
                    validation: _name == null
                        ? 'Izina ryawe rirakenewe!'
                        : null, // Skip validation if _name is not null
                    enabled: _name == null,
                    onChanged: (value) => setState(() => _name = value),
                  ),
                  DefaultInput(
                    placeholder: _email ?? 'Imeyili',
                    validation:
                        _email == null ? 'Imeyili yawe irakenewe!' : null,
                    enabled: _email == null,
                    onChanged: (value) => setState(() => _email = value),
                  ),
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
                      action: () => _formKey.currentState != null &&
                              _formKey.currentState!.validate()
                          ? sendEmail()
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class EmailService {
  static Future<bool> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    String username = dotenv.env['GMAIL_EMAIL']!;
    String password = dotenv.env['GMAIL_PASSWORD']!;
    final smtpServer = gmail(username, password);

    final emailMessage = Message()
      ..from = Address(email, name)
      ..recipients.add('itsindire.rw@gmail.com')
      ..ccRecipients.addAll(['quizblog.rw@gmail.com'])
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
