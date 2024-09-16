import 'package:flutter/material.dart';

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
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Izina',
                hintStyle: TextStyle(
                  color: Color(0xFF7FC8DF),
                ),

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
                  vertical: 0.0,
                  horizontal: 16.0,
                ),
              ),

              // VALIDATION
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Izina ryawe rirakenewe!';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Numero za telefone',
                hintStyle: TextStyle(
                  color: Color(0xFF7FC8DF),
                ),

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
                  vertical: 0.0,
                  horizontal: 24.0,
                ),
              ),

              // VALIDATION
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Numero za telefone zirakenewe!';
                }
                return null;
              },
              onSaved: (value) {
                _phoneNumber = value;
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Ikibazo/Igitekerezo',
                hintStyle: TextStyle(
                  color: Color(0xFF7FC8DF),
                ),

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

              // VALIDATION
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Andika hano!';
                }
                return null;
              },
              onSaved: (value) {
                _message = value;
              },
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
