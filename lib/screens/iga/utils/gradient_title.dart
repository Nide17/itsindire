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
    final bool isIsuzume = parentWidget == 'isuzume';

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
            color: isIsuzume
                ? const Color(0xFF5B8BDF)
                : const Color(0xFF9D14DD),
          ),
          gradient: isIsuzume
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
          boxShadow: isIsuzume
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
            if (icon.isNotEmpty) ...[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              SvgPicture.asset(icon,
                  width: MediaQuery.of(context).size.width * 0.05,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF5B8BDF), BlendMode.srcIn)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
            ],
            Flexible(
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isIsuzume
                      ? MediaQuery.of(context).size.width * 0.04
                      : MediaQuery.of(context).size.width * 0.045,
                  color:
                      isIsuzume ? Colors.black : Colors.white,
                  fontWeight: isIsuzume
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
