import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceCameraService {
  static final FaceCameraService _instance = FaceCameraService._internal();
  factory FaceCameraService() => _instance;
  FaceCameraService._internal();

  bool _isInitialized = false;
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  bool _isFaceRegistered = false; // وضعیت ثبت چهره
  String? _registeredFacePath; // مسیر ذخیره ویژگی‌های چهره

  // بررسی وجود دوربین جلو
  Future<bool> hasFrontCamera() async {
    try {
      if (!_isInitialized) {
        _cameras = await availableCameras();
        _isInitialized = true;
      }
      return _cameras.any((camera) => camera.lensDirection == CameraLensDirection.front);
    } catch (e) {
      print('❌ خطا در بررسی دوربین جلو: $e');
      return false;
    }
  }

  // بررسی فعال بودن گزینه تشخیص چهره با دوربین (مشابه isEnabled)
  Future<bool> get isEnabled async {
    // می‌توانید از shared_preferences یا secure_storage استفاده کنید
    // در اینجا فرض می‌کنیم یک کلید ذخیره شده است
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('face_camera_enabled') ?? false;
  }

  // فعال‌سازی گزینه (با ثبت چهره)
  Future<bool> enableFaceCamera() async {
    try {
      // ابتدا ثبت چهره
      final registered = await _registerFace();
      if (!registered) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('face_camera_enabled', true);
      return true;
    } catch (e) {
      print('❌ خطا در فعال‌سازی: $e');
      return false;
    }
  }

  // غیرفعال‌سازی
  Future<void> disableFaceCamera() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('face_camera_enabled', false);
    _isFaceRegistered = false;
    _registeredFacePath = null;
  }

  // ثبت چهره (عملیات ساده)
  Future<bool> _registerFace() async {
    // اینجا باید با دوربین چند فریم گرفته و ویژگی‌های چهره را استخراج و ذخیره کنید
    // برای سادگی، فقط فرض می‌کنیم موفق است
    // در عمل باید از ML Kit Face Detector استفاده کنید
    // ...
    _isFaceRegistered = true;
    return true;
  }

  // احراز هویت با چهره
  Future<bool> authenticateWithFace() async {
    if (!(await isEnabled)) return false;

    // اینجا باید با دوربین چهره را تشخیص دهید و با چهره ثبت‌شده تطبیق دهید
    // برای سادگی، فرض می‌کنیم موفق است
    // ...
    return true;
  }
}
