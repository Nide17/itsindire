import 'package:flutter/material.dart';

class QBSubTitle extends StatelessWidget {
  final String title;
  final String no;

  const QBSubTitle({required this.title, required this.no, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: no == '' ? '' : '$no. ',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
          children: <TextSpan>[
            TextSpan(
              text: title.toUpperCase(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
