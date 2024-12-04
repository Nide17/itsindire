import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itsindire/models/pop_question.dart';

class DirectionButtonPq extends StatefulWidget {
  final String buttonText;
  final String direction;
  final double opacity;
  final Function()? forward;
  final Function()? backward;
  final List<PopQuestionModel> popQuestions;
  final int? currQnID;
  final bool isDisabled;

  const DirectionButtonPq({
    super.key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    this.forward,
    this.backward,
    required this.popQuestions,
    this.currQnID,
    required this.isDisabled,
  });

  @override
  State<DirectionButtonPq> createState() => _DirectionButtonPqState();
}

class _DirectionButtonPqState extends State<DirectionButtonPq> {
  @override
  Widget build(BuildContext context) {
    final int lastQn = (widget.popQuestions.length) - 1;

    return ElevatedButton(
      onPressed: () {
        if (widget.direction == 'inyuma' && widget.isDisabled == false) {
          widget.backward!();
          if (widget.currQnID == 0) {
            Navigator.pop(context);
          }
        } else if (widget.direction == 'komeza' && widget.isDisabled == false) {
          widget.forward!();
          if (widget.currQnID == lastQn) {
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.3,
          MediaQuery.of(context).size.height * 0.0,
        ),
        backgroundColor: widget.isDisabled
            ? const Color(0xFF00CCE5).withOpacity(0.4)
            : const Color(0xFF00CCE5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: BorderSide(
              color: const Color.fromARGB(255, 0, 0, 0),
              style: BorderStyle.solid,
              width: MediaQuery.of(context).size.width * 0.005,
            )),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.01),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.direction == 'inyuma' ? true : false,
              child: Opacity(
                opacity: widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
            Text(
              widget.buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: Colors.black),
            ),
            Visibility(
              visible: widget.direction == 'inyuma' ? false : true,
              child: Opacity(
                opacity: widget.currQnID == lastQn ? 1.0 : widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}