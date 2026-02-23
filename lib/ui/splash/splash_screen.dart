import 'package:flutter/material.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moshir_test/ui/onboarding/onboarding_manager.dart';
import 'package:moshir_test/ui/onboarding/onboarding_screen.dart';
import 'package:moshir_test/ui/screens/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _mapOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() => _mapOpacity = 1.0);
    _initialize();
  }

  Future<void> _initialize() async {
    // انیمیشن محو شدن لوگو
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _logoOpacity = 1.0);
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // بررسی اولین بار اجرا
    final isFirstLaunch = await OnboardingManager.isFirstLaunch();

    if (!mounted) return;

    if (isFirstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(15, 56, 90, 1),
              Color.fromRGBO(13, 85, 125, 1),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _mapOpacity,
                duration: const Duration(seconds: 1),
                curve: Curves.easeIn,
                child: Opacity(
                  opacity: 0.10,
                  child: SvgPicture.asset(
                    'assets/images/Map.svg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _logoOpacity,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Logo_light.svg',
                          width: 100,
                          height: 100,
                        ),

                        const SizedBox(height: 20),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "BRANDBOOK MOSHIR",
                              style: const TextStyle(
                                fontFamily: 'Vazirmatn',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // const SizedBox(height: 4),
                            Text(
                              "WWW.MOSHIR.IR",
                              style: const TextStyle(
                                fontFamily: 'Vazirmatn',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
