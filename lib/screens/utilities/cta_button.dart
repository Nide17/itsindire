import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
// INSTANCE VARIABLES
  final String text;
  final GlobalKey<FormState> formKey;

  // CONSTRUCTOR
  const CtaButton({
    super.key,
    required this.text,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return // 4. BUTTON
        Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C64C6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                )),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                //TODO: Send the form data
              }
            },
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
        // VERTICAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        )
      ],
    );
  }
}
