// WIDGET TO DISPLAY REBA IBICIRO BUTTON ON THE BOTTOM
import 'package:flutter/material.dart';

class RebaIbiciro extends StatelessWidget {
  const RebaIbiciro({super.key});

  // BUILD METHOD TO BUILD THE UI OF THE BOTTOM BUTTON
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ibiciro');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00CCE5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5.0,
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: Text(
            'Reba ibiciro byo kwiga',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
