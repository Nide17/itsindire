import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewActionButtons extends StatefulWidget {
  final String icon;
  final String text;
  final int bgColor;
  final int color;
  final dynamic screen;
  final String? action;
  final void Function(int index) showQn;

  const ReviewActionButtons(
      {super.key,
      required this.icon,
      required this.text,
      required this.action,
      required this.bgColor,
      required this.color,
      required this.screen,
      required this.showQn});

  @override
  State<ReviewActionButtons> createState() => _ReviewActionButtonsState();
}

class _ReviewActionButtonsState extends State<ReviewActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 59, 57, 77),
            offset: Offset(0, 3),
            blurRadius: 8,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (widget.action == 'question1') {
            widget.showQn(1);
          } else if (widget.screen != null) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.screen,
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            MediaQuery.of(context).size.width * 0.4,
            MediaQuery.of(context).size.height * 0.0,
          ),
          backgroundColor: Color(widget.bgColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
        ),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.text != 'Kora irindi suzuma'
                  ? Visibility(
                      visible: true,
                      child: Opacity(
                        opacity: 1,
                        child: SvgPicture.asset(
                          widget.icon,
                          width: MediaQuery.of(context).size.width * 0.042,
                        ),
                      ),
                    )
                  : Container(),
              Text(
                widget.text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.028,
                    color: Color(widget.color)),
              ),
              widget.text == 'Kora irindi suzuma'
                  ? Visibility(
                      visible: true,
                      child: Opacity(
                        opacity: 1,
                        child: SvgPicture.asset(
                          widget.icon,
                          width: MediaQuery.of(context).size.width * 0.042,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
