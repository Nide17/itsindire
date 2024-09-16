// WIDGET FOR HOLDING THE APPBAR
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/services/auth.dart';
class AppBarTegura extends StatelessWidget {
  const AppBarTegura({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER
    final usr = Provider.of<UserModel?>(context);

    // GET PROVIDER USER PROFILE
    final profile = Provider.of<ProfileModel?>(context);

    // PRINT THE USER ID
    if (kDebugMode) {
      print("AppBar UID: ${usr?.uid} --- AppBar Email: ${usr?.email}");

      // PRINT THE USER PROFILE
      print(profile?.username);
    }

    return AppBar(
      backgroundColor: const Color(0xFF5B8BDF),
      automaticallyImplyLeading: false,

      // BOTTOM BORDER OF THE APP BAR
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(18.0),
        child: Container(
          color: const Color(0xFFFFBD59),
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ),
      title: Row(
        children: <Widget>[
          // ARRAY OF WIDGETS - ROW
          SvgPicture.asset(
            'assets/images/car.svg',
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          // SPACING BETWEEN THE TWO WIDGETS
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.013,
          ),
          Text('Tegura.rw', // TEXT WIDGET
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              )),
        ],
      ),

      // USER PROFILE ICON BUTTON - RIGHT SIDE OF THE APP BAR
      // CHECK IF USER IS LOGGED IN OR NOT BEFORE
      actions: <Widget>[
        // IF USER IS LOGGED IN
        if (usr != null)
          IconButton(
            // USE CUSTOM ICON - SVG
            icon: SvgPicture.asset(
              'assets/images/avatar.svg',
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            onPressed: () {
              // OPEN A DIALOG BOX TO DISPLAY USER DETAILS AND LOGOUT BUTTON
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('User Details'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          const Text('Name: Anon'),
                          Text('UID: ${usr.uid}'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          // CLOSE THE DIALOG BOX
                          Navigator.of(context).pop();

                          // LOGOUT THE USER USING THE AUTH SERVICE INSTANCE
                          AuthService().logOut();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
