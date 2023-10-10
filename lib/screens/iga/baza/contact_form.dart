import 'package:flutter/material.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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

  @override
  Widget build(BuildContext context) {
    Future<bool> sendEmail() async {
      final smtpServer = gmail('quizblog.rw@gmail.com', 'ixvepscvgpgxyftz');

      final message = Message()
        ..from = Address('$email', '$_name')
        ..recipients.add('quizblog.rw@gmail.com')
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

    return Padding(
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
              // ON CHANGED
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),

            DefaultInput(
              placeholder: 'Imeyili',
              validation: 'Imeyili yawe irakenewe!',
              // ON CHANGED
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
              // ON CHANGED
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),

            // 3. VERTICAL SPACE
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),

            // 4. BUTTON
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
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool isSent = false;
                    sendEmail().then((value) {
                      isSent = value;

                      if (isSent == true) {
                        // CLEAR THE FORM
                        _formKey.currentState!.reset();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ubutumwa bwawe bwagiye!',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 10),
                            backgroundColor: Colors.green,
                          ),
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
                child: const Text(
                  'Ohereza',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
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
