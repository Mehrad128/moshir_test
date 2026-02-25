import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:moshir_test/services/biometric_service.dart';
import 'package:moshir_test/services/biometric_types.dart';
import 'package:moshir_test/services/face_camera_service.dart';
import 'package:moshir_test/services/auth_service.dart'; // فرض می‌کنیم این سرویس وجود دارد

class BiometricSettingsPage extends StatefulWidget {
  const BiometricSettingsPage({super.key});

  @override
  State<BiometricSettingsPage> createState() => _BiometricSettingsPageState();
}

class _BiometricSettingsPageState extends State<BiometricSettingsPage> {
  final _bioService = BiometricService();
  final _faceService = FaceCameraService();
  final _authService = AuthService(); // سرویس احراز هویت

  bool _isLoading = true;
  bool _hasStrongBiometric = false;
  bool _strongEnabled = false;
  String _strongName = 'اثر انگشت';
  IconData _strongIcon = Icons.fingerprint;

  bool _hasFrontCamera = false;
  bool _faceCameraEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _hasStrongBiometric = await _bioService.isAvailable;
    if (_hasStrongBiometric) {
      final types = await _bioService.getAvailableBiometrics();
      if (types.contains(MyBiometricType.fingerprint)) {
        _strongName = 'اثر انگشت';
        _strongIcon = Icons.fingerprint;
      } else if (types.contains(MyBiometricType.face)) {
        _strongName = 'تشخیص چهره (امن)';
        _strongIcon = Icons.face;
      } else {
        _strongName = 'بیومتریک';
        _strongIcon = Icons.biotech;
      }
      _strongEnabled = await _bioService.isEnabled;
    }

    _hasFrontCamera = await _faceService.hasFrontCamera();
    if (_hasFrontCamera) {
      _faceCameraEnabled = await _faceService.isEnabled;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _toggleStrong(bool value) async {
    setState(() => _isLoading = true);
    if (value) {
      final success = await _bioService.enableBiometric(
        userId: 'current_user_id',
        password: 'current_password',
      );
      if (success) _showMessage('✅ بیومتریک امن فعال شد');
    } else {
      await _bioService.disableBiometric();
      _showMessage('🔴 بیومتریک امن غیرفعال شد');
    }
    await _loadData();
  }

  Future<void> _toggleFaceCamera(bool value) async {
    setState(() => _isLoading = true);

    final currentUserId = await _authService.getCurrentUser();
    if (currentUserId == null) {
      _showMessage('❌ کاربر وارد نشده است');
      setState(() => _isLoading = false);
      return;
    }

    if (value) {
      final success = await _faceService.enableFaceCamera(
        userId: currentUserId,
      );
      if (success) {
        _showMessage('✅ تشخیص چهره با دوربین فعال شد');
      } else {
        _showMessage('❌ فعال‌سازی ناموفق بود');
      }
    } else {
      await _faceService.disableFaceCamera();
      _showMessage('🔴 تشخیص چهره با دوربین غیرفعال شد');
    }
    await _loadData();
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('تنظیمات بیومتریک'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  if (!_hasStrongBiometric && !_hasFrontCamera)
                    _buildUnavailable(),
                  if (_hasStrongBiometric)
                    _buildCard(
                      title: 'ورود با $_strongName',
                      subtitle: 'روش امن مبتنی بر سخت‌افزار',
                      icon: _strongIcon,
                      value: _strongEnabled,
                      onChanged: _toggleStrong,
                      isDark: isDark,
                    ),
                  if (_hasFrontCamera) ...[
                    const SizedBox(height: 16),
                    _buildCard(
                      title: 'ورود با چهره (دوربین)',
                      subtitle: 'تشخیص چهره با دوربین - امنیت کمتر',
                      icon: Icons.camera_front,
                      value: _faceCameraEnabled,
                      onChanged: _toggleFaceCamera,
                      isDark: isDark,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_hasStrongBiometric || _hasFrontCamera)
                    _buildTestButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildUnavailable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.warning, size: 48, color: Colors.orange.shade700),
          const SizedBox(height: 16),
          const Text(
            'هیچ روش بیومتریکی یافت نشد',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'دستگاه شما از احراز هویت بیومتریک پشتیبانی نمی‌کند و دوربین جلویی برای تشخیص چهره موجود نیست.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _testStrongAuth,
          icon: const Icon(Icons.fingerprint),
          label: const Text('تست بیومتریک امن'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        if (_hasFrontCamera)
          ElevatedButton.icon(
            onPressed: _testFaceCamera,
            icon: const Icon(Icons.camera_alt),
            label: const Text('تست تشخیص چهره با دوربین'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green,
            ),
          ),
      ],
    );
  }

  Future<void> _testStrongAuth() async {
    if (!_hasStrongBiometric) {
      _showMessage('بیومتریک امن در دسترس نیست');
      return;
    }
    final result = await _bioService.authenticate(reason: 'تست بیومتریک امن');
    _showDialog(result.success ? '✅ موفق' : '❌ ناموفق', result.message);
  }

  Future<void> _testFaceCamera() async {
    if (!_hasFrontCamera) {
      _showMessage('دوربین جلو موجود نیست');
      return;
    }
    final success = await _faceService.authenticateWithFace();
    if (success) {
      _showDialog('✅ موفق', 'چهره تطابق داشت');
    } else {
      _showDialog(
        '❌ ناموفق',
        'چهره شناسایی نشد یا با کاربر ثبت‌شده مطابقت نداشت',
      );
    }
  }

  void _showDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }
}
