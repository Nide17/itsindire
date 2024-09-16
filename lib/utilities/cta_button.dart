import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const CtaButton({
    super.key,
    required this.text,
    required this.onPressed,
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
              ),
              elevation: MediaQuery.of(context).size.width * 0.015,
              shadowColor: const Color.fromARGB(255, 0, 0, 0),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.016),
              side: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
                width: 3.0,
              ),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: MediaQuery.of(context).size.width * 0.036,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        )
      ],
    );
  }
}
