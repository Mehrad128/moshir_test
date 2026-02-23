import 'package:flutter/material.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'onboarding_model.dart';
import 'onboarding_page.dart';
import 'onboarding_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      imagePath: 'assets/images/01.jpg',
      title: 'به مشیر خوش آمدید',
      description: 'اپلیکیشن جامع مدیریت امور کارگزینی و استخدام',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/03.jpg',
      title: 'مدیریت جامع پرسنل',
      description: 'اطلاعات کامل پرسنل، قراردادها و سوابق شغلی',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/04.jpg',
      title: 'استخدام هوشمند',
      description: 'فرآیند استخدام از آگهی تا عقد قرارداد',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/08.jpg',
      title: 'امور اداری',
      description: 'مدیریت مرخصی، مأموریت و درخواست‌های اداری',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/09.jpg',
      title: 'حقوق و دستمزد',
      description: 'محاسبه حقوق، بیمه، مالیات و فیش حقوقی',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // صفحات
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                page: _pages[index],
                isLastPage: index == _pages.length - 1,
                onNext: _completeOnboarding,
                onSkip: _skipOnboarding,
              );
            },
          ),

          // اندیکاتور (نقطه‌ها)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Color.fromRGBO(255, 222, 47, 1)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await OnboardingManager.setOnboardingSeen();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
