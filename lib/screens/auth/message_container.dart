
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String message;

  const MessageContainer({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.03,
      ),
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDE59),
        border: Border.all(
          width: 2.0,
          color: const Color.fromARGB(255, 255, 204, 0),
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 59, 57, 77),
            offset: Offset(0, 3),
            blurRadius: 8,
            spreadRadius: -7,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w900,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}