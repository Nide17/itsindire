import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DirectionButtonIsuzume extends StatefulWidget {
  final String buttonText;
  final String direction;
  final double opacity;
  final Function? forward;
  final Function? backward;
  final int lastQn;
  final int currQnID;
  final bool isDisabled;

  const DirectionButtonIsuzume({
    super.key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    this.forward,
    this.backward,
    required this.lastQn,
    required this.currQnID,
    required this.isDisabled,
  });

  @override
  State<DirectionButtonIsuzume> createState() => _DirectionButtonIsuzumeState();
}

class _DirectionButtonIsuzumeState extends State<DirectionButtonIsuzume> {
  void _handleOnPressed() {
    if (widget.isDisabled) return;

    if (widget.direction == 'inyuma') {
      widget.backward!();
      if (widget.currQnID == 0) {
        Navigator.pop(context);
      }
    } else if (widget.direction == 'komeza') {
      widget.forward!();
      if (widget.currQnID == widget.lastQn) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildIcon(String direction, double opacity) {
    return Opacity(
      opacity: opacity,
      child: SvgPicture.asset(
        direction == 'inyuma'
            ? 'assets/images/backward.svg'
            : 'assets/images/forward.svg',
        width: MediaQuery.of(context).size.width * 0.03,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleOnPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isDisabled
            ? const Color(0xFF00CCE5).withOpacity(0.4)
            : const Color(0xFF00CCE5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: BorderSide(
            color: const Color.fromARGB(255, 0, 0, 0),
            style: BorderStyle.solid,
            width: MediaQuery.of(context).size.width * 0.005,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.036,
          vertical: 0.0,
        ),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.direction == 'inyuma',
              child: _buildIcon(widget.direction, widget.opacity),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              widget.buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.024,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Visibility(
              visible: widget.direction != 'inyuma',
              child: _buildIcon(
                widget.direction,
                widget.currQnID == widget.lastQn ? 1.0 : widget.opacity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
