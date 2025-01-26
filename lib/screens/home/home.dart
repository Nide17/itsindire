import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/utilities/view_not_logged_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:itsindire/utilities/route_action_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/utilities/string_utils.dart'; // New import for capitalizeWords utility

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openLink(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      String msg = DateTime.now().hour < 12 ? 'Mwaramutse' : 'Mwiriwe';
      String username = authState.currentProfile?.username ?? '';
      String? displayMsg = username.isNotEmpty
          ? '$msg, ${capitalizeWords(username.split(' ')[0])}!'
          : '$msg!';

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              displayMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Text(
                "Iga amategeko y'umuhanda utavunitse kandi udahenzwe!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.054,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                bottom: BorderSide(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.03,
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Text(
                  "Amasomo ateguwe muburyo bufasha umunyeshuri gusobanukirwa neza amategeko y'umuhanda ndetse agategurwa kuzakora ikizamini cya provisoire, agatsinda ntankomyi!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.042,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            KandaSection(
                titleText: "Kanda aha utangire kwiga",
                btnText: 'KWIGA',
                route: '/iga-landing'),
            KandaSection(
              titleText: 'Kanda aha ubone ibiciro byo kwiga',
              btnText: 'IBICIRO',
              route: '/ibiciro',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.032,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _openLink(
                      'https://www.quizblog.online/itsindire-privacy'),
                  child: Text(
                    'Privacy Policy',
                    style: linkTextStyle,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () => _showDisclaimerDialog(context),
                  child: Text(
                    'Disclaimer',
                    style: linkTextStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Disclaimer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              text:
                  'This app is intended for educational purposes only and is neither affiliated with nor endorsed by the Rwandan government or National Police. It utilizes publicly available resources to support learners. The app assumes no responsibility for any misuse of the provided materials. For official information, ',
              style: disclaimerTextStyle,
              children: [
                TextSpan(
                  text: 'please refer to the Rwanda National Police website.',
                  style: linkTextStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openLink(
                        'https://police.gov.rw/uploads/tx_download/Iteka_rya_Perezida_no_85_01_ryo_ku_wa_02_09_2002_rishyiraho_amabwiriza_rusange_agenga_imihanda_n_uburyo_bwo_kuyigendamo.pdf'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable button widget for navigating to the 'Iga' and 'Ibiciro' screens
class KandaSection extends StatelessWidget {
  final String titleText;
  final String btnText;
  final String route;

  const KandaSection(
      {required this.titleText, required this.btnText, required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.032,
        ),
        Text(
          titleText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.016,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: SvgPicture.asset(
            'assets/images/down_arrow.svg',
            height: MediaQuery.of(context).size.height * 0.04,
          ),
        ),
        RouteActionButton(btnText: btnText, route: route)
      ],
    );
  }
}
