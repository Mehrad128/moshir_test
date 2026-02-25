import 'dart:ui';
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
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final (posts, totalCount) = await _apiService.fetchPosts(page: 1);
      setState(() {
        _posts = posts;
        _currentPage = 1;
        _totalPages = (totalCount / 10).ceil();
        _hasMore = _currentPage < _totalPages;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final (newPosts, totalCount) = await _apiService.fetchPosts(page: page);
      setState(() {
        _posts = newPosts;
        _currentPage = page;
        _totalPages = (totalCount / 10).ceil();
        _hasMore = _currentPage < _totalPages;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _loadMore() async {
  //   if (_isLoading || !_hasMore) return;
  //   await _loadPage(_currentPage + 1);
  // }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     _loadMore();
  //   }
  // }

  Future<void> _goToPreviousPage() async {
    if (_currentPage > 1) await _loadPage(_currentPage - 1);
  }

  Future<void> _goToNextPage() async {
    if (_hasMore) await _loadPage(_currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Lazy Loading با استایل شیشه‌ای',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchInitialData,
          color: Colors.white,
          backgroundColor: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(height: kToolbarHeight + 20),
              SizedBox(height: 140, child: _buildLazyRow()),
              const Divider(color: Colors.white30),
              Expanded(child: _buildLazyList()),
              _buildPaginationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLazyRow() {
    final horizontalPosts = _posts.take(10).toList();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: horizontalPosts.length,
      itemBuilder: (context, index) {
        final post = horizontalPosts[index];
        return _buildGlassContainer(
          width: 160,
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${post.id}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  post.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLazyList() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('خطا: $_error', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildGlassButton(
              onPressed: _fetchInitialData,
              child: const Text('تلاش مجدد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildGlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.3),
                foregroundColor: Colors.white,
                child: Text('${post.userId}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.id}. ${post.title}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    double? width,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({required VoidCallback onPressed, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            foregroundColor: Colors.white,
            elevation: 0,
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildPaginationBar() {
    return _buildGlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            onPressed: _currentPage > 1 ? _goToPreviousPage : () {},
            child: const Text('قبلی'),
          ),
          Text(
            'صفحه $_currentPage از $_totalPages',
            style: const TextStyle(color: Colors.white),
          ),
          _buildGlassButton(
            onPressed: _hasMore ? _goToNextPage : () {},
            child: const Text('بعدی'),
          ),
        ],
      ),
    );
  }
}