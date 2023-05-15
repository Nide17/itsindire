import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  // INSTANCE VARIABLES
  final String text;

  // CONSTRUCTOR
  const Description({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),

      // TEXT WIDGET TO DISPLAY THE TEXT
      Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 12.0, 16.0, 12.0), // Add 16.0 pixels of padding to all sides
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // BORDER
      Container(
        color: const Color(0xFF000000),
        height: MediaQuery.of(context).size.height * 0.01,
      ),
    ]);
  }
}
