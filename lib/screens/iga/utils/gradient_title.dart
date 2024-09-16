// WIDGET FOR HOLDING TITLE WITH ICON AND TEXT
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientTitle extends StatelessWidget {
// INSTANCE VARIABLES
  final String title;
  final String icon;
  final double? marginTop;
  final String? parentWidget;

// CONSTRUCTOR
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
        margin: EdgeInsets.only(left: 0, top: marginTop ?? 24),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.0001,
            vertical: MediaQuery.of(context).size.height * 0.016),
        // STYLING
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
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
                    color: Color.fromARGB(255, 70, 227, 255),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: -7,
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
                width: MediaQuery.of(context).size.width * 0.03,
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
                width: MediaQuery.of(context).size.width * 0.03,
              ),

            // TEXT WIDGET
            Flexible(
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: parentWidget == 'isuzume'
                      ? MediaQuery.of(context).size.width * 0.035
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
