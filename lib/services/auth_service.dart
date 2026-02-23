import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  /// افزودن کاربر پیش‌فرض
  Future<void> _ensureDefaultUser() async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    if (users.isEmpty) {
      users.add('test:123456');
      users.add('admin:admin123');
      users.add('moshir:moshir123');
      await prefs.setStringList(_usersKey, users);
      print('✅ کاربران پیش‌فرض اضافه شدند');
    }
  }

  /// ثبت‌نام کاربر جدید
  Future<bool> register(String username, String password) async {
    await _ensureDefaultUser();
    
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    for (var user in users) {
      final parts = user.split(':');
      if (parts[0] == username) {
        return false; // کاربر تکراری
      }
    }
    
    users.add('$username:$password');
    await prefs.setStringList(_usersKey, users);
    return true;
  }

  /// ورود کاربر
  Future<bool> login(String username, String password) async {
    await _ensureDefaultUser();
    
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    for (var user in users) {
      final parts = user.split(':');
      if (parts[0] == username && parts[1] == password) {
        await prefs.setString(_currentUserKey, username);
        return true;
      }
    }
    
    return false;
  }

  /// خروج از حساب
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// دریافت کاربر فعلی
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  /// دریافت همه کاربران
  Future<List<String>> getAllUsers() async {
    await _ensureDefaultUser();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usersKey) ?? [];
  }

  /// حذف کاربر
  Future<bool> deleteUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    final newUsers = users.where((user) {
      final parts = user.split(':');
      return !(parts[0] == username && parts[1] == password);
    }).toList();
    
    if (users.length == newUsers.length) return false;
    
    await prefs.setStringList(_usersKey, newUsers);
    return true;
  }
}
