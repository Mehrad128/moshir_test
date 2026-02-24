import 'package:flutter/material.dart';
import 'package:moshir_test/models/post.dart';
import 'package:moshir_test/services/api_service.dart';

class LazyLoadingPage extends StatefulWidget {
  const LazyLoadingPage({super.key});

  @override
  State<LazyLoadingPage> createState() => _LazyLoadingPageState();
}

class _LazyLoadingPageState extends State<LazyLoadingPage> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Post> _posts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// دریافت داده‌های صفحه اول
  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final posts = await _apiService.fetchPosts(page: 1);
      setState(() {
        _posts = posts;
        _currentPage = 1;
        _hasMore = posts.length >= 10; // اگر ۱۰ تا دریافت شد، صفحات بعدی هم هست
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// دریافت صفحات بعدی (بارگذاری بیشتر)
  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final nextPage = _currentPage + 1;
      final newPosts = await _apiService.fetchPosts(page: nextPage);
      setState(() {
        if (newPosts.isEmpty) {
          _hasMore = false;
        } else {
          _posts.addAll(newPosts);
          _currentPage = nextPage;
          _hasMore = newPosts.length >= 10;
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// تشخیص نزدیک شدن به انتهای لیست
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lazy Loading با JSONPlaceholder')),
      body: RefreshIndicator(
        onRefresh: _fetchInitialData,
        child: Column(
          children: [
            // بخش Lazy Row (افقی)
            SizedBox(
              height: 120,
              child: _buildLazyRow(),
            ),
            const Divider(),
            // بخش Lazy Loading عمودی
            Expanded(
              child: _buildLazyList(),
            ),
          ],
        ),
      ),
    );
  }

  /// لیست افقی با Lazy Loading (Lazy Row)
  Widget _buildLazyRow() {
    final horizontalPosts = _posts.take(10).toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: horizontalPosts.length,
      itemBuilder: (context, index) {
        final post = horizontalPosts[index];
        return Container(
          width: 150,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${post.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  post.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// لیست عمودی با Lazy Loading
  Widget _buildLazyList() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('خطا: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchInitialData,
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _posts.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text('${post.id}. ${post.title}'),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleAvatar(child: Text('${post.userId}')),
          ),
        );
      },
    );
  }
}
