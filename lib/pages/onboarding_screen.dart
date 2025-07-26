import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'homepage.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? size.width * 0.2 : 20,
            vertical: isWide ? 60 : 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/splash1.json',
                height: isWide ? size.height * 0.5 : size.height * 0.4,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to Market Movers",
                style: TextStyle(
                  fontSize: isWide ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Track your favorite cryptocurrencies easily with real-time updates and trends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWide ? 18 : 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(isWide ? 200 : 150, 48),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: const Text("Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


