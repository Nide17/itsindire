import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/screens/home/home.dart';
import 'dart:math';

class LoadingLightning extends StatefulWidget {
  final int duration;
  const LoadingLightning({super.key, required this.duration});

  // CREATE STATE
  @override
  State<LoadingLightning> createState() => _LoadingLightningState();
}

// STATE FOR THE LOADING LIGHTNING
class _LoadingLightningState extends State<LoadingLightning>
    with SingleTickerProviderStateMixin {
  // DECLARE ANIMATION CONTROLLER AND ANIMATION VARIABLES
  late AnimationController
      _controller; // LATE KEYWORD TO INITIALIZE LATER ON RUNTIME SINCE IT'S A STATEFUL WIDGET
  late Animation<double> _animation;

  // INIT STATE METHOD TO INITIALIZE THE CONTROLLER
  @override
  void initState() {
    super.initState();

    // INITIALIZE THE CONTROLLER WITH DURATION AND VSYNC
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_controller);
    _controller.forward();

    if (widget.duration > 0) {
      Future.delayed(Duration(seconds: widget.duration), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,

      // BACKGROUND IMAGE OF THE APP
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),

      // COLUMN WIDGET TO HOLD THE CHILDREN
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.24),
        const Text(
          "ITSINDIRE",
          style: TextStyle(
            fontSize: 32.0,
            color: Color(0xFFFAD201),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        // SVG IMAGE OF THE APP LOADING
        Container(
          padding: const EdgeInsets.all(4.0),
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF20603D),
              width: 12.0,
            ),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: SvgPicture.asset('assets/images/lightning.svg'),
              );
            },
          ),
        ),

        // TEXT WIDGET TO DISPLAY THE APP MESSAGE
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        const Text(
          "Iga, Umenye, Utsinde!",
          style: TextStyle(
            fontSize: 24.0,
            color: Color.fromARGB(255, 13, 173, 232),
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    ));
  }

  // DISPOSE METHOD TO DISPOSE THE CONTROLLER AFTER USE
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // STOP AFTER 4 SECONDS AND GO TO THE NEXT PAGE
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });
  }
}
