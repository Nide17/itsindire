import 'package:flutter/material.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/screens/iga/baza/contact_form.dart';
import 'package:tegura/screens/iga/baza/social.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/app_bar.dart';

class Baza extends StatefulWidget {
  const Baza({super.key});

  @override
  State<Baza> createState() => _BazaState();
}

class _BazaState extends State<Baza> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarTegura(),
        ),
        body: ListView(children: <Widget>[
          const GradientTitle(
              title: 'BAZA MWARIMU', icon: 'assets/images/ibibazo_bibaza.svg'),

          // 2. DESCRIPTION
          const Description(
              text: 'Ugize ikibazo? Hari ibyo utumva neza? Tubaze tugufashe!'),

          // 3. CONTACT FORM
          const ContactForm(),

          // BORDER
          Container(
            color: const Color(0xFF000000),
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          // SOCIAL MEDIA
          const Social(),
        ]),
        bottomNavigationBar: const RebaIbiciro());
  }
}
