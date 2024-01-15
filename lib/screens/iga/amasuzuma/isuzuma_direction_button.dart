import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';

class IsuzumaDirectionButton extends StatefulWidget {
  final String direction;
  final Function? forward;
  final Function? backward;
  final int currQnID;
  final int qnsLength;

  const IsuzumaDirectionButton({
    super.key,
    required this.direction,
    this.forward,
    this.backward,
    required this.currQnID,
    required this.qnsLength,
  });

  @override
  State<IsuzumaDirectionButton> createState() => _IsuzumaDirectionButtonState();
}

class _IsuzumaDirectionButtonState extends State<IsuzumaDirectionButton> {
  @override
  Widget build(BuildContext context) {
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
            if (widget.currQnID == 1) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const TeguraAlert(
                      errorTitle: 'Ikosa!',
                      errorMsg: 'Iki ni ikibazo cya mbere!',
                      alertType: 'warning',);
                },
              );
            } else {
              widget.backward!();
            }
          } else if (widget.direction == 'komeza') {
            if (widget.currQnID == widget.qnsLength) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const TeguraAlert(
                      errorTitle: 'Ikosa!',
                      errorMsg: 'Iki ni ikibazo cya nyuma!',
                      alertType: 'warning',);
                },
              );
            } else {
              widget.forward!();
            }
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
