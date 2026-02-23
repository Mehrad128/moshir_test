import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestFirebasePage extends StatelessWidget {
  const TestFirebasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تست Firebase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // تست دریافت توکن
            ElevatedButton(
              onPressed: () async {
                try {
                  // چک کردن وضعیت Firebase
                  final bool isInitialized = Firebase.apps.isNotEmpty;
                  if (!isInitialized) {
                    await Firebase.initializeApp();
                  }

                  // درخواست مجوز برای نوتیفیکیشن
                  NotificationSettings settings =
                      await FirebaseMessaging.instance.requestPermission(
                    alert: true,
                    badge: true,
                    sound: true,
                  );

                  if (settings.authorizationStatus ==
                      AuthorizationStatus.authorized) {
                    // دریافت توکن
                    String? token =
                        await FirebaseMessaging.instance.getToken();
                    
                    if (token != null) {
                      _showTokenDialog(context, token);
                    } else {
                      _showErrorDialog(context, 'توکن دریافت نشد');
                    }
                  } else {
                    _showErrorDialog(context, 'مجوز نوتیفیکیشن داده نشد');
                  }
                } catch (e) {
                  _showErrorDialog(context, e.toString());
                }
              },
              child: const Text('گرفتن FCM Token'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('بازگشت به خانه'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTokenDialog(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ FCM Token'),
        content: SingleChildScrollView(
          child: SelectableText(token),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('❌ خطا'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }
}
