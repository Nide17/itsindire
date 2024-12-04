import 'package:flutter/material.dart';
import 'package:itsindire/utilities/route_action_button.dart';

class ViewNotLoggedIn extends StatelessWidget {
  const ViewNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              'Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RouteActionButton(btnText: 'Injira', route: '/injira'),
                RouteActionButton(btnText: 'Iyandikishe', route: '/iyandikishe'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
