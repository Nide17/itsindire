import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const MessageContainer({
    required this.message,
    this.backgroundColor = const Color(0xFFFFDE59),
    this.borderColor = const Color.fromARGB(255, 255, 204, 0),
    this.borderRadius = 24.0,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final containerPadding = padding ??
        EdgeInsets.all(
          mediaQuery.width * 0.04,
        );

    return Container(
      width: mediaQuery.width * 0.8,
      margin: EdgeInsets.symmetric(
        horizontal: mediaQuery.width * 0.05,
        vertical: mediaQuery.height * 0.03,
      ),
      padding: containerPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: 2.0,
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
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
              fontSize: mediaQuery.width * 0.04,
              fontWeight: FontWeight.w900,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            semanticsLabel: 'Message: $message',
          ),
        ],
      ),
    );
  }
}