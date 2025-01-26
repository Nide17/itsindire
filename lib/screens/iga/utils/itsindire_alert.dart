import 'package:flutter/material.dart';

class ItsindireAlert extends StatelessWidget {
  final String errorTitle;
  final String errorMsg;
  final String? firstButtonTitle;
  final Function? firstButtonFunction;
  final Color? firstButtonColor;
  final String? secondButtonTitle;
  final Function? secondButtonFunction;
  final Color? secondButtonColor;
  final String? alertType;

  const ItsindireAlert(
      {super.key,
      required this.errorTitle,
      required this.errorMsg,
      this.firstButtonTitle,
      this.firstButtonFunction,
      this.firstButtonColor,
      this.secondButtonTitle,
      this.secondButtonFunction,
      this.secondButtonColor,
      this.alertType});

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      color: getAlertColor(alertType),
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.width * 0.04,
    );

    final TextStyle contentStyle = TextStyle(
      color: const Color.fromARGB(255, 0, 27, 116),
      fontSize: MediaQuery.of(context).size.width * 0.03,
    );

    return AlertDialog(
      title: Text(
        errorTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Text(
        errorMsg,
        style: contentStyle,
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.016,
        ),
        side: BorderSide(
          color: getAlertColor(alertType),
          width: MediaQuery.of(context).size.width * 0.007,
        ),
      ),
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      actions: [
        _buildButton(context, firstButtonTitle, firstButtonFunction, firstButtonColor),
        if (secondButtonTitle != null && secondButtonFunction != null)
          _buildButton(context, secondButtonTitle, secondButtonFunction, secondButtonColor),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildButton(BuildContext context, String? title, Function? onPressed, Color? color) {
    return TextButton(
      onPressed: () {
        title != null ? onPressed!() : Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.012,
          vertical: MediaQuery.of(context).size.height * 0.006,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: getAlertColor(alertType),
            width: MediaQuery.of(context).size.width * 0.004,
          ),
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.016),
          color: color ?? getAlertColor(alertType),
        ),
        child: Text(
          title ?? 'Funga',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}

Color getAlertColor(String? alertType) {
  switch (alertType) {
    case 'success':
      return const Color(0xFF00A651);
    case 'error':
      return const Color(0xFFE60000);
    case 'warning':
      return const Color(0xFFFFBD59);
    default:
      return const Color.fromARGB(255, 0, 27, 116);
  }
}
