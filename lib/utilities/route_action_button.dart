import 'package:flutter/material.dart';

class RouteActionButton extends StatelessWidget {
  final String btnText;
  final String? route;
  final Function? action;

  const RouteActionButton({required this.btnText, this.route, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: route != null
            ? () {
                Navigator.pushNamed(context, route!);
              }
            : action != null
                ? () {
                    action!();
                  }
                : () {
                    print('No action provided');
                  },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            MediaQuery.of(context).size.width * 0.4,
            MediaQuery.of(context).size.height * 0.06,
          ),
          backgroundColor: const Color(0xFF00CCE5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                color: const Color.fromARGB(255, 0, 0, 0),
                style: BorderStyle.solid,
                width: MediaQuery.of(context).size.width * 0.008,
              )),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.01),
        ),
        child: Text(
          btnText,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
