import 'package:flutter/material.dart';

// ENTRY POINT
void main() {
  runApp(const TeguraApp());
}

// MAIN APP WIDGET - STATELESS SINCE IT DOESN'T CHANGE
class TeguraApp extends StatelessWidget {
  const TeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tegura',
      home: TeguraState(),
    );
  }
}

// TEGURA STATE CLASS - STATEFUL SINCE IT CHANGES
class TeguraState extends StatefulWidget {
  const TeguraState({super.key});

  // CREATE A STATE OBJECT OF TYPE _TeguraStateState
  @override
  _TeguraStateState createState() => _TeguraStateState();
}

// CLASS TO HANDLE UI STUFF - EXTENDS STATE CLASS OF TeguraState CLASS
class _TeguraStateState extends State<TeguraState> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Heading",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
                    Image.asset(
            'assets/images/my_image.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16.0),
          const Text(
            "This is some text.",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


