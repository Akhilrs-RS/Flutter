import 'dart:async';
import 'package:flutter/material.dart';
import 'package:advocate_app/screens/onboarding_screen.dart';

class APMSSplashScreen extends StatefulWidget {
  const APMSSplashScreen({super.key});

  @override
  State<APMSSplashScreen> createState() => _APMSSplashScreenState();
}

class _APMSSplashScreenState extends State<APMSSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const APMSOnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Image.asset(
            'assets/images/log.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
