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
    final double buttonElevation = MediaQuery.of(context).size.width * 0.015;
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.016;
    final double fontSize = MediaQuery.of(context).size.width * 0.036;
    final double spacing = MediaQuery.of(context).size.height * 0.035;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C64C6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: buttonElevation,
              shadowColor: const Color.fromARGB(255, 0, 0, 0),
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding),
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
                fontSize: fontSize,
              ),
            ),
          ),
        ),
        SizedBox(
          height: spacing,
        )
      ],
    );
  }
}
