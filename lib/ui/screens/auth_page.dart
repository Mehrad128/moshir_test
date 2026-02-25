import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:moshir_test/services/biometric_service.dart';
import 'package:moshir_test/services/biometric_settings.dart';
import 'package:moshir_test/services/face_camera_service.dart'; // اضافه شد
import 'package:moshir_test/services/auth_service.dart';
import 'package:moshir_test/services/biometric_types.dart';
import 'package:moshir_test/ui/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  // ============== کنترلرهای فرم ==============
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ============== وضعیت‌های UI ==============
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  // ============== وضعیت بیومتریک قوی ==============
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricName = 'بیومتریک';
  IconData _biometricIcon = Icons.fingerprint;
  bool _hasFingerprint = false;
  bool _hasFace = false;

  // ============== وضعیت تشخیص چهره با دوربین ==============
  bool _faceCameraAvailable = false;
  bool _faceCameraEnabled = false;

  // ============== انیمیشن‌ها ==============
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkBiometricStatus();
    _checkFaceCameraStatus();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============== بررسی وضعیت بیومتریک قوی ==============
  Future<void> _checkBiometricStatus() async {
    try {
      final service = BiometricService();
      final available = await service.isAvailable;
      final enabled = await service.isEnabled;
      final name = await service.getBiometricName();
      final icon = await service.getBiometricIcon();
      final types = await service.getAvailableBiometrics();

      if (mounted) {
        setState(() {
          _biometricAvailable = available;
          _biometricEnabled = enabled;
          _biometricName = name;
          _biometricIcon = icon;
          _hasFingerprint = types.contains(MyBiometricType.fingerprint);
          _hasFace = types.contains(MyBiometricType.face);
        });
      }

      _logBiometricStatus(available, enabled, types);

      if (_biometricEnabled && mounted) {
        _showBiometricPrompt();
      }
    } catch (e) {
      print('❌ خطا در بررسی بیومتریک: $e');
      if (mounted) {
        setState(() {
          _biometricAvailable = false;
          _hasFingerprint = false;
          _hasFace = false;
        });
      }
    }
  }

  // ============== بررسی وضعیت تشخیص چهره با دوربین ==============
  Future<void> _checkFaceCameraStatus() async {
    try {
      final service = FaceCameraService();
      final available = await service.hasFrontCamera();
      final enabled = await service.isEnabled;
      if (mounted) {
        setState(() {
          _faceCameraAvailable = available;
          _faceCameraEnabled = enabled;
        });
      }
      print('📱 وضعیت تشخیص چهره با دوربین:');
      print('   - دوربین جلو موجود: $available');
      print('   - فعال: $enabled');
    } catch (e) {
      print('❌ خطا در بررسی دوربین جلو: $e');
      if (mounted) {
        setState(() {
          _faceCameraAvailable = false;
          _faceCameraEnabled = false;
        });
      }
    }
  }

  void _logBiometricStatus(
    bool available,
    bool enabled,
    List<MyBiometricType> types,
  ) {
    print('📱 وضعیت بیومتریک:');
    print('   - پلتفرم: ${kIsWeb ? "وب" : "موبایل"}');
    print('   - موجود: $available');
    print('   - فعال: $enabled');
    print('   - نام: $_biometricName');
    print('   - فینگرپرینت: ${types.contains(MyBiometricType.fingerprint)}');
    print('   - تشخیص چهره: ${types.contains(MyBiometricType.face)}');
  }

  // ============== نمایش دیالوگ بیومتریک قوی ==============
  Future<void> _showBiometricPrompt() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('ورود با $_biometricName'),
        content: Text('می‌خواهید با $_biometricName وارد شوید؟'),
        actions: [
          CupertinoDialogAction(
            child: const Text('بعداً'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('ورود'),
            onPressed: () {
              Navigator.pop(context);
              _handleBiometricLogin();
            },
          ),
        ],
      ),
    );
  }

  // ============== عملیات‌های احراز هویت ==============
  Future<void> _handleBiometricLogin() async {
    setState(() => _isLoading = true);

    final service = BiometricService();
    final result = await service.authenticate(
      reason: 'ورود به مشیر با $_biometricName',
    );

    setState(() => _isLoading = false);

    if (result.success && mounted) {
      final credentials = await service.getCredentials();
      if (credentials['userId'] != null) {
        _navigateToHome();
      } else {
        _showErrorDialog('خطا', 'اطلاعات کاربری یافت نشد');
      }
    } else if (mounted) {
      _showErrorDialog('خطا', result.message);
    }
  }

  // ============== عملیات ورود با چهره (دوربین) ==============
  Future<void> _handleFaceLogin() async {
    final service = FaceCameraService();

    // بررسی فعال بودن سرویس چهره
    final isEnabled = await service.isEnabled;
    if (!isEnabled) {
      // اگر فعال نیست، کاربر را به صفحه تنظیمات هدایت کن
      final shouldNavigate = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ورود با چهره'),
          content: const Text(
            'ورود با چهره هنوز پیکربندی نشده است. آیا می‌خواهید به صفحه تنظیمات بروید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('خیر'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('بله'),
            ),
          ],
        ),
      );
      if (shouldNavigate == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BiometricSettingsPage()),
        );
      }
      return;
    }

    // اگر فعال است، احراز هویت را انجام بده
    setState(() => _isLoading = true);
    final success = await service.authenticateWithFace();
    setState(() => _isLoading = false);

    if (success && mounted) {
      _navigateToHome();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ ورود با چهره موفقیت‌آمیز بود')),
      );
    } else if (mounted) {
      _showErrorDialog('خطا', 'احراز هویت با چهره ناموفق بود');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    final authService = AuthService();
    final success = await authService.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      if (_rememberMe) {
        final service = BiometricService();
        await service.enableBiometric(
          userId: _usernameController.text,
          password: _passwordController.text,
        );
        await _checkBiometricStatus();
      }

      setState(() => _isLoading = false);
      _navigateToHome();
    } else if (mounted) {
      setState(() => _isLoading = false);
      _showErrorDialog('خطا', 'نام کاربری یا رمز عبور اشتباه است');
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('خطا', 'رمز عبور و تکرار آن مطابقت ندارند');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    final authService = AuthService();
    final success = await authService.register(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog('ثبت‌نام با موفقیت انجام شد');

      setState(() {
        _isLogin = true;
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
      _showErrorDialog('خطا', 'این نام کاربری قبلاً ثبت شده است');
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  // ============== دیالوگ‌ها ==============
  void _showErrorDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('باشه'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('✅ موفقیت'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('باشه'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ============== ویجت‌های فرم ==============
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/images/Logo.svg',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'به مشیر خوش آمدید',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isLogin ? 'وارد حساب کاربری خود شوید' : 'ثبت‌نام کنید',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _usernameController,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'نام کاربری',
        prefixIcon: Icon(CupertinoIcons.person, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفاً نام کاربری را وارد کنید';
        }
        if (value.length < 3) {
          return 'نام کاربری باید حداقل ۳ کاراکتر باشد';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
    String? label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label ?? 'رمز عبور',
        prefixIcon: Icon(CupertinoIcons.lock, color: Colors.blue),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفاً رمز عبور را وارد کنید';
        }
        if (value.length < 6) {
          return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
        }
        return null;
      },
    );
  }

  Widget _buildLoginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) =>
                  setState(() => _rememberMe = value ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Colors.blue,
            ),
            const Text('مرا به خاطر بسپار', style: TextStyle(fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () {}, // TODO: فراموشی رمز عبور
          child: const Text(
            'فراموشی رمز عبور؟',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : (_isLogin ? _handleLogin : _handleRegister),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _isLogin ? 'ورود' : 'ثبت‌نام',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // ============== بخش بیومتریک (شامل دکمه‌های جداگانه) ==============
  Widget _buildBiometricSection() {
    return Column(
      children: [
        // دکمه بیومتریک قوی (اثر انگشت/چهره امن)
        if (_biometricAvailable)
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleBiometricLogin,
              icon: Icon(_biometricIcon, color: Colors.blue),
              label: Text(
                _biometricEnabled
                    ? 'ورود با $_biometricName'
                    : 'پیکربندی ورود با $_biometricName',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

        // دکمه تشخیص چهره با دوربین
        if (_faceCameraAvailable) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleFaceLogin,
              icon: const Icon(Icons.face, color: Colors.green),
              label: Text(
                _faceCameraEnabled
                    ? 'ورود با چهره (دوربین)'
                    : 'پیکربندی ورود با چهره',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],

        // پیام راهنما
        const SizedBox(height: 16),
        Text(
          _biometricEnabled || _faceCameraEnabled
              ? 'با روش‌های بیومتریک سریع وارد شوید'
              : 'پس از ورود، گزینه "مرا به خاطر بسپار" را فعال کنید',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildToggleAuthMode() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? 'حساب کاربری ندارید؟' : 'قبلاً ثبت‌نام کرده‌اید؟',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              _usernameController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
            });
          },
          child: Text(
            _isLogin ? 'ثبت‌نام' : 'ورود',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F9FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.08),
                  _buildHeader(),
                  SizedBox(height: size.height * 0.04),

                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1C1C1E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildUsernameField(),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _passwordController,
                              isVisible: _isPasswordVisible,
                              onToggle: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                            ),
                            if (!_isLogin) ...[
                              const SizedBox(height: 16),
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                isVisible: _isConfirmPasswordVisible,
                                onToggle: () => setState(
                                  () => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                                ),
                                label: 'تکرار رمز عبور',
                              ),
                            ],
                            const SizedBox(height: 24),
                            if (_isLogin) _buildLoginOptions(),
                            _buildSubmitButton(),
                            _buildBiometricSection(), // بخش جدید شامل دو دکمه
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildToggleAuthMode(),
                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
