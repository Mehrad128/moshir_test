import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:moshir_test/services/biometric_service.dart';

class BiometricSettingsPage extends StatefulWidget {
  const BiometricSettingsPage({super.key});

  @override
  State<BiometricSettingsPage> createState() => _BiometricSettingsPageState();
}

class _BiometricSettingsPageState extends State<BiometricSettingsPage> {
  final _service = BiometricService();
  bool _isLoading = true;
  bool _isAvailable = false;
  bool _isEnabled = false;
  String _biometricName = 'بیومتریک';
  IconData _biometricIcon = Icons.fingerprint;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _isAvailable = await _service.isAvailable;
    if (_isAvailable) {
      _biometricName = await _service.getBiometricName();
      _biometricIcon = await _service.getBiometricIcon();
      _isEnabled = await _service.isEnabled;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _toggle(bool value) async {
    setState(() => _isLoading = true);

    if (value) {
      final success = await _service.enableBiometric(
        userId: 'current_user_id',
        password: 'current_password',
      );
      if (success) {
        _showMessage('✅ فعال شد');
      }
    } else {
      await _service.disableBiometric();
      _showMessage('🔴 غیرفعال شد');
    }

    await _loadData();
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _testAuth() async {
    final result = await _service.authenticate(reason: 'تست بیومتریک');
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(result.success ? '✅ موفق' : '❌ ناموفق'),
        content: Text(result.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('باشه'),
          ),
        ],
      ),
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
              child: Column(
                children: [
                  if (!_isAvailable) _buildUnavailable(),
                  if (_isAvailable) ...[
                    _buildCard(isDark),
                    const SizedBox(height: 24),
                    _buildTestButton(),
                  ],
                ],
              ),
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
            'بیومتریک پشتیبانی نمی‌شود',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'دستگاه شما از احراز هویت بیومتریک پشتیبانی نمی‌کند.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(bool isDark) {
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
            child: Icon(_biometricIcon, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ورود با $_biometricName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'از این قابلیت برای ورود سریع استفاده کنید',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(
            value: _isEnabled,
            onChanged: _toggle,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton() {
    return ElevatedButton.icon(
      onPressed: _testAuth,
      icon: const Icon(Icons.fingerprint),
      label: const Text('تست بیومتریک'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
