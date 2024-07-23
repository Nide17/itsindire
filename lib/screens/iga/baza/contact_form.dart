// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? email;
  String? _message;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Future<bool> sendEmail() async {
      String username = dotenv.env['GMAIL_EMAIL']!;
      String password = dotenv.env['GMAIL_PASSWORD']!;
      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address('$email', '$_name')
        ..recipients.add('itsindire.rw@gmail.com')
        ..ccRecipients.addAll(['quizblog.rw@gmail.com'])
        ..subject = 'Message from $_name[$email]'
        ..text = _message;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: $sendReport');
        return true;
      } catch (e) {
        print('Error sending email: $e');
        rethrow;
      }
    }

    return isLoading == true
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
                    placeholder: 'Izina',
                    validation: 'Izina ryawe rirakenewe!',
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  DefaultInput(
                    placeholder: 'Imeyili',
                    validation: 'Imeyili yawe irakenewe!',
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  DefaultInput(
                    placeholder: 'Ubutumwa',
                    validation: 'Ubutumwa bwawe burakenewe!',
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {
                        _message = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.008,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.05,
                        ),
                        backgroundColor: const Color(0xFF00CCE5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.02,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          _formKey.currentState!.save();
                          bool isSent = false;
                          sendEmail().then((value) {
                            isSent = value;
                            setState(() {
                              isLoading = false;
                            });

                            if (isSent == true) {
                              if (_formKey.currentState != null) {
                                _formKey.currentState!.reset();
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                      'Ubutumwa bwawe bwagiye!',
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 10),
                                    backgroundColor: Color(0xFF00A651)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ubutumwa bwawe ntibwagiye!',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 10),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: Text(
                        'Ohereza',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
