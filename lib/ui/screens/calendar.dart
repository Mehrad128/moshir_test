import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moshir_test/main.dart';
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';
import 'package:table_calendar/table_calendar.dart';

// ============== Calendar Page ==============
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _HeaderMenuButton(),
                  Text(
                    "صفحه تقویم",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const _HeaderBackButton(),
                ],
              ),

              const SizedBox(height: 20),

              // کارت تاریخ انتخاب شده
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SelectedDateCard(selectedDate: selectedDate),
                      const SizedBox(height: 24),
                      // تقویم
                      _buildCalendar(
                        context,
                        isDarkMode,
                        textColor,
                        secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // دکمه انتخاب تاریخ
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _buildDatePickerButton(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
            this.focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            this.focusedDay = focusedDay;
          });
        },
        calendarFormat: calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            calendarFormat = format;
          });
        },
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          formatButtonTextStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            color: Colors.white,
          ),
          formatButtonDecoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: CupertinoColors.activeBlue,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: CupertinoColors.activeBlue,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,
          ),
          weekendStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.red.shade300,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: CupertinoColors.activeBlue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: CupertinoColors.activeBlue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 16,
            color: textColor,
          ),
          weekendTextStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 16,
            color: Colors.red.shade300,
          ),
          outsideTextStyle: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 16,
            color: secondaryTextColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
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
        onPressed: () {
          _showIOSDatePicker(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.calendar_today,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "انتخاب تاریخ با پیکر",
              style: TextStyle(
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

  void _showIOSDatePicker(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // دستگیره بالایی
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              // هدر DatePicker
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'انصراف',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 16,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'انتخاب تاریخ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'تأیید',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // DatePicker
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  backgroundColor: Colors.transparent,
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== Selected Date Card ==============
class SelectedDateCard extends StatelessWidget {
  final DateTime selectedDate;

  const SelectedDateCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // نام ماه‌ها به فارسی
    final persianMonths = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];

    // نام روزهای هفته به فارسی
    final persianWeekDays = [
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه',
      'شنبه',
    ];

    final day = selectedDate.day;
    final month = persianMonths[selectedDate.month - 1];
    final year = selectedDate.year;
    final weekDay = persianWeekDays[selectedDate.weekday - 1];

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(15, 56, 90, 1),
            const Color.fromRGBO(13, 85, 125, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // روز هفته
            Text(
              weekDay,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            const Spacer(),

            // تاریخ به صورت بزرگ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // روز
                Text(
                  day.toString(),
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // ماه و سال
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      year.toString(),
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
