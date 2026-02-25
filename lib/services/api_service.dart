import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<(List<Post>, int)> fetchPosts({required int page, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/posts?_page=$page&_limit=$limit');
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'application/json, text/plain, */*',
          'Accept-Language': 'en-US,en;q=0.9',
          'Cache-Control': 'no-cache',
        },
      );

      if (response.statusCode == 200) {
        List jsonList = json.decode(response.body);
        List<Post> posts = jsonList.map((e) => Post.fromJson(e)).toList();
        int totalCount = posts.length;
        if (response.headers.containsKey('x-total-count')) {
          totalCount = int.tryParse(response.headers['x-total-count']!) ?? posts.length;
        }
        return (posts, totalCount);
      } else {
        throw Exception('خطا در دریافت داده‌ها (کد ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('اتصال به اینترنت را بررسی کنید: $e');
    }
  }
}