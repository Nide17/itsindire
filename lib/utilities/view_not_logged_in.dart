import 'package:flutter/material.dart';
import 'package:itsindire/utilities/route_action_button.dart';

class ViewNotLoggedIn extends StatelessWidget {
  const ViewNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 4. TEXT Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!
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

        // 5. ADD 10.0 PIXELS OF SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),

        // 6. BUTTONS FOR INJIRA & IYANDIKISHE
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
    );
  }
}
