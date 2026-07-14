import 'dart:async';
import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/home_screen.dart';

class APMSVerificationScreen extends StatefulWidget {
  const APMSVerificationScreen({super.key});

  @override
  State<APMSVerificationScreen> createState() => _APMSVerificationScreenState();
}

class _APMSVerificationScreenState extends State<APMSVerificationScreen> {
  late Timer _timer;
  int _start = 119;

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/log.png',
                height: 44,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  children: [
                    const Text(
                      'Verify Your Identity',
                      style: TextStyle(
                        color: Color(0xFF0F1E36),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter the 4-digit code sent to +91 98765\n43210',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const OTPVerificationForm(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF6B7280), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Request new code in $timerText',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _start = 119;
                          _timer.cancel();
                          startTimer();
                        });
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Secure 256-bit encrypted verification',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPVerificationForm extends StatefulWidget {
  const OTPVerificationForm({super.key});

  @override
  State<OTPVerificationForm> createState() => _OTPVerificationFormState();
}

class _OTPVerificationFormState extends State<OTPVerificationForm> {
  final _otp1 = TextEditingController();
  final _otp2 = TextEditingController();
  final _otp3 = TextEditingController();
  final _otp4 = TextEditingController();

  @override
  void dispose() {
    _otp1.dispose();
    _otp2.dispose();
    _otp3.dispose();
    _otp4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OtpInput(controller: _otp1, first: true, last: false),
            OtpInput(controller: _otp2, first: false, last: false),
            OtpInput(controller: _otp3, first: false, last: false),
            OtpInput(controller: _otp4, first: false, last: true),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const APMSHomeScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Verify & Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
