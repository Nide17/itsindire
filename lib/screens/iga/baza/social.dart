// WIDGET FOR HOLDING TITLE WITH ICON AND TEXT
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/screens/iga/baza/social_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 4.0,
          color: const Color(0xFFFFBD59),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 43, 43, 43),
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 71, 103, 158),
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var social in socialData)
            SocialMediaButton(
              icon: social['icon'] ?? '',
              title: social['title'] ?? '',
              url: social['url'] ?? '',
              mediaQuery: mediaQuery,
            ),
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final String icon;
  final String title;
  final String url;
  final Size mediaQuery;

  const SocialMediaButton({
    required this.icon,
    required this.title,
    required this.url,
    required this.mediaQuery,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: TextButton(
        onPressed: () => _handleClick(url, context),
        child: Row(
          children: <Widget>[
            SizedBox(width: mediaQuery.width * 0.04),
            SvgPicture.asset(
              icon,
              height: mediaQuery.height * 0.045,
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 255, 255, 255),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: mediaQuery.width * 0.02),
            Text(
              '  $title',
              style: TextStyle(
                fontSize: mediaQuery.width * 0.045,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _handleClick(String url, BuildContext context) async {
  final Uri _url = Uri.parse(url);

  if (!await launchUrl(_url, mode: LaunchMode.inAppBrowserView)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $url')),
    );
  }
}
