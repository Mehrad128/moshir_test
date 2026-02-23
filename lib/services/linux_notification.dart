import 'dart:io';

class LinuxNotificationService {
  // برای لینوکس از notify-send استفاده می‌کنیم
  static Future<void> showLinuxNotification({
    required String title,
    required String body,
    String? urgency = 'normal',
  }) async {
    try {
      await Process.run('notify-send', [
        '--urgency=$urgency',
        '--app-name=Moshir',
        '--icon=$_getIconPath()',
        title,
        body,
      ]);
    } catch (e) {
      print('خطا در نمایش نوتیفیکیشن لینوکس: $e');
    }
  }

  static String _getIconPath() {
    return '${Directory.current.path}/assets/icon/icon.png';
  }
}
