import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';
import 'package:transfer_app/services/user_session.dart';
import 'write_post_page.dart';
import 'post_detail_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<dynamic> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final data = await ApiService.getPosts();
      setState(() {
        _posts = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print('게시글 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('커뮤니티', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WritePostPage()),
          );
          if (result == true) {
            _loadPosts();
          }
        },
        backgroundColor: const Color(0xFF2D6CDF),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _posts.isEmpty
          ? const Center(child: Text('아직 게시글이 없어요', style: TextStyle(color: Colors.grey)))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _posts.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final post = _posts[index];
          // 이렇게 바꿔
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
              );
              _loadPosts();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF3FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      post['category'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2D6CDF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post['title'] ?? '',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post['content'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (post['anonymous'] == true) ? '익명' : (post['user']?['name'] ?? '익명'),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.favorite_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${post['likes'] ?? 0}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}