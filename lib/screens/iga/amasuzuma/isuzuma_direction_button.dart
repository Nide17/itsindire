import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IsuzumaDirectionButton extends StatefulWidget {
  // INSTANCE VARIABLES
  final String direction;
  final Function? forward;
  final Function? backward;
  final int currQnID;
  final int qnsLength;

  const IsuzumaDirectionButton({
    Key? key,
    required this.direction,
    this.forward,
    this.backward,
    required this.currQnID,
    required this.qnsLength,
  }) : super(key: key);

  @override
  State<IsuzumaDirectionButton> createState() => _IsuzumaDirectionButtonState();
}

class _IsuzumaDirectionButtonState extends State<IsuzumaDirectionButton> {
  @override
  Widget build(BuildContext context) {
    // CHECK IF THE BUTTON IS DISABLED
    bool isDisabled = widget.direction == 'inyuma' && widget.currQnID <= 1
        ? true
        : widget.direction == 'komeza' && widget.currQnID >= widget.qnsLength
            ? true
            : false;

    // RETURN THE WIDGETS
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.direction == 'inyuma'
                ? const Color.fromARGB(255, 238, 225, 45)
                    .withOpacity(isDisabled ? 0.7 : 1)
                : const Color.fromARGB(255, 18, 182, 86)
                    .withOpacity(isDisabled ? 0.7 : 1),
            offset: const Offset(0, 3),
            blurRadius: 8,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (widget.direction == 'inyuma' && (widget.currQnID >= 1)) {
            // DECREASE SKIP STATE
            widget.backward!();

            // IF NO MORE PREVIOUS PAGES, ALERT THE USER
            if (widget.currQnID == 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Iki kibazo nicyo cya ${widget.currQnID}!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else if (widget.direction == 'komeza' &&
              widget.currQnID <= widget.qnsLength) {
            // INCREASE SKIP STATE
            widget.forward!();

            // IF NO MORE NEXT PAGES, ALERT THE USER
            if (widget.currQnID == widget.qnsLength) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Iki kibazo cya ${widget.qnsLength} nicyo cyanyuma!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // DO NOTHING
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            MediaQuery.of(context).size.width * 0.21,
            MediaQuery.of(context).size.height * 0.0,
          ),
          backgroundColor: isDisabled
              ? const Color(0xFF1B56CB).withOpacity(0.4)
              : const Color(0xFF1B56CB),
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
                  opacity: 1,
                  child: SvgPicture.asset(
                    widget.direction == 'inyuma'
                        ? 'assets/images/backward.svg'
                        : 'assets/images/forward.svg',
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
              Text(
                widget.direction,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.024,
                    color: Colors.white),
              ), // ICON
              Visibility(
                visible: widget.direction == 'inyuma' ? false : true,
                child: Opacity(
                  opacity: widget.currQnID == widget.qnsLength ? 0.8 : 1.0,
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
      ),
    );
  }
}
