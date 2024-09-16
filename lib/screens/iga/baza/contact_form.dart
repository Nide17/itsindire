import 'package:flutter/material.dart';
import 'package:tegura/screens/utilities/default_input.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _phoneNumber;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultInput(
              placeholder: 'Izina',
              validation: 'Izina ryawe rirakenewe!',
            ),

            DefaultInput(
              placeholder: 'Numero za telefone',
              validation: 'Numero za telefone zirakenewe!',
            ),

            DefaultInput(
              placeholder: 'Ubutumwa',
              validation: 'Ubutumwa bwawe burakenewe!',
              maxLines: 5,
            ),
            
            // 3. VERTICAL SPACE
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
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
                    //TODO: Send the form data
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
