import 'package:flutter/material.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:itsindire/screens/iga/baza/contact_form.dart';
import 'package:itsindire/screens/iga/baza/social.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';

class Baza extends StatefulWidget {
  const Baza({super.key});

  @override
  State<Baza> createState() => _BazaState();
}

class _BazaState extends State<Baza> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 71, 103, 158),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarItsindire(),
      ),
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFFFFBD59)),
          radius: const Radius.circular(8.0),
          thickness: WidgetStateProperty.all(6.0),
        ),
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              // Gradient title section
              const GradientTitle(
                title: 'BAZA MWARIMU',
                icon: 'assets/images/ibibazo_bibaza.svg',
              ),

              // Description section
              const Description(
                text: 'Ugize ikibazo? Hari ibyo utumva neza? Tubaze tugufashe!',
              ),

              // Contact form section
              const ContactForm(),

              // Divider section
              Container(
                color: const Color(0xFF000000),
                height: mediaQuery.height * 0.01,
              ),

              // Spacing
              SizedBox(height: mediaQuery.height * 0.05),

              // Social media section
              const Social(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const RebaIbiciro(),
    );
  }
}
