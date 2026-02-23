// ============== History Page ==============
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moshir_test/main.dart';
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // نمونه داده‌های تاریخچه
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      title: 'فیش حقوقی',
      date: '۱۲ اردیبهشت',
      icon: CupertinoIcons.doc_text,
    ),
    HistoryItem(
      title: 'ثبت',
      time: '۷:۳۰ صبح',
      badge: '۶',
      badgeText: 'ثبت',
      icon: CupertinoIcons.pencil,
    ),
    HistoryItem(title: 'الحاقیه', date: '۲۱ تیر', icon: CupertinoIcons.link),
    HistoryItem(
      title: 'دریافت',
      time: '۱۰:۴۵ عصر',
      icon: CupertinoIcons.cloud_download,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CupertinoColors.black : CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _HeaderMenuButton(),
                  Text(
                    "صفحه گزارشات",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const _HeaderBackButton(),
                ],
              ),

              // ✅ خط جداکننده زیر هدر (اختیاری)
              // Container(height: 0.5, color: CupertinoColors.separator),
              const SizedBox(height: 16),

              // بخش خلاصه
              _buildSummarySection(context, isDark),

              const SizedBox(height: 16),

              // لیست تاریخچه
              Expanded(child: _buildHistoryList(context, isDark)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNaviState(),
    );
  }

  // ✅ بخش خلاصه با کارت‌های آماری
  Widget _buildSummarySection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.white,
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            context: context,
            value: '۱۲',
            label: 'کل موارد',
            icon: CupertinoIcons.doc_on_clipboard,
            color: CupertinoColors.activeBlue,
            isDark: isDark,
          ),
          _buildSummaryItem(
            context: context,
            value: '۸',
            label: 'دریافتی',
            icon: CupertinoIcons.cloud_download,
            color: CupertinoColors.activeGreen,
            isDark: isDark,
          ),
          _buildSummaryItem(
            context: context,
            value: '۴',
            label: 'ثبت شده',
            icon: CupertinoIcons.pencil,
            color: CupertinoColors.systemOrange,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 13,
            color: isDark
                ? CupertinoColors.systemGrey
                : CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  // ✅ لیست تاریخچه
  Widget _buildHistoryList(BuildContext context, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _historyItems.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 0.5,
        indent: 60,
        color: CupertinoColors.separator,
      ),
      itemBuilder: (context, index) {
        final item = _historyItems[index];
        return _buildHistoryItem(context, item, isDark);
      },
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    HistoryItem item,
    bool isDark,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showItemDetails(context, item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // آیکون
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconColor(item, isDark).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: _getIconColor(item, isDark),
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            // عنوان و توضیحات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                        ),
                      ),
                      if (item.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.badge!,
                                style: const TextStyle(
                                  fontFamily: 'Vazirmatn',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              if (item.badgeText != null) ...[
                                const SizedBox(width: 2),
                                Text(
                                  item.badgeText!,
                                  style: const TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 12,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date ?? item.time ?? '',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            // آیکون شورون
            Icon(
              CupertinoIcons.chevron_forward,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(HistoryItem item, bool isDark) {
    if (item.badge != null) return CupertinoColors.activeBlue;

    switch (item.title) {
      case 'فیش حقوقی':
        return CupertinoColors.activeGreen;
      case 'دریافت':
        return CupertinoColors.systemPurple;
      case 'الحاقیه':
        return CupertinoColors.systemOrange;
      default:
        return isDark ? CupertinoColors.white : CupertinoColors.black;
    }
  }

  void _showItemDetails(BuildContext context, HistoryItem item) {
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
        message: Text(
          'تاریخ: ${item.date ?? item.time ?? ''}\n'
          'وضعیت: تکمیل شده\n'
          'کد پیگیری: ۱۲۳۴۵۶۷۸۹',
          style: const TextStyle(fontFamily: 'Vazirmatn'),
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'مشاهده جزئیات',
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

// ============== مدل داده تاریخچه ==============
class HistoryItem {
  final String title;
  final String? date;
  final String? time;
  final String? badge;
  final String? badgeText;
  final IconData icon;

  HistoryItem({
    required this.title,
    this.date,
    this.time,
    this.badge,
    this.badgeText,
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
