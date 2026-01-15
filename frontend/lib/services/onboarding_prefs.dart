import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  static const _keyOnboardingCompleted = 'onboarding_completed';

  // Returns true if onboarding has already been completed at least once.
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // Marks onboarding as completed so it won't be shown on future launches.
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }
}
