import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformService {
  // تشخیص پلتفرم فعلی
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isDesktop => !kIsWeb && (isWindows || isMacOS || isLinux);
  static bool get isMobile => !kIsWeb && (isAndroid || isIOS);
  static bool get isWeb => kIsWeb;
  
  // دریافت نام پلتفرم فارسی
  static String get platformName {
    if (isWeb) return 'وب';
    if (isAndroid) return 'اندروید';
    if (isIOS) return 'آی‌اواس';
    if (isLinux) return 'لینوکس';
    if (isWindows) return 'ویندوز';
    if (isMacOS) return 'مک';
    return 'نامشخص';
  }
}
