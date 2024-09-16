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
  @override
  Widget build(BuildContext context) {
    // RETURN THE WIDGETS
    return ElevatedButton(
      onPressed: () {
        if (widget.direction == 'inyuma' && widget.isDisabled == false) {
          // DECREASE SKIP STATE
          widget.backward!();

          // REMOVE THE CURRENT PAGE FROM THE STACK IF NO MORE PREVIOUS PAGES
          if (widget.currQnID == 0) {
            Navigator.pop(context);
          }
        } else if (widget.direction == 'komeza' && widget.isDisabled == false) {
          // INCREASE SKIP STATE
          widget.forward!();

          // REMOVE THE CURRENT PAGE FROM THE STACK IF NO MORE NEXT PAGES
          if (widget.currQnID == widget.lastQn) {
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.21,
          MediaQuery.of(context).size.height * 0.0,
        ),
        backgroundColor: widget.isDisabled
            ? const Color(0xFF00CCE5).withOpacity(0.4)
            : const Color(0xFF00CCE5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON
            Visibility(
              visible: widget.direction == 'inyuma' ? true : false,
              child: Opacity(
                opacity: widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
            Text(
              widget.buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.024,
                  color: Colors.black),
            ), // ICON
            Visibility(
              visible: widget.direction == 'inyuma' ? false : true,
              child: Opacity(
                opacity:
                    widget.currQnID == widget.lastQn ? 1.0 : widget.opacity,
                child: SvgPicture.asset(
                  widget.direction == 'inyuma'
                      ? 'assets/images/backward.svg'
                      : 'assets/images/forward.svg',
                  width: MediaQuery.of(context).size.width * 0.032,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
