import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moshir_test/main.dart';
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';

// ============== Notifications Page ==============
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // نمونه داده‌های نوتیفیکیشن
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'فیش حقوقی صادر شد',
      message: 'فیش حقوقی فروردین ۱۴۰۵ صادر و در بخش گزارشات قابل مشاهده است.',
      time: '۲ ساعت پیش',
      type: NotificationType.payroll,
      isRead: false,
      icon: CupertinoIcons.doc_text,
    ),
    NotificationItem(
      id: '2',
      title: 'درخواست مرخصی تأیید شد',
      message: 'درخواست مرخصی شما برای تاریخ ۱۵ تا ۲۰ اردیبهشت تأیید شد.',
      time: 'دیروز',
      type: NotificationType.approval,
      isRead: false,
      icon: CupertinoIcons.checkmark_alt,
    ),
    NotificationItem(
      id: '3',
      title: 'ثبت‌نام موفقیت‌آمیز بود',
      message: 'به سامانه مشیر خوش آمدید. پروفایل خود را تکمیل کنید.',
      time: '۳ روز پیش',
      type: NotificationType.system,
      isRead: true,
      icon: CupertinoIcons.person,
    ),
    NotificationItem(
      id: '4',
      title: 'تمدید قرارداد کاری',
      message: 'قرارداد کاری شما تا پایان خرداد ۱۴۰۵ تمدید شد.',
      time: '۱ هفته پیش',
      type: NotificationType.contract,
      isRead: true,
      icon: CupertinoIcons.doc_on_doc,
    ),
    NotificationItem(
      id: '5',
      title: 'یادآوری: جلسه هفتگی',
      message:
          'جلسه هماهنگی تیم فردا ساعت ۱۰ صبح در سالن کنفرانس برگزار می‌شود.',
      time: '۱ هفته پیش',
      type: NotificationType.reminder,
      isRead: true,
      icon: CupertinoIcons.calendar,
    ),
    NotificationItem(
      id: '6',
      title: 'به‌روزرسانی نرم‌افزار',
      message: 'نسخه جدید اپلیکیشن مشیر با امکانات بیشتر منتشر شد.',
      time: '۲ هفته پیش',
      type: NotificationType.system,
      isRead: true,
      icon: CupertinoIcons.cloud_download,
    ),
  ];

  // فیلتر فعال
  NotificationFilter _activeFilter = NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CupertinoColors.black : CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              // هدر
              // const Header(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _HeaderMenuButton(),
                  Text(
                    "صفحه اعلانات",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const _HeaderBackButton(),
                ],
              ),

              // خط جداکننده
              Container(
                height: 0.0,
                color: isDark
                    ? CupertinoColors.separator.darkColor
                    : CupertinoColors.separator,
              ),

              // عنوان صفحه و دکمه‌ها
              _buildHeader(context, isDark),

              // فیلترها
              _buildFilterTabs(context, isDark),

              // لیست نوتیفیکیشن‌ها
              Expanded(child: _buildNotificationsList(context, isDark)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'اعلان‌ها',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // دکمه جستجو
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? CupertinoColors.darkBackgroundGray
                        : CupertinoColors.lightBackgroundGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(CupertinoIcons.search, size: 20),
                ),
                onPressed: () {
                  _showSearchDialog(context);
                },
              ),
              const SizedBox(width: 8),
              // دکمه تنظیمات نوتیفیکیشن
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? CupertinoColors.darkBackgroundGray
                        : CupertinoColors.lightBackgroundGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(CupertinoIcons.settings, size: 20),
                ),
                onPressed: () {
                  _showNotificationSettings(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, bool isDark) {
    final filters = [
      {'filter': NotificationFilter.all, 'label': 'همه'},
      {'filter': NotificationFilter.unread, 'label': 'خوانده نشده'},
      {'filter': NotificationFilter.important, 'label': 'مهم'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((item) {
          final filter = item['filter'] as NotificationFilter;
          final label = item['label'] as String;
          final isSelected = _activeFilter == filter;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeFilter = filter;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                            ? CupertinoColors.activeOrange
                            : CupertinoColors.activeBlue)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? CupertinoColors.white
                        : (isDark
                              ? CupertinoColors.white
                              : CupertinoColors.black),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, bool isDark) {
    // فیلتر کردن نوتیفیکیشن‌ها
    final filteredNotifications = _notifications.where((item) {
      switch (_activeFilter) {
        case NotificationFilter.unread:
          return !item.isRead;
        case NotificationFilter.important:
          return item.type == NotificationType.payroll ||
              item.type == NotificationType.contract;
        default:
          return true;
      }
    }).toList();

    if (filteredNotifications.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredNotifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 0.5,
        indent: 72,
        color: isDark
            ? CupertinoColors.separator.darkColor
            : CupertinoColors.separator,
      ),
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationItem(context, notification, isDark);
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationItem item,
    bool isDark,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showNotificationDetails(context, item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // دایره وضعیت خوانده شدن
            if (!item.isRead)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: const BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  shape: BoxShape.circle,
                ),
              ),

            // آیکون
            Container(
              width: 48,
              height: 48,
              margin: EdgeInsets.only(right: !item.isRead ? 0 : 16),
              decoration: BoxDecoration(
                color: _getNotificationColor(
                  item.type,
                  isDark,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.icon,
                color: _getNotificationColor(item.type, isDark),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // عنوان و پیام
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 16,
                            fontWeight: item.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            color: isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 12,
                          color: isDark
                              ? CupertinoColors.systemGrey.darkColor
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: isDark
                          ? CupertinoColors.systemGrey.darkColor
                          : CupertinoColors.systemGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: isDark
                  ? CupertinoColors.darkBackgroundGray
                  : CupertinoColors.lightBackgroundGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.bell_slash,
              size: 60,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'هیچ اعلانی وجود ندارد',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اعلان‌های جدید در اینجا نمایش داده می‌شوند',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 14,
              color: isDark
                  ? CupertinoColors.systemGrey.darkColor
                  : CupertinoColors.systemGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type, bool isDark) {
    switch (type) {
      case NotificationType.payroll:
        return CupertinoColors.activeGreen;
      case NotificationType.approval:
        return CupertinoColors.activeBlue;
      case NotificationType.system:
        return CupertinoColors.systemPurple;
      case NotificationType.contract:
        return CupertinoColors.systemOrange;
      case NotificationType.reminder:
        return CupertinoColors.systemYellow;
    }
  }

  void _showSearchDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'جستجو در اعلان‌ها',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        content: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoTextField(
              placeholder: 'عبارت مورد نظر را وارد کنید...',
              placeholderStyle: TextStyle(
                fontFamily: 'Vazirmatn',
                color: isDark
                    ? CupertinoColors.systemGrey.darkColor
                    : CupertinoColors.systemGrey,
              ),
              style: const TextStyle(fontFamily: 'Vazirmatn'),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? CupertinoColors.separator.darkColor
                      : CupertinoColors.separator,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'جستجو',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text(
              'انصراف',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          'تنظیمات نوتیفیکیشن',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        message: const Text(
          'نوع اعلان‌هایی که می‌خواهید دریافت کنید را انتخاب کنید',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'همه اعلان‌ها',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'فقط موارد مهم',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'غیرفعال کردن نوتیفیکیشن',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'انصراف',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          item.title,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
          ),
        ),
        message: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _getNotificationColor(
                  item.type,
                  isDark,
                ).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: _getNotificationColor(item.type, isDark),
                size: 30,
              ),
            ),
            Text(
              item.message,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              item.time,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 14,
                color: isDark
                    ? CupertinoColors.systemGrey.darkColor
                    : CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // اینجا می‌تونی کاربر رو به صفحه مرتبط هدایت کنی
            },
            child: const Text(
              'مشاهده جزئیات',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
          if (!item.isRead)
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  item.isRead = true;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'علامت‌گذاری به عنوان خوانده شده',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('بستن', style: TextStyle(fontFamily: 'Vazirmatn')),
        ),
      ),
    );
  }
}

// ============== مدل داده نوتیفیکیشن ==============
enum NotificationType {
  payroll, // فیش حقوقی
  approval, // تأیید درخواست
  system, // سیستمی
  contract, // قرارداد
  reminder, // یادآوری
}

enum NotificationFilter { all, unread, important }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.icon,
  });
}

// ============== Header Menu Button ==============
class _HeaderMenuButton extends StatelessWidget {
  const _HeaderMenuButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showMenuSheet(context),
      child: SvgPicture.asset("assets/images/More.svg"),
    );
  }

  void _showMenuSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          _buildAction(context, 'پروفایل', () => _navigateToProfile(context)),
          _buildAction(context, 'تنظیمات', () => _navigateToSettings(context)),
        ],
        cancelButton: _buildCancelButton(context),
      ),
    );
  }

  CupertinoActionSheetAction _buildAction(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return CupertinoActionSheetAction(
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      onPressed: onPressed,
    );
  }

  CupertinoActionSheetAction _buildCancelButton(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text('لغو', style: Theme.of(context).textTheme.headlineSmall),
      onPressed: () => Navigator.pop(context),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfileState()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }
}

// ============== Header Back Button ==============
class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTopMessage(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      onLongPress: () => _showTopMessage(context),
      child: SvgPicture.asset("assets/images/Arrow.svg"),
    );
  }

  void _showTopMessage(BuildContext context) {
    final overlay = Overlay.of(context);
    final currentTime = MyApp().getTime();

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "You are in Profile page \n $currentTime",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), entry.remove);
  }
}
