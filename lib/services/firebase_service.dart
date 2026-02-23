// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'notification_service.dart';
// import 'platform_service.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// class FirebaseService {
//   static final FirebaseService _instance = FirebaseService._internal();
//   factory FirebaseService() => _instance;
//   FirebaseService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   bool _isInitialized = false;

//   // مقداردهی اولیه Firebase
//   Future<void> initialize() async {
//     // جلوگیری از مقداردهی مجدد
//     if (_isInitialized) return;

//     if (kIsWeb) {
//       print('⚠️ Firebase روی وب پشتیبانی نمیشه');
//       return;
//     }

//     // فقط روی موبایل اجرا کن (اندروید و iOS)
//     if (!PlatformService.isAndroid && !PlatformService.isIOS) {
//       print('⚠️ Firebase فقط روی اندروید و iOS کار میکنه');
//       return;
//     }

//     try {
//       await Firebase.initializeApp();

//       // دریافت مجوز برای iOS
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: true,
//       );

//       if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//         print('⚠️ کاربر مجوز نوتیفیکیشن را نداد');
//         return;
//       }

//       print('✅ مجوز نوتیفیکیشن دریافت شد');

//       // دریافت FCM Token
//       String? token = await _messaging.getToken();
//       if (token != null) {
//         print('🔥 FCM Token: $token');
//         await _saveToken(token);
//       }

//       // تنظیم هندلرها
//       _setupHandlers();

//       _isInitialized = true;
//     } catch (e) {
//       print('❌ خطا در مقداردهی Firebase: $e');
//     }
//   }

//   // تنظیم هندلرهای پیام
//   void _setupHandlers() {
//     // ۱. وقتی اپ در foreground هست
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📨 پیام جدید در foreground: ${message.notification?.title}');
//       _handleForegroundMessage(message);
//     });

//     // ۲. وقتی اپ در background هست و کاربر روی نوتیفیکیشن کلیک می‌کنه
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('👆 کاربر از نوتیفیکیشن وارد اپ شد');
//       _handleMessageTap(message);
//     });

//     // ۳. وقتی اپ کاملاً بسته است و با نوتیفیکیشن باز می‌شه
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         print('🚀 اپ از حالت بسته با نوتیفیکیشن باز شد');
//         _handleMessageTap(message);
//       }
//     });

//     // ۴. وقتی توکن تازه می‌شه
//     _messaging.onTokenRefresh.listen((newToken) {
//       print('🔄 FCM Token تازه شد: $newToken');
//       _saveToken(newToken);
//     });
//   }

//   // هندل کردن پیام foreground
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     try {
//       // نمایش نوتیفیکیشن محلی
//       await NotificationService().showSimpleNotification(
//         title: message.notification?.title ?? 'اعلان جدید',
//         body: message.notification?.body ?? '',
//         payload: jsonEncode(message.data),
//         type: _getNotificationType(message.data),
//       );
//     } catch (e) {
//       print('❌ خطا در نمایش نوتیفیکیشن: $e');
//     }
//   }

//   // هندل کردن کلیک روی پیام
//   void _handleMessageTap(RemoteMessage message) {
//     print('📊 داده‌های پیام: ${message.data}');

//     // اینجا می‌تونی کاربر رو به صفحه مناسب هدایت کنی
//     String? screen = message.data['screen'];
//     if (screen != null) {
//       print('➡️ هدایت به صفحه: $screen');
//       // NavigationService().navigateTo(screen);
//     }
//   }

//   // تشخیص نوع نوتیفیکیشن
//   NotificationType _getNotificationType(Map<String, dynamic> data) {
//     String type = data['type'] ?? 'general';
//     switch (type) {
//       case 'important':
//         return NotificationType.important;
//       case 'payroll':
//         return NotificationType.payroll;
//       default:
//         return NotificationType.general;
//     }
//   }

//   // ذخیره FCM Token
//   Future<void> _saveToken(String? token) async {
//     if (token == null || token.isEmpty) return;

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('fcm_token', token);
//       print('💾 FCM Token ذخیره شد');

//       // اینجا می‌تونی توکن رو به سرورت بفرستی
//       // await _sendTokenToServer(token);
//     } catch (e) {
//       print('❌ خطا در ذخیره توکن: $e');
//     }
//   }

//   // دریافت FCM Token ذخیره شده
//   Future<String?> getSavedToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString('fcm_token');
//     } catch (e) {
//       print('❌ خطا در دریافت توکن: $e');
//       return null;
//     }
//   }

//   // دریافت توکن جدید
//   Future<String?> refreshToken() async {
//     try {
//       String? token = await _messaging.getToken();
//       await _saveToken(token);
//       return token;
//     } catch (e) {
//       print('❌ خطا در دریافت توکن جدید: $e');
//       return null;
//     }
//   }

//   // ارسال توکن به سرور (اختیاری)
//   // Future<void> _sendTokenToServer(String token) async {
//   //   // کد ارسال به سرور
//   // }
// }
