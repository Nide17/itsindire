import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
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
