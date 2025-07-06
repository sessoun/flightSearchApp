import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final AnimationController heroController;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.heroController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Hero icon
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(data.heroIcon, size: 80, color: Colors.white),
            ),

            const SizedBox(height: 40),

            // Feature icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(data.icon, size: 32, color: Colors.white),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              data.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final Color color;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData heroIcon;

  OnboardingData({
    required this.color,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.heroIcon,
  });
}
