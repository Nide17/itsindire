import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 71, 103, 158),
      ),
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
            color: Colors.white,
            size: 100,
            secondRingColor: const Color(0XFF00CCE5),
            thirdRingColor: const Color(0xFFFFBD59)),
      ),
    );
  }
}
