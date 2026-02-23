// lib/ui/providers/settings_provider.dart

import 'package:flutter/material.dart';
import 'package:moshir_test/ui/components/number_converter.dart';

class SettingsProvider extends ChangeNotifier {
  double _profileCompletion = 0.85; // مقدار پیشفرض ۸۵%

  double get profileCompletion => _profileCompletion;

  set profileCompletion(double value) {
    _profileCompletion = value;
    notifyListeners();
  }

  // برای نمایش درصد به صورت فارسی
  String get profileCompletionPercent {
    final percent = (_profileCompletion * 100).toStringAsFixed(0);
    return NumberConverter.toPersian(percent);
  }
}
