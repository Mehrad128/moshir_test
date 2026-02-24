import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:moshir_ui/services/firebase_service.dart';
// import 'package:moshir_ui/services/platform_service.dart';
import 'package:moshir_test/ui/providers/settings_provider.dart';
import 'package:moshir_test/ui/splash/splash_screen.dart';
import 'package:moshir_test/ui/components/theme_notifier.dart';
// import 'package:moshir_ui/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
Future<void> onNotificationActionReceivedMethod(ReceivedAction receivedAction) async {
  // هندلر پس‌زمینه
  print('نوتیفیکیشن پس‌زمینه: ${receivedAction.payload}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDLdbc3S7Uplz-dVMNv1Iutm4Rei10WxAE",
          authDomain: "moshir-bb5ff.firebaseapp.com",
          projectId: "moshir-bb5ff",
          storageBucket: "moshir-bb5ff.firebasestorage.app",
          messagingSenderId: "848364028034",
          appId: "1:848364028034:web:a0596b73cfafc0a9b9749b",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // // ✅ اینجا بهترین جا برای onMessage.listen هست
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('📨 پیام در foreground دریافت شد');
      
    //   // // نمایش نوتیفیکیشن با flutter_local_notifications
    //   // NotificationService().showSimpleNotification(
    //   //   title: message.notification?.title ?? 'اعلان جدید',
    //   //   body: message.notification?.body ?? '',
    //   // );
    // });

    print('✅ Firebase روی وب مقداردهی شد');
  } catch (e) {
    print('❌ خطا: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeNotifier>(context).themeMode;

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Farsi
      ],
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Vazirmatn',
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 134, 144, 162),
          ),
          bodySmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          labelMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 100,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          labelSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Vazirmatn',
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }

  String getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }

  String getDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }
}
