import 'package:camera/camera.dart';
import 'package:face_recognition_auth/face_recognition_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceCameraService {
  static final FaceCameraService _instance = FaceCameraService._internal();
  factory FaceCameraService() => _instance;
  FaceCameraService._internal();

  // کنترلر اصلی پکیج
  final FaceAuthController _controller = FaceAuthController();
  bool _isInitialized = false;

  // وضعیت فعال بودن سرویس برای کاربر جاری
  bool _isEnabled = false;
  String? _currentUserId; // شناسه کاربر در اپ شما

  // کلیدهای ذخیره‌سازی
  static const String _prefEnabled = 'face_camera_enabled';
  static const String _prefUserId = 'face_camera_user_id';
  static const String _prefFaceUserId = 'face_camera_face_user_id'; // شناسه برگشتی از پکیج

  // ============== متدهای عمومی ==============

  /// بررسی وجود دوربین جلو (با کش)
  Future<bool> hasFrontCamera() async {
    try {
      if (!_isInitialized) {
        final cameras = await availableCameras();
        return cameras.any((c) => c.lensDirection == CameraLensDirection.front);
      }
      return true; // اگر قبلاً مقداردهی شده، فرض می‌کنیم وجود دارد
    } catch (e) {
      debugPrint('❌ خطا در بررسی دوربین جلو: $e');
      return false;
    }
  }

  /// آیا سرویس برای کاربر فعلی فعال است؟
  Future<bool> get isEnabled async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(_prefEnabled) ?? false;
    return _isEnabled;
  }

/// فعال‌سازی سرویس (ثبت چهره)
Future<bool> enableFaceCamera({required String userId}) async {
  try {
    // ۱. اطمینان از وجود دوربین جلو
    final hasCam = await hasFrontCamera();
    if (!hasCam) return false;

    // ۲. مقداردهی اولیه کنترلر
    if (!_isInitialized) {
      await _controller.initialize();
      _isInitialized = true;
    }

    // ۳. ثبت چهره
    User? registeredUser;
    await _controller.register(
      userId: userId, // ✅ از ورودی متد استفاده کن
      samples: 5,
      onProgress: (state) {
        debugPrint('وضعیت ثبت: $state');
      },
      onDone: (user) {
        registeredUser = user;
      },
    );

    if (registeredUser == null) {
      debugPrint('❌ ثبت چهره ناموفق بود');
      return false;
    }

    // ۴. ذخیره اطلاعات
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefEnabled, true);
    await prefs.setString(_prefUserId, userId);
    await prefs.setString(_prefFaceUserId, registeredUser!.id);

    _isEnabled = true;
    _currentUserId = userId;
    return true;
  } catch (e) {
    debugPrint('❌ خطا در فعال‌سازی: $e');
    return false;
  }
}

  /// غیرفعال‌سازی سرویس (حذف اطلاعات چهره)
  Future<void> disableFaceCamera() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefEnabled);
      await prefs.remove(_prefUserId);
      await prefs.remove(_prefFaceUserId);

      // پاک کردن داده‌های پکیج (اختیاری)
      // پکیج اطلاعات را در حافظه داخلی خود نگه می‌دارد، اما با حذف کاربر، نیازی به پاکسازی نیست
      _isEnabled = false;
      _currentUserId = null;
    } catch (e) {
      debugPrint('❌ خطا در غیرفعال‌سازی: $e');
    }
  }

  /// احراز هویت با چهره
  Future<bool> authenticateWithFace() async {
    try {
      // ۱. بررسی فعال بودن
      if (!(await isEnabled)) return false;

      // ۲. مقداردهی اولیه اگر نشده
      if (!_isInitialized) {
        await _controller.initialize();
        _isInitialized = true;
      }

      // ۳. دریافت شناسه کاربر چهره ذخیره‌شده
      final prefs = await SharedPreferences.getInstance();
      final storedFaceUserId = prefs.getString(_prefFaceUserId);
      if (storedFaceUserId == null) return false;

      // ۴. ورود
      User? loggedInUser;
      await _controller.login(
        onProgress: (state) {
          debugPrint('وضعیت ورود: $state');
        },
        onDone: (user) {
          loggedInUser = user;
        },
      );

      // ۵. بررسی تطابق
      return loggedInUser != null && loggedInUser?.id == storedFaceUserId;
    } catch (e) {
      debugPrint('❌ خطا در احراز هویت با چهره: $e');
      return false;
    }
  }

  /// پاکسازی منابع (در صورت نیاز)
  Future<void> dispose() async {
    _controller.dispose();
    _isInitialized = false;
  }
}
