class NumberConverter {
  static String toEnglish(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(persian[i], english[i]);
      result = result.replaceAll(arabic[i], english[i]);
    }
    return result;
  }

  // تبدیل اعداد انگلیسی به فارسی
  static String toPersian(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }

  // تبدیل درصد فارسی به انگلیسی برای محاسبه
  static double parsePercent(String percentText) {
    final englishText = toEnglish(percentText.replaceAll('%', ''));
    return double.parse(englishText) / 100;
  }

  // تبدیل عدد به درصد فارسی
  static String toPercentString(double value) {
    final percent = (value * 100).toStringAsFixed(1);
    return '${toPersian(percent)}%';
  }
}
