import 'package:flutter/material.dart';

/// انواع روش‌های احراز هویت - مدل اختصاصی خودمون
enum MyBiometricType {
  fingerprint,
  face,
  iris,
  other,
}

/// پسوند برای تبدیل به متن فارسی و آیکون
extension BiometricTypeExtension on MyBiometricType {
  /// نام فارسی
  String get persianName {
    switch (this) {
      case MyBiometricType.fingerprint:
        return 'اثر انگشت';
      case MyBiometricType.face:
        return 'تشخیص چهره';
      case MyBiometricType.iris:
        return 'عنبیه چشم';
      case MyBiometricType.other:
        return 'بیومتریک';
    }
  }

  /// آیکون مناسب
  IconData get icon {
    switch (this) {
      case MyBiometricType.fingerprint:
        return Icons.fingerprint;
      case MyBiometricType.face:
        return Icons.face;
      case MyBiometricType.iris:
        return Icons.remove_red_eye;
      case MyBiometricType.other:
        return Icons.fingerprint;
    }
  }

  /// ایموجی برای نمایش ساده
  String get emoji {
    switch (this) {
      case MyBiometricType.fingerprint:
        return '👆';
      case MyBiometricType.face:
        return '👤';
      case MyBiometricType.iris:
        return '👁️';
      case MyBiometricType.other:
        return '🔐';
    }
  }
}

/// تبدیل نوع دریافتی از پکیج به مدل خودمون
MyBiometricType parseBiometricType(String type) {
  final lower = type.toLowerCase();
  if (lower.contains('fingerprint')) return MyBiometricType.fingerprint;
  if (lower.contains('face')) return MyBiometricType.face;
  if (lower.contains('iris')) return MyBiometricType.iris;
  return MyBiometricType.other;
}
