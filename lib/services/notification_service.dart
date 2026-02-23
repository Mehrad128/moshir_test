// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'platform_service.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   int _notificationId = 0;
//   bool _isInitialized = false;

//   // کانال‌ها
//   static const String _generalChannelId = 'general_channel';
//   static const String _importantChannelId = 'important_channel';
//   static const String _payrollChannelId = 'payroll_channel';

//   Future<void> initialize() async {
//     if (_isInitialized) return;
//     if (kIsWeb) return;

//     tz.initializeTimeZones();

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     final LinuxInitializationSettings linuxSettings =
//         LinuxInitializationSettings(defaultActionName: 'باز کردن');

//     final InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//       linux: linuxSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         _onNotificationTap(response.payload);
//       },
//     );

//     if (PlatformService.isAndroid) {
//       await _createChannels();
//     }

//     _isInitialized = true;
//   }

//   Future<void> _createChannels() async {
//     final androidPlugin = _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidPlugin == null) return;

//     final channels = [
//       AndroidNotificationChannel(
//         _generalChannelId,
//         'اعلان‌های عمومی',
//         description: 'کانال اعلان‌های عمومی',
//         importance: Importance.high,
//         enableVibration: true,
//         playSound: true,
//       ),
//       AndroidNotificationChannel(
//         _importantChannelId,
//         'اعلان‌های مهم',
//         description: 'کانال اعلان‌های مهم',
//         importance: Importance.max,
//         enableVibration: true,
//         playSound: true,
//       ),
//       AndroidNotificationChannel(
//         _payrollChannelId,
//         'اعلان‌های حقوقی',
//         description: 'کانال اعلان‌های حقوقی',
//         importance: Importance.max,
//         enableVibration: true,
//         playSound: true,
//       ),
//     ];

//     for (var channel in channels) {
//       await androidPlugin.createNotificationChannel(channel);
//     }
//   }

//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//     String channelId = _generalChannelId,
//     String channelName = 'اعلان‌های عمومی',
//   }) async {
//     if (kIsWeb) return;
//     if (!_isInitialized) await initialize();

//     _notificationId++;

//     final androidDetails = AndroidNotificationDetails(
//       channelId,
//       channelName,
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     final iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     final linuxDetails = LinuxNotificationDetails(
//       urgency: LinuxNotificationUrgency.normal,
//     );

//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//       linux: linuxDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       _notificationId,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }

//   Future<void> showScheduledNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//     String channelId = _generalChannelId,
//     String channelName = 'اعلان‌های عمومی',
//   }) async {
//     if (kIsWeb) return;
//     if (!_isInitialized) await initialize();

//     _notificationId++;

//     final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

//     final androidDetails = AndroidNotificationDetails(
//       channelId,
//       channelName,
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     final iosDetails = DarwinNotificationDetails();
//     final linuxDetails = LinuxNotificationDetails();

//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//       linux: linuxDetails,
//     );

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       _notificationId,
//       title,
//       body,
//       tzScheduledDate,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }

//   Future<void> cancel(int id) async {
//     await _flutterLocalNotificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAll() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }

//   void _onNotificationTap(String? payload) {
//     debugPrint('نوتیفیکیشن کلیک شد: $payload');
//     if (payload != null) {
//       try {
//         final data = jsonDecode(payload);
//         debugPrint('داده‌ها: $data');
//       } catch (e) {
//         debugPrint('خطا: $e');
//       }
//     }
//   }
// }