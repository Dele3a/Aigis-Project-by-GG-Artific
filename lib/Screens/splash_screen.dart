import 'package:flutter/material.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    // Text animation controller
    _textController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF0A0A0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Shield Logo
              AnimatedBuilder(
                animation: _logoController,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: sin(_logoController.value * pi) * 0.1,
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.7),
                            blurRadius: 25 + (_logoController.value * 20),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield_outlined,
                          color: Colors.amber,
                          size: 70,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // Futuristic Text with Fade Animation
              FadeTransition(
                opacity: _textController,
                child: const Text(
                  'Welcome to Aigis',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    color: Colors.amber,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              FadeTransition(
                opacity: _textController,
                child: Text(
                  'Your AI Guardian',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    color: Colors.amber.withOpacity(0.7),
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Neon Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.amberAccent,
                  side: const BorderSide(color: Colors.amber, width: 2),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
