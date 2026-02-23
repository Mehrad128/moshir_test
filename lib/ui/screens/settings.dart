import 'package:flutter/material.dart';
import 'package:moshir_test/ui/components/bottom_navi.dart';
import 'package:moshir_test/ui/components/theme_notifier.dart';
import 'package:moshir_test/ui/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(),

                const SizedBox(height: 40),

                // ✅ کارت تنظیم تم
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF1C1C1E)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_6,
                            color: isDarkMode ? Colors.orange : Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'تنظیمات تم',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "برای راحتی شما، اپلیکیشن این امکان را فراهم کرده که تم روشن یا تاریک را انتخاب کنید. "
                        "برای تغییر تم، کافی است از دکمه زیر استفاده کنید.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            themeNotifier.toggleTheme();
                          },
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          ),
                          label: Text(isDarkMode ? "تم روشن" : "تم تاریک"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? Colors.orange
                                : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ کارت تنظیم درصد تکمیل پروفایل
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1C1C1E)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.percent, color: Colors.green),
                              const SizedBox(width: 12),
                              Text(
                                'درصد تکمیل پروفایل',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // نمایش درصد فعلی
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'مقدار فعلی:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${settings.profileCompletionPercent}%',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // اسلایدر
                          Text(
                            'تنظیم درصد:',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: Colors.green,
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: Colors.green,
                              overlayColor: Colors.green.withOpacity(0.2),
                              valueIndicatorColor: Colors.green,
                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: Slider(
                              value: settings.profileCompletion,
                              min: 0,
                              max: 1,
                              divisions: 100,
                              label:
                                  '${(settings.profileCompletion * 100).toStringAsFixed(0)}%',
                              onChanged: (value) {
                                settings.profileCompletion = value;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // دکمه‌های سریع
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuickButton(
                                context: context,
                                label: '۲۵%',
                                value: 0.25,
                                isDarkMode: isDarkMode,
                              ),
                              _buildQuickButton(
                                context: context,
                                label: '۵۰%',
                                value: 0.50,
                                isDarkMode: isDarkMode,
                              ),
                              _buildQuickButton(
                                context: context,
                                label: '۸۵%',
                                value: 0.85,
                                isDarkMode: isDarkMode,
                              ),
                              _buildQuickButton(
                                context: context,
                                label: '۱۰۰%',
                                value: 1.0,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }

  Widget _buildQuickButton({
    required BuildContext context,
    required String label,
    required double value,
    required bool isDarkMode,
  }) {
    return ElevatedButton(
      onPressed: () {
        context.read<SettingsProvider>().profileCompletion = value;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ✅ ویجت Header برای صفحه تنظیمات
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _SettingsBackButton(),
        Text(
          "تنظیمات",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 40), // برای متعادل کردن
      ],
    );
  }
}

// ✅ دکمه برگشت
class _SettingsBackButton extends StatelessWidget {
  const _SettingsBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
