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
        // height: MediaQuery.of(context).size.height * 0.08,
        margin: EdgeInsets.only(left: 0, top: marginTop ?? 24),
        padding: const EdgeInsets.fromLTRB(
            0, 4.0, 0, 4.0), // top, right, bottom, left

        // STYLING
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),

          // THE GRADIENT
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
