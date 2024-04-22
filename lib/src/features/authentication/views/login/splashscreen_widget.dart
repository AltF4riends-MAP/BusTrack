import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3100),
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller)
      ..addListener(() {
        setState(() {}); // Trigger a rebuild when animation updates
      });
    _controller.repeat(); // Start the animation loop

    // Navigate to the next screen after 3 seconds
    Future.delayed(Duration(milliseconds: 3435), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(128, 0, 0, 1),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                size: Size.square(200),
                painter: CirclePainter(
                  color: Colors.white,
                  radius: 175,
                  angle: _animation.value,
                ),
              ),
            ),
            Center(
              child: Text(
                "Made By AltF4riends",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final double radius;
  final double angle;

  CirclePainter({
    required this.color,
    required this.radius,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final circleCenter = Offset(centerX, centerY);

    final rect = Rect.fromCircle(center: circleCenter, radius: radius);
    final startAngle = -pi / 2;
    final sweepAngle = angle;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
