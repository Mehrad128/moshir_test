import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// دریافت پست‌ها با صفحه و تعداد مشخص
  Future<List<Post>> fetchPosts({required int page, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/posts?_page=$page&_limit=$limit');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List jsonList = json.decode(response.body);
        return jsonList.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception('خطا در دریافت داده‌ها (کد ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('اتصال به اینترنت را بررسی کنید: $e');
    }
  }
}
