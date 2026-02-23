import 'package:shared_preferences/shared_preferences.dart';

class OnboardingManager {
  static const String _key = 'onboarding_completed';

  // بررسی آیا اولین بار هست
  static Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(_key) ?? true;
      return value;
    } catch (e) {
      return true; // در صورت خطا، اولین بار در نظر بگیر
    }
  }

  // ذخیره که کاربر دیده
  static Future<void> setOnboardingSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, false);
    } catch (e) {
      // خطا را نادیده بگیر
    }
  }

  // پاک کردن برای دیباگ
  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      // خطا را نادیده بگیر
    }
  }
}

// import 'package:shared_preferences/shared_preferences.dart';

// class OnboardingManager {
//   static const String _key = 'is_first_launch';

//   static Future<bool> isFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     // ✅ برای دیباگ: همیشه true برگردون و مقدار قبلی رو پاک کن
//     await prefs.remove(_key); // این خط رو اضافه کن
//     return true; // این خط رو اضافه کن

//     // ❌ خط زیر رو موقتاً غیرفعال کن
//     // return prefs.getBool(_key) ?? true;
//   }

//   static Future<void> setOnboardingSeen() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_key, false);
//   }

//   // برای پاک کردن دستی
//   static Future<void> clear() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_key);
//   }
// }
