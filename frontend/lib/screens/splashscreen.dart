import 'package:flutter/material.dart';
import '../services/onboarding_prefs.dart';
import 'onboarding_screen.dart';
import 'setup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOut,
          onEnd: () async {
            // Decide where to go after splash based on onboarding completion.
            final completed = await OnboardingPrefs.isOnboardingCompleted();
            final nextScreen =
                completed ? const SetupScreen() : const OnboardingScreen();

            if (!context.mounted) return;

            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
          },
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.98 + (0.02 * value),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo/quiz_flow_logo.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                'QuizFlow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Focused learning, one session at a time',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
