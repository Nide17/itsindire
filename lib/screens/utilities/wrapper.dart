import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/auth/auth.dart';
import 'package:tegura/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER
    final usr = Provider.of<UserModel?>(context);
    // const usr = null;

    // print(usr?.uid);
    // RETURN A WIDGET BASED ON THE AUTH STATE - HOME OR AUTH
    if (usr == null) {
      return const Auth();
    } else {
      return const Home();
    }
  }
}
