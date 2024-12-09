import 'package:flutter/material.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/screens/iga/amasuzuma/amanota.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_overview.dart';

class AmasuzumaCard extends StatefulWidget {
  final IsuzumaModel isuzuma;

  const AmasuzumaCard({super.key, required this.isuzuma});

  @override
  State<AmasuzumaCard> createState() => _AmasuzumaCardState();
}

class _AmasuzumaCardState extends State<AmasuzumaCard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IsuzumaCardContent(isuzuma: widget.isuzuma),
            Amanota(isuzuma: widget.isuzuma),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.04,
        ),
      ],
    );
  }
}

class IsuzumaCardContent extends StatelessWidget {
  final IsuzumaModel isuzuma;

  const IsuzumaCardContent({required this.isuzuma});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IsuzumaOverview(
                    isuzuma: isuzuma,
                  )),
        );
      },
      child: Container(
        width: screenWidth * 0.4,
        decoration: BoxDecoration(
          color: const Color(0xFF00CCE5),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(
            width: screenWidth * 0.006,
            color: const Color(0xFFFFBD59),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(
                screenWidth * 0.01,
              ),
              child: Text(
                isuzuma.title.toUpperCase(),
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Container(
              color: const Color(0xFFFFBD59),
              height: screenHeight * 0.009,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Image.asset(
                'assets/images/isuzuma.png',
                height: screenHeight * 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
