import 'package:flutter/material.dart';
import 'package:itsindire/utilities/route_action_button.dart';

class ViewNotLoggedIn extends StatelessWidget {
  const ViewNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.03),
      child: Column(
        children: [
          SizedBox(
            width: width * 0.7,
            child: const Text(
              'Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20, // Adjusted to a fixed size for consistency
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.06,
          ),
          SizedBox(
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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
