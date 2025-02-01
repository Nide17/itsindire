import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itsindire/models/pop_question.dart';

class DirectionButtonPq extends StatefulWidget {
  final String buttonText;
  final String direction;
  final double opacity;
  final Function()? forward;
  final Function()? backward;
  final List<PopQuestionModel> pagePopQuestions;
  final int? currentQuestionNo;
  final bool isDisabled;

  const DirectionButtonPq({
    super.key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    this.forward,
    this.backward,
    required this.pagePopQuestions,
    this.currentQuestionNo,
    required this.isDisabled,
  });

  @override
  State<DirectionButtonPq> createState() => _DirectionButtonPqState();
}

class _DirectionButtonPqState extends State<DirectionButtonPq> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isDisabled ? null : _handleButtonPress,
      style: _buttonStyle(context),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(context, isBackward: true),
            Text(
              widget.buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: Colors.black),
            ),
            _buildIcon(context, isBackward: false),
          ],
        ),
      ),
    );
  }

  void _handleButtonPress() {
    final int lastQuestion = widget.pagePopQuestions.length;
    if (widget.direction == 'inyuma') {
      widget.backward!();
      if (widget.currentQuestionNo == 1) {
        Navigator.pop(context);
      }
    } else if (widget.direction == 'komeza') {
      widget.forward!();
      if (widget.currentQuestionNo == lastQuestion) {
        Navigator.pop(context);
      }
    }
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.3,
        MediaQuery.of(context).size.height * 0.0,
      ),
      backgroundColor: widget.isDisabled
          ? const Color(0xFF00CCE5).withValues(alpha: 0.4)
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
    );
  }

  Widget _buildIcon(BuildContext context, {required bool isBackward}) {
    final int lastQuestion = widget.pagePopQuestions.length;
    return Visibility(
      visible: isBackward
          ? widget.direction == 'inyuma'
          : widget.direction == 'komeza',
      child: Opacity(
        opacity: isBackward || widget.currentQuestionNo == lastQuestion
            ? 1.0
            : widget.opacity,
        child: SvgPicture.asset(
          isBackward
              ? 'assets/images/backward.svg'
              : 'assets/images/forward.svg',
          width: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
    );
  }
}
