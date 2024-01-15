import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class QBAppFooter extends StatelessWidget {
  const QBAppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.0091,
          ),
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.024,
          ),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
        Text(
          'For more info, Contact Us:',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.048,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * 0.024,
          ),
          itemBuilder: (context, index) {
            return TextButton(
              onPressed: () => _handleClick(_icons[index]['url']),
              child: Row(
                children: [
                  SvgPicture.asset(
                    _icons[index]['icon'],
                    height: MediaQuery.of(context).size.height * 0.028,
                    colorFilter: _icons[index]['url'].contains('www')
                        ? null
                        : const ColorFilter.mode(
                            Color.fromARGB(255, 0, 0, 0),
                            BlendMode.srcIn,
                          ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Text(
                    _icons[index]['title'],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: _icons[index]['title'].contains('@') ||
                              _icons[index]['title'].contains('www')
                          ? const Color.fromARGB(255, 0, 102, 185)
                          : Colors.black,
                      fontWeight: FontWeight.w900,
                      decoration: _icons[index]['title'].contains('@') ||
                              _icons[index]['title'].contains('www')
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: _icons.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '~We are Quiz Blog - Learning & Quizzing~',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.036,
              color: const Color(0xFF00A651),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

// List of icons and their links or texts
List<Map<String, dynamic>> _icons = [
  {
    'icon': 'assets/images/whatsapp.svg',
    'title': '0794033360',
    'url': 'https://wa.me/+250794033360',
  },
  {
    'icon': 'assets/images/web.svg',
    'title': 'www.quizblog.rw',
    'url': 'https://www.quizblog.rw',
  },
  {
    'icon': 'assets/images/email.svg',
    'title': 'quizblog.rw@gmail.com',
    'url': 'mailto:quizblog.rw@gmail.com',
  },
  {
    'icon': 'assets/images/twitter.svg',
    'title': 'QuizblogRw',
    'url': 'https://twitter.com/QuizblogRw',
  },
  {
    'icon': 'assets/images/instagram.svg',
    'title': 'quizblogrw',
    'url': 'https://www.instagram.com/quizblogrw',
  },
  {
    'icon': 'assets/images/linkedin.svg',
    'title': 'quiz-blog',
    'url': 'https://www.linkedin.com/company/quiz-blog',
  },
  {
    'icon': 'assets/images/facebook.svg',
    'title': 'QuizblogRw',
    'url': 'https://www.facebook.com/QuizblogRw',
  },
];

// Handle the click with corresponding link or text
void _handleClick(String url) async {
  if (url.contains('0794033360')) {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // Send email
  else if (url.contains('mailto:')) {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // Open url
  else {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
