import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moshir_test/services/firebase_service.dart';
import 'package:moshir_test/ui/components/header.dart' as components;
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';
import 'package:moshir_test/ui/screens/calendar.dart';
import 'package:moshir_test/ui/screens/history.dart';
import 'package:moshir_test/services/notification_service.dart';
import 'package:moshir_test/services/platform_service.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // برای نمایش نوتیفیکیشن‌های جدید
  int _notificationCount = 0;
  bool _hasNewNotification = false;

  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  Future<void> _checkNotifications() async {
    // اینجا می‌تونی چک کنی نوتیفیکیشن جدید داری یا نه
    // مثلاً از SharedPreferences یا سرور
    setState(() {
      _notificationCount = 3; // نمونه
      _hasNewNotification = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              // هدر با نوتیفیکیشن
              _buildHeaderWithNotification(context),

              const SizedBox(height: 20),

              // محتوای اصلی صفحه
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const components.Header(),

                      // لوگو
                      SvgPicture.asset(
                        'assets/images/Logo.svg',
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                      ),

                      const SizedBox(height: 18),

                      // عنوان
                      Text(
                        "Moshir Home Page",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // زیرعنوان
                      Text(
                        "سامانه هوشمند کارگزینی",
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // کارت‌های میانبر
                      _buildQuickAccessCards(context),

                      const SizedBox(height: 30),

                      // آخرین فعالیت‌ها
                      _buildRecentActivities(context),

                      const SizedBox(height: 20),

                      // دکمه‌های تست نوتیفیکیشن (برای دیباگ)
                      // if (!PlatformService.isWeb)
                      _buildNotificationTestButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }

  // هدر با نوتیفیکیشن
  Widget _buildHeaderWithNotification(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // عنوان صفحه
        Text(
          "خانه",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // آیکون نوتیفیکیشن با بج
        Stack(
          children: [
            IconButton(
              icon: Icon(
                _hasNewNotification
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: isDark ? Colors.white : Colors.black,
                size: 28,
              ),
              onPressed: () {
                _showNotificationDialog(context);
              },
            ),
            if (_notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$_notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // کارت‌های میانبر سریع
  Widget _buildQuickAccessCards(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            "دسترسی سریع",
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            _buildQuickCard(
              context: context,
              title: 'پروفایل',
              icon: Icons.person,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileState(),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            _buildQuickCard(
              context: context,
              title: 'تقویم',
              icon: Icons.calendar_today,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuickCard(
              context: context,
              title: 'تاریخچه',
              icon: Icons.history,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            const SizedBox(width: 12),
            _buildQuickCard(
              context: context,
              title: 'تنظیمات',
              icon: Icons.settings,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // ساخت کارت میانبر
  Widget _buildQuickCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // آخرین فعالیت‌ها
  Widget _buildRecentActivities(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            "آخرین فعالیت‌ها",
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'فیش حقوقی صادر شد',
                '۲ ساعت پیش',
                Icons.receipt,
                Colors.blue,
                isDark,
              ),
              const Divider(),
              _buildActivityItem(
                'درخواست مرخصی تأیید شد',
                'دیروز',
                Icons.check_circle,
                Colors.green,
                isDark,
              ),
              const Divider(),
              _buildActivityItem(
                'الحاقیه جدید اضافه شد',
                '۳ روز پیش',
                Icons.attach_file,
                Colors.orange,
                isDark,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // آیتم فعالیت
  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
    bool isDark, {
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دکمه‌های تست نوتیفیکیشن (برای دیباگ)
  Widget _buildNotificationTestButtons(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        const Text(
          "تست نوتیفیکیشن",
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // ✅ اینجا دکمه جدید رو اضافه کن
        ElevatedButton(
          onPressed: () async {
            try {
              await Firebase.initializeApp(
                options: const FirebaseOptions(
                  apiKey: "AIzaSyB_2pPq_Rx...", // apiKey رو بذار
                  appId: "1:123456789:android:abcdef...", // appId
                  messagingSenderId: "123456789",
                  projectId: "moshir-bb5ff",
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Firebase وصل شد!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('❌ خطا: $e')));
            }
          },
          child: const Text('تست Firebase'),
        ),

        const SizedBox(height: 10),

        // ✅ دکمه نمایش توکن - اضافه کن
        if (PlatformService.isAndroid || PlatformService.isIOS)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () async {
                // String? token = await FirebaseService().getSavedToken();

                // // اگه توکن نال بود، یه توکن جدید بگیر
                // if (token == null) {
                //   token = await FirebaseService().refreshToken();
                // }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('FCM Token'),
                    content: SelectableText(
                      // token ??
                      '❌ توکن وجود نداره\n\nاول Firebase رو مقداردهی کن',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('باشه'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.token, size: 16),
              label: const Text('نمایش FCM Token'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // دکمه تست نوتیفیکیشن محلی
            ElevatedButton.icon(
              onPressed: () {
                // NotificationService().showSimpleNotification(
                //   title: 'تست نوتیفیکیشن',
                //   body: 'این یک نوتیفیکیشن آزمایشیه',
                // );
                setState(() {
                  _notificationCount++;
                  _hasNewNotification = true;
                });
              },
              icon: const Icon(Icons.notifications, size: 16),
              label: const Text('تست'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                VibrationHelper.vibrate(durationMs: 500); // نیم ثانیه ویبره
              },
              icon: const Icon(Icons.vibration, size: 16),
              label: const Text('ویبره'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),

            // دکمه پاک کردن
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  _notificationCount = 0;
                  _hasNewNotification = false;
                });
              },
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('پاک کردن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // نمایش دیالوگ نوتیفیکیشن‌ها
  void _showNotificationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // دستگیره
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'اعلان‌ها',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (_notificationCount == 0)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'هیچ اعلان جدیدی ندارید',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    _buildNotificationItem(
                      'فیش حقوقی فروردین',
                      '۲ ساعت پیش',
                      Icons.receipt,
                      Colors.blue,
                    ),
                    _buildNotificationItem(
                      'درخواست مرخصی تأیید شد',
                      '۵ ساعت پیش',
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _buildNotificationItem(
                      'الحاقیه قرارداد',
                      'دیروز',
                      Icons.attach_file,
                      Colors.orange,
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _notificationCount = 0;
                    _hasNewNotification = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('خواندم'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// کلاس کمکی برای ویبره
class VibrationHelper {
  static Future<void> vibrate({int durationMs = 500}) async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: durationMs);
      } else {
        debugPrint('این دستگاه از ویبره پشتیبانی نمی‌کند');
      }
    } catch (e) {
      debugPrint('خطا در ویبره: $e');
    }
  }
}
