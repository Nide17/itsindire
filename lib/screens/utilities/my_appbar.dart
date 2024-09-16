// WIDGET FOR HOLDING THE APPBAR
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';

class AppBarTegura extends StatelessWidget {
  const AppBarTegura({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER
    // final usr = Provider.of<UserModel?>(context);
    const usr = null;

    // if (kDebugMode) {
    //   print(usr?.uid);
    // }

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
              // DO: VIEW PROFILE, LOGOUT, ETC.
            },
          ),
      ],
    );
  }
}
