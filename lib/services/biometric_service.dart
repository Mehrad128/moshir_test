import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:moshir_test/services/biometric_types.dart';
import 'package:moshir_test/services/face_camera_service.dart'; // اضافه شد

/// نتیجه احراز هویت
class BiometricAuthResult {
  final bool success;
  final String message;
  final String? errorCode;
  final MyBiometricType? biometricType;

  BiometricAuthResult({
    required this.success,
    required this.message,
    this.errorCode,
    this.biometricType,
  });
}

/// سرویس مدیریت بیومتریک و فینگرپرینت
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _userIdKey = 'biometric_user_id';
  static const String _passwordKey = 'biometric_user_password';
  static const String _biometricEnabledKey = 'biometric_enabled';

  bool get _isWeb => kIsWeb;

  // ============== بررسی وضعیت ==============

  /// آیا دستگاه از بیومتریک پشتیبانی میکند؟
  Future<bool> get isAvailable async {
    try {
      if (_isWeb) {
        return await _localAuth.isDeviceSupported();
      }
      
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      
      return canCheck || isSupported;
    } catch (e) {
      print('❌ خطا در بررسی بیومتریک: $e');
      return false;
    }
  }

  /// دریافت لیست روش‌های موجود
  Future<List<MyBiometricType>> getAvailableBiometrics() async {
    try {
      final List<MyBiometricType> result = [];
      
      if (_isWeb) {
        final isSupported = await _localAuth.isDeviceSupported();
        if (isSupported) {
          result.add(MyBiometricType.fingerprint);
        }
        return result;
      }
      
      final types = await _localAuth.getAvailableBiometrics();
      
      for (var type in types) {
        final typeStr = type.toString().toLowerCase();
        
        if (typeStr.contains('fingerprint')) {
          result.add(MyBiometricType.fingerprint);
        } else if (typeStr.contains('face')) {
          result.add(MyBiometricType.face);
        } else if (typeStr.contains('iris')) {
          result.add(MyBiometricType.iris);
        } else {
          result.add(MyBiometricType.other);
        }
      }
      
      return result;
    } catch (e) {
      print('❌ خطا در دریافت انواع بیومتریک: $e');
      return [];
    }
  }

  /// دریافت نام مناسب برای اولین روش موجود
  Future<String> getBiometricName() async {
    try {
      final types = await getAvailableBiometrics();
      if (types.isNotEmpty) {
        return types.first.persianName;
      }
      
      if (_isWeb) return 'WebAuthn';
      return 'بیومتریک';
    } catch (e) {
      return 'بیومتریک';
    }
  }

  /// دریافت آیکون مناسب
  Future<IconData> getBiometricIcon() async {
    try {
      final types = await getAvailableBiometrics();
      if (types.isNotEmpty) {
        return types.first.icon;
      }
      return Icons.fingerprint;
    } catch (e) {
      return Icons.fingerprint;
    }
  }

  /// آیا بیومتریک فعال شده؟
  Future<bool> get isEnabled async {
    try {
      final enabled = await _secureStorage.read(key: _biometricEnabledKey);
      return enabled == 'true';
    } catch (_) {
      return false;
    }
  }

  /// آیا فینگرپرینت موجود است؟
  Future<bool> get isFingerprintAvailable async {
    final types = await getAvailableBiometrics();
    return types.contains(MyBiometricType.fingerprint);
  }

  /// آیا Face ID موجود است؟
  Future<bool> get isFaceAvailable async {
    final types = await getAvailableBiometrics();
    return types.contains(MyBiometricType.face);
  }

  // ============== متد جدید برای بررسی دوربین جلو ==============
  /// بررسی وجود دوربین جلو برای تشخیص چهره با دوربین
  Future<bool> get hasFrontCamera async {
    final faceService = FaceCameraService();
    return await faceService.hasFrontCamera();
  }

  // ============== احراز هویت ==============

  /// احراز هویت با بیومتریک
  Future<BiometricAuthResult> authenticate({required String reason}) async {
    try {
      final available = await isAvailable;
      if (!available) {
        return BiometricAuthResult(
          success: false,
          message: 'دستگاه شما از بیومتریک پشتیبانی نمی‌کند',
        );
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        return BiometricAuthResult(
          success: true,
          message: '✅ احراز هویت موفق',
          biometricType: await _getUsedBiometricType(),
        );
      } else {
        return BiometricAuthResult(
          success: false,
          message: '❌ عملیات لغو شد',
        );
      }
    } catch (e) {
      return BiometricAuthResult(
        success: false,
        message: 'خطا: ${e.toString()}',
      );
    }
  }

  /// احراز هویت فقط با فینگرپرینت
  Future<BiometricAuthResult> authenticateWithFingerprint({
    required String reason,
  }) async {
    try {
      final hasFingerprint = await isFingerprintAvailable;
      if (!hasFingerprint) {
        return BiometricAuthResult(
          success: false,
          message: 'فینگرپرینت روی این دستگاه موجود نیست',
        );
      }

      return await authenticate(reason: reason);
    } catch (e) {
      return BiometricAuthResult(
        success: false,
        message: 'خطا: ${e.toString()}',
      );
    }
  }

  /// تشخیص نوع بیومتریک استفاده شده
  Future<MyBiometricType?> _getUsedBiometricType() async {
    final types = await getAvailableBiometrics();
    return types.isNotEmpty ? types.first : null;
  }

  // ============== ذخیره‌سازی ==============

  /// فعال‌سازی بیومتریک
  Future<bool> enableBiometric({
    required String userId,
    required String password,
  }) async {
    try {
      final authResult = await authenticate(
        reason: 'برای فعال‌سازی، احراز هویت کنید',
      );
      
      if (!authResult.success) return false;

      await _secureStorage.write(key: _userIdKey, value: userId);
      await _secureStorage.write(key: _passwordKey, value: password);
      await _secureStorage.write(key: _biometricEnabledKey, value: 'true');

      return true;
    } catch (e) {
      print('❌ خطا در فعال‌سازی بیومتریک: $e');
      return false;
    }
  }

  /// غیرفعال‌سازی بیومتریک
  Future<bool> disableBiometric() async {
    try {
      await _secureStorage.delete(key: _userIdKey);
      await _secureStorage.delete(key: _passwordKey);
      await _secureStorage.write(key: _biometricEnabledKey, value: 'false');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// دریافت اطلاعات ذخیره‌شده
  Future<Map<String, String?>> getCredentials() async {
    try {
      final authResult = await authenticate(
        reason: 'برای ورود خودکار، احراز هویت کنید',
      );
      
      if (!authResult.success) {
        return {'error': authResult.message};
      }

      final id = await _secureStorage.read(key: _userIdKey);
      final pass = await _secureStorage.read(key: _passwordKey);

      return {'userId': id, 'password': pass};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// پاک کردن همه اطلاعات
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  /// دریافت آمار بیومتریک برای نمایش
  Future<Map<String, dynamic>> getBiometricStats() async {
    final available = await isAvailable;
    final enabled = await isEnabled;
    final types = await getAvailableBiometrics();
    final name = await getBiometricName();
    
    return {
      'available': available,
      'enabled': enabled,
      'types': types.map((t) => t.persianName).toList(),
      'name': name,
      'hasFingerprint': types.contains(MyBiometricType.fingerprint),
      'hasFace': types.contains(MyBiometricType.face),
    };
  }
}
