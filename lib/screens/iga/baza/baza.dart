import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/baza/contact_form.dart';
import 'package:tegura/screens/iga/baza/social.dart';
import 'package:tegura/screens/iga/gradient_title.dart';
import 'package:tegura/screens/my_appbar.dart';

class Baza extends StatefulWidget {
  const Baza({Key? key}) : super(key: key);

  @override
  BazaState createState() => BazaState();
}

class BazaState extends State<Baza> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    // const usr = null;
    if (kDebugMode) {
      print(usr?.uid);
    }

    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size * 0.07,
          child: const AppBarTegura(),
        ),

        // PAGE BODY
        body: ListView(children: <Widget>[
          // 1. GRADIENT TITLE
          GradientTitle(
              title: 'Baza mwarimu', icon: 'assets/images/ibibazo_bibaza.svg'),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // TEXT WIDGET TO DISPLAY THE TEXT
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0,
                8.0), // Add 16.0 pixels of padding to all sides
            child: Text(
              "Ugize ikibazo? Hari ibyo utumva neza? Tubaze tugufashe!",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // BORDER
          Container(
            color: const Color(0xFF000000),
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          const ContactForm(),

          // BORDER
          Container(
            color: const Color(0xFF000000),
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          // VERTICAL SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          // SOCIAL MEDIA
          const Social(),
        ]),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: const RebaIbiciro());
  }
}
