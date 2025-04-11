import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class IgaCard extends StatelessWidget {
  final String title;
  final String icon;
  final Widget screen;

  const IgaCard({
    super.key,
    required this.title,
    required this.icon,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: screen,
          ),
        );
      },
      child: Container(
        width: mediaQuery.width * 0.4,
        decoration: BoxDecoration(
          color: const Color(0xFF00CCE5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 4.0,
            color: const Color(0xFFFFBD59),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: mediaQuery.width * 0.035,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                semanticsLabel: 'Card title: $title',
              ),
            ),

            // Divider Section
            Container(
              color: const Color(0xFFFFBD59),
              height: mediaQuery.height * 0.009,
            ),

            // Icon Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Image.asset(
                icon,
                height: mediaQuery.height * 0.2,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  );
                },
                semanticLabel: 'Card icon for $title',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
