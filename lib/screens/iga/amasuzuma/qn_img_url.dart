import 'package:flutter/material.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:transparent_image/transparent_image.dart';

class QuestionImgUrl extends StatelessWidget {
  final ScoreQuestionI currentQn;
  const QuestionImgUrl({
    super.key,
    required this.currentQn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border.fromBorderSide(
            BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: currentQn.imageUrl!,
          height: MediaQuery.of(context).size.height * 0.2,
        ),
      ),
    );
  }
}
