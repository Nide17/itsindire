import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final double paddingFactor;

  /// A customizable loading widget with a discrete circle animation.
  const LoadingWidget({
    super.key,
    this.size = 100,
    this.primaryColor = Colors.white,
    this.secondaryColor = const Color(0XFF00CCE5),
    this.tertiaryColor = const Color(0xFFFFBD59),
    this.paddingFactor = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * paddingFactor),
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
          color: primaryColor,
          size: size,
          secondRingColor: secondaryColor,
          thirdRingColor: tertiaryColor,
        ),
      ),
    );
  }
}
