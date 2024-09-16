import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';

class DirectionButton extends StatelessWidget {
  // INSTANCE VARIABLES
  final String buttonText;
  final String direction;
  final double opacity;
  final int skip;
  final int limit;
  final ValueChanged<int> changeSkip;
  final IsomoModel isomo;

  const DirectionButton({
    Key? key,
    required this.buttonText,
    required this.direction,
    required this.opacity,
    required this.skip,
    required this.limit,
    required this.changeSkip,
    required this.isomo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // STATE VARIABLES
    final ingingos = Provider.of<List<IngingoModel>?>(context) ?? [];

    // RETURN THE WIDGETS
    return ElevatedButton(
      onPressed: () {
        if (direction == 'inyuma') {
          // DECREASE SKIP STATE
          changeSkip(-5);
        } else if (direction == 'komeza') {
          // INCREASE SKIP STATE
          changeSkip(5);
          // REMOVE THE CURRENT PAGE FROM THE STACK IF NO MORE NEXT PAGES
          if (ingingos.length < limit) {
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.3,
          MediaQuery.of(context).size.height * 0.0,
        ),
        backgroundColor: const Color(0xFF00CCE5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON
          Visibility(
            visible: direction == 'inyuma' ? true : false,
            child: Opacity(
              opacity: opacity,
              child: SvgPicture.asset(
                direction == 'inyuma'
                    ? 'assets/images/backward.svg'
                    : 'assets/images/forward.svg',
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
          Text(
            direction == 'komeza' && ingingos.length < limit
                ? 'Soza'
                : buttonText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: direction == 'komeza' && ingingos.length < limit
                    ? Colors.white
                    : Colors.black),
          ), // ICON
          Visibility(
            visible: direction == 'inyuma' ? false : true,
            child: Opacity(
              opacity: ingingos.length < limit ? 0.0 : opacity,
              child: SvgPicture.asset(
                direction == 'inyuma'
                    ? 'assets/images/backward.svg'
                    : 'assets/images/forward.svg',
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
