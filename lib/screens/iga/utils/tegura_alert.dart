import 'package:flutter/material.dart';

class TeguraAlert extends StatelessWidget {
  final String errorTitle;
  final String errorMsg;
  final String? firstButtonTitle;
  final Function? firstButtonFunction;
  final Color? firstButtonColor;
  final String? secondButtonTitle;
  final Function? secondButtonFunction;
  final Color? secondButtonColor;
  final String? alertType;

  const TeguraAlert(
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
    return AlertDialog(
      title: Text(
        errorTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: getAlertColor(alertType),
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Text(
        errorMsg,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 27, 116),
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
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
        TextButton(
            onPressed: () {
              firstButtonTitle != null
                  ? firstButtonFunction!()
                  : Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.016,
                vertical: MediaQuery.of(context).size.height * 0.006,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: getAlertColor(alertType),
                  width: MediaQuery.of(context).size.width * 0.004,
                ),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.016),
                color: firstButtonColor ?? getAlertColor(alertType),
              ),
              child: Text(
                firstButtonTitle ?? 'Funga',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            )),
        if (secondButtonTitle != null)
          TextButton(
              onPressed: () {
                secondButtonFunction!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.016,
                  vertical: MediaQuery.of(context).size.height * 0.006,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getAlertColor(alertType),
                    width: MediaQuery.of(context).size.width * 0.004,
                  ),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.016),
                  color: secondButtonColor ?? getAlertColor(alertType),
                ),
                child: Text(
                  secondButtonTitle ?? 'Funga',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              )),
      ],
      actionsAlignment: MainAxisAlignment.center,
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
