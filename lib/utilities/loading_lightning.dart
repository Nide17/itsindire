import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/screens/home/home.dart';
import 'dart:math';

class LoadingLightning extends StatefulWidget {
  final int duration;
  const LoadingLightning({super.key, required this.duration});

  @override
  State<LoadingLightning> createState() => _LoadingLightningState();
}

class _LoadingLightningState extends State<LoadingLightning>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            const Text(
              "Iga, Umenye, Utsinde!",
              style: TextStyle(
                fontSize: 24.0,
                color: Color.fromARGB(255, 13, 173, 232),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
