import 'package:flutter/material.dart';
import 'package:advocate_app/screens/create_account_screen.dart';

class APMSOnboardingScreen extends StatelessWidget {
  const APMSOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Image.asset(
                          'assets/images/log.png',
                          height: 44,
                          fit: BoxFit.contain,
                        ),
                        const Spacer(flex: 2),
                        Image.asset(
                          'assets/images/1.png',
                          height: constraints.maxHeight * 0.42,
                          fit: BoxFit.contain,
                        ),
                        const Spacer(flex: 2),
                        const Text(
                          'Manage Your\nLegal Practice\nSmarter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Track cases, hearings, clients, reminders\nand documents in one secure place.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const Spacer(flex: 3),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const APMSCreateAccountScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
