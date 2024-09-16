import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5B8BDF),
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.yellow[400],
          size: 80.0,
        ),
      ),
    );
  }
}
