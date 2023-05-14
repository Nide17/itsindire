import 'package:flutter/material.dart';
import 'package:tegura/screens/utilities/my_appbar.dart';

class Ibiciro extends StatefulWidget {
  const Ibiciro({Key? key}) : super(key: key);

  @override
  _IbiciroState createState() => _IbiciroState();
}

class _IbiciroState extends State<Ibiciro> {

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B8BDF),

      // APP BAR
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarTegura(),
      ),
      // PAGE BODY
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
