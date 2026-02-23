import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moshir_test/main.dart';
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/components/number_converter.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:moshir_test/ui/providers/settings_provider.dart';
import 'package:moshir_test/ui/screens/history.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:provider/provider.dart';

// ============== Header ==============
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _HeaderMenuButton(),
        Text("صفحه پرسنلی", style: Theme.of(context).textTheme.headlineSmall),
        const _HeaderBackButton(),
      ],
    );
  }
}

// ============== User Profile State ==============
class UserProfileState extends StatelessWidget {
  const UserProfileState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            30,
            30,
            30,
            0,
          ), // کمی پدینگ را متعادل کردیم
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 10),
              // Expanded باعث می‌شود بدنه بقیه فضای صفحه را پر کند و Overflow ندهد
              const Expanded(child: UserProfileBody()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }
}

// ============== User Profile Body ==============
class UserProfileBody extends StatelessWidget {
  const UserProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ردیف اطلاعات پرسنلی
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 15),
                Expanded(child: _buildEmployeeInfo(context)),
              ],
            ),

            const SizedBox(height: 30),

            // کارت اسمال
            const SizedBox(
              height: 140,
              width: double.infinity,
              child: SmallBalanceCard(
                amount: '١٢٥٣ ٥٤٣٢ ٣٥٢١ ٣٠٩٠',
                label: 'شماره پرسنلی',
              ),
            ),

            const SizedBox(height: 20),

            // کارت بزرگ
            const SizedBox(
              height: 220,
              width: double.infinity,
              child: LargeProfileCard(
                name: 'جلال ازادمهر',
                phone: '۰۹۱۲۳۴۵۶۷۸۹',
                cardNumber: '۱۲۵۳ ۵۴۳۲ ۳۵۲۱ ۳۰۹۰',
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ReportsButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100, // کم کن
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.5),
          width: 4,
        ),
        borderRadius: BorderRadius.circular(26),
        image: const DecorationImage(
          image: AssetImage('assets/images/Jalal.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'جلال ازادمهر',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(
          '۰۹۱۲۳۴۵۶۷۸۹',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 180,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return AdvancedProgressIndicator(
                value: settings.profileCompletion,
                label: '',
                positiveProgressColor: const Color.fromRGBO(30, 195, 152, 1),
                height: 4,
                showLabel: false,
              );
            },
          ),
        ),
      ],
    );
  }
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

// ============== Advanced Progress Indicator ==============
class AdvancedProgressIndicator extends StatefulWidget {
  final double value;
  final String label;
  final Color positiveProgressColor;
  final Color textColor;
  final double height;
  final bool showLabel;
  final bool showPercent;
  final bool animate;
  final Duration animationDuration;
  final Curve animationCurve;

  const AdvancedProgressIndicator({
    super.key,
    required this.value,
    required this.label,
    this.positiveProgressColor = Colors.green,
    this.textColor = Colors.grey,
    this.height = 6,
    this.showLabel = true,
    this.showPercent = true,
    this.animate = true,
    this.animationDuration = const Duration(seconds: 1),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<AdvancedProgressIndicator> createState() =>
      _AdvancedProgressIndicatorState();
}

class _AdvancedProgressIndicatorState extends State<AdvancedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    if (widget.animate) _controller.forward();
  }

  @override
  void didUpdateWidget(AdvancedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 13,
                  color: widget.textColor,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(child: _buildProgressBar()),
              if (widget.showPercent) ...[
                const SizedBox(width: 8),
                _buildPercentText(),
                if (widget.value > 0.5)
                  Icon(
                    Icons.arrow_upward,
                    size: 16,
                    color: Colors.green.shade600,
                  )
                else
                  Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPercentText() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final percentValue = _animation.value * 100;
        final percentString = percentValue.toStringAsFixed(1);
        final persianPercent = NumberConverter.toPersian(percentString);

        return Text(
          '$persianPercent%',
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: widget.positiveProgressColor,
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || constraints.maxWidth <= 0) {
          return SizedBox(height: widget.height, width: 100);
        }

        final double availableWidth = constraints.maxWidth;
        double progressWidth = availableWidth * _animation.value;
        progressWidth = progressWidth.clamp(0, availableWidth);

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(234, 238, 245, 1),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: progressWidth,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.positiveProgressColor,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ============== Base Card ==============
abstract class BaseCard extends StatelessWidget {
  final String bgPatternAsset;
  final String overlayPatternAsset;
  final Color gradientStart;
  final Color gradientEnd;

  // ============== Constants Colors ==============
  static const String defaultBgPattern = 'assets/images/BG.svg';
  static const String defaultOverlayPattern = 'assets/images/Pattern.svg';

  static const Color smallCardStart = Color.fromRGBO(15, 56, 90, 1);
  static const Color smallCardEnd = Color.fromRGBO(13, 85, 125, 1);
  static const Color largeCardStart = Color.fromRGBO(255, 222, 47, 1);
  static const Color largeCardEnd = Color.fromRGBO(255, 171, 45, 1);

  const BaseCard({
    super.key,
    required this.bgPatternAsset,
    required this.overlayPatternAsset,
    required this.gradientStart,
    required this.gradientEnd,
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          return const SizedBox();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // لایه ۱: پس‌زمینه اصلی
              Positioned.fill(
                child: SvgPicture.asset(bgPatternAsset, fit: BoxFit.cover),
              ),

              // لایه ۲: پترن رویی
              Positioned.fill(
                child: SvgPicture.asset(
                  overlayPatternAsset,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1),
                    BlendMode.srcIn,
                  ),
                ),
              ),

              // ✅ لایه ۳: گرادینت از پارامترها
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        gradientStart.withOpacity(0.85),
                        gradientEnd.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // لایه ۴: محتوا
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: buildContent(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============== Small Card ==============
class SmallBalanceCard extends BaseCard {
  final String amount;
  final String label;
  final IconData icon;

  const SmallBalanceCard({
    super.key,
    required this.amount,
    this.label = 'شماره پرسنلی',
    this.icon = Icons.credit_card,
    super.bgPatternAsset = 'assets/images/BG.svg',
    super.overlayPatternAsset = 'assets/images/Pattern.svg',
    super.gradientStart = BaseCard.smallCardStart,
    super.gradientEnd = BaseCard.smallCardEnd,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/images/Logo_light.svg',
              width: 40,
              height: 40,
              // colorFilter: const ColorFilter.mode(
              //   Colors.white70,
              //   BlendMode.srcIn,
              // ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
      ],
    );
  }
}

// ============== Large Card ==============
class LargeProfileCard extends BaseCard {
  final String name;
  final String phone;
  final String cardNumber;

  const LargeProfileCard({
    super.key,
    required this.name,
    required this.phone,
    required this.cardNumber,
    super.bgPatternAsset = 'assets/images/BG.svg',
    super.overlayPatternAsset = 'assets/images/Pattern.svg',
    super.gradientStart = BaseCard.largeCardStart,
    super.gradientEnd = BaseCard.largeCardEnd,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // عنوان "کارت پرسنلی"
        const Text(
          'کارت پرسنلی',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        // شماره کارت
        Text(
          cardNumber,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const Spacer(),

        // نام و شماره تلفن
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phone,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============== Telegram Start Button ==============
class TelegramStartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TelegramStartButton({
    super.key,
    required this.onPressed,
    required String text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF34C759), // سبز iOS
            Color(0xFF30B0C0), // آبی-سبز
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34C759).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        onPressed: onPressed,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.paperplane, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'شروع کنید',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============== iOS Style Reports Modal Popup ==============
class ReportsModalPopup {
  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // عنوان
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'گزارشات',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'نمایش همه',
                            style: TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 16,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // خط جداکننده
                  Container(
                    height: 0.5,
                    color: isDark
                        ? CupertinoColors.separator.darkColor
                        : CupertinoColors.separator,
                  ),

                  // آیتم‌ها
                  _buildMenuItem(
                    context,
                    title: 'ثبت',
                    time: '۷:۳۰ صبح',
                    icon: CupertinoIcons.pencil,
                    color: CupertinoColors.activeBlue,
                    isDark: isDark,
                  ),

                  _buildMenuItem(
                    context,
                    title: 'فیش حقوقی',
                    date: '۱۲ اردیبهشت',
                    icon: CupertinoIcons.doc_text,
                    color: CupertinoColors.activeGreen,
                    isDark: isDark,
                  ),

                  _buildMenuItem(
                    context,
                    title: 'دریافت',
                    time: '۱۰:۴۵ عصر',
                    icon: CupertinoIcons.down_arrow,
                    color: CupertinoColors.systemPurple,
                    isDark: isDark,
                    showDivider: false,
                  ),

                  _buildMenuItem(
                    context,
                    title: 'الحاقیه',
                    date: '۲۱ تیر',
                    icon: CupertinoIcons.link,
                    color: CupertinoColors.systemOrange,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    String? date,
    String? time,
    required IconData icon,
    required Color color,
    required bool isDark,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
            _showItemDetails(context, title, date ?? time ?? '');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                // آیکون
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),

                const SizedBox(width: 16),

                // عنوان
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                    ),
                  ),
                ),

                // تاریخ یا زمان
                if (date != null || time != null)
                  Text(
                    date ?? time!,
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: isDark
                          ? CupertinoColors.systemGrey.darkColor
                          : CupertinoColors.systemGrey,
                    ),
                  ),

                const SizedBox(width: 8),

                // شورون
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 14,
                  color: isDark
                      ? CupertinoColors.systemGrey.darkColor
                      : CupertinoColors.systemGrey,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 76),
            child: Container(
              height: 0.5,
              color: isDark
                  ? CupertinoColors.separator.darkColor
                  : CupertinoColors.separator,
            ),
          ),
      ],
    );
  }

  static void _showItemDetails(
    BuildContext context,
    String title,
    String dateTime,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
          ),
        ),
        message: Text(
          'تاریخ: $dateTime\n'
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

// ============== دکمه نمایش گزارشات ==============
class ReportsButton extends StatelessWidget {
  const ReportsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IOSStyleButton(
      text: 'مشاهده گزارشات',
      onPressed: () {
        ReportsModalPopup.show(context);
      },
      icon: CupertinoIcons.doc_text,
    );
  }
}

// ============== IOS Style Button ==============
class IOSStyleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const IOSStyleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.activeBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(12),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
