import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel page;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPage({
    super.key,
    required this.page,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // ✅ عکس تمام صفحه
          Positioned.fill(
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.cover, // مهم: کل صفحه رو می‌پوشونه
              alignment: Alignment.center,
            ),
          ),

          // ✅ گرادیانت تیره برای خوانایی متن
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // ✅ محتوای متن
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // عنوان
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // توضیحات
                  Text(
                    page.description,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  // دکمه شروع
                  if (isLastPage)
                    ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'شروع کنید',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // دکمه رد کردن
                  if(!isLastPage)
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'رد کردن',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),

                  // const Spacer(),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
