import 'package:flutter/material.dart';
import 'package:itsindire/utilities/route_action_button.dart';

const TextStyle headerTextStyle = TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: 20,
  color: Colors.white,
);

const TextStyle linkTextStyle = TextStyle(
  decoration: TextDecoration.underline,
  decorationStyle: TextDecorationStyle.dotted,
  decorationThickness: 3.0,
  decorationColor: Color(0xFFFAD201),
  color: Color(0xff14e4ff),
  fontSize: 16,
);

const TextStyle disclaimerTextStyle = TextStyle(
  color: Colors.black,
);

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
          _buildHeaderText(width),
          SizedBox(height: height * 0.05),
          _buildActionButtons(width),
        ],
      ),
    );
  }

  // Extracted header text widget
  Widget _buildHeaderText(double width) {
    return SizedBox(
      width: width * 0.7,
      child: const Text(
        'Injira niba wariyandikishije cyangwa wiyandikishe utangire kwiga!',
        textAlign: TextAlign.center,
        style: headerTextStyle,
      ),
    );
  }

  // Extracted action buttons widget
  Widget _buildActionButtons(double width) {
    return SizedBox(
      width: width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          RouteActionButton(
            btnText: 'Injira',
            route: '/injira',
          ),
          RouteActionButton(
            btnText: 'Iyandikishe',
            route: '/iyandikishe',
          ),
        ],
      ),
    );
  }
}
