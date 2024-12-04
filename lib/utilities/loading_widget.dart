import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * 0.1),
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
            color: Colors.white,
            size: size,
            secondRingColor: const Color(0XFF00CCE5),
            thirdRingColor: const Color(0xFFFFBD59)),
      ),
    );
  }
}
