// WIDGET FOR HOLDING TITLE WITH ICON AND TEXT
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientTitle extends StatelessWidget {
  final String title;
  final String icon;
  final double? marginTop;
  final String? parentWidget;

  const GradientTitle(
      {super.key,
      required this.title,
      required this.icon,
      this.marginTop,
      this.parentWidget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(
            left: 0,
            top: marginTop ?? 24,
            bottom: MediaQuery.of(context).size.height * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.0001,
            vertical: MediaQuery.of(context).size.height * 0.012),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            width: MediaQuery.of(context).size.width * 0.006,
            color: parentWidget == 'isuzume'
                ? const Color(0xFF5B8BDF)
                : const Color(0xFF9D14DD),
          ),
          gradient: parentWidget == 'isuzume'
              ? null
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.2677, 0.8325],
                  colors: [
                    Color(0xFF0500E5),
                    Color(0xFF9D14DD),
                  ],
                ),
          boxShadow: parentWidget == 'isuzume'
              ? null
              : const [
                  BoxShadow(
                    color: Color.fromARGB(255, 7, 25, 40),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),

        // CONTENT
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // HORIZONTAL SPACE
            if (icon != '')
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),

            // SVG ICON
            if (icon != '')
              SvgPicture.asset(icon,
                  width: MediaQuery.of(context).size.width * 0.05,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF5B8BDF), BlendMode.srcIn)),
            // HORIZONTAL SPACE
            if (icon != '')
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),

            // TEXT WIDGET
            Flexible(
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: parentWidget == 'isuzume'
                      ? MediaQuery.of(context).size.width * 0.04
                      : MediaQuery.of(context).size.width * 0.045,
                  color:
                      parentWidget == 'isuzume' ? Colors.black : Colors.white,
                  fontWeight: parentWidget == 'isuzume'
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
