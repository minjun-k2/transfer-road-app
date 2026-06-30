import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';
import 'package:transfer_app/services/user_session.dart';

class PostDetailPage extends StatefulWidget {
  final dynamic post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late dynamic _post;
  bool _liking = false;
  List<dynamic> _comments = [];
  bool _loadingComments = true;
  final _commentController = TextEditingController();
  bool _isAnonymous = true;
  bool _isLiked = false;

  // 이렇게 바꿔
  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadComments();
    _checkLiked();
  }

  Future<void> _checkLiked() async {
    try {
      final liked = await ApiService.isLiked(_post['id'], UserSession.userId!);
      setState(() => _isLiked = liked);
    } catch (e) {
      print('좋아요 확인 실패: $e');
    }
  }

  Future<void> _loadComments() async {
    try {
      final data = await ApiService.getComments(_post['id']);
      setState(() {
        _comments = data;
        _loadingComments = false;
      });
    } catch (e) {
      setState(() => _loadingComments = false);
    }
  }


  // 이렇게 바꿔
  Future<void> _likePost() async {
    if (_liking) return;
    setState(() => _liking = true);
    try {
      final updated = await ApiService.toggleLike(_post['id'], UserSession.userId!);
      setState(() {
        _post = updated;
        _isLiked = !_isLiked;
        _liking = false;
      });
    } catch (e) {
      setState(() => _liking = false);
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) return;
    try {
      await ApiService.createComment(
        postId: _post['id'],
        userId: UserSession.userId!,
        content: _commentController.text,
        isAnonymous: _isAnonymous,
      );
      _commentController.clear();
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 작성 실패')),
      );
    }
  }

  String _formatDate(String createdAt) {
    if (createdAt.length < 16) return '';
    final date = createdAt.substring(0, 10).split('-');
    final time = createdAt.substring(11, 16);
    return '${int.parse(date[1])}/${int.parse(date[2])} $time';
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = _post['anonymous'] == true;
    final authorName = isAnonymous ? '익명' : (_post['user']?['name'] ?? '익명');
    final createdAt = _post['createdAt'] ?? '';
    final formattedDate = _formatDate(createdAt.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, _post),
        ),
        title: const Text('게시글', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 정보
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF3FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.person, color: Color(0xFF2D6CDF), size: 22),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(formattedDate, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF3FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _post['category'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF2D6CDF), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 제목
                  Text(_post['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // 내용
                  Text(
                    _post['content'] ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),

                  // 좋아요 / 댓글
                  Row(
                    children: [
                      // 이렇게 바꿔
                      GestureDetector(
                        onTap: _likePost,
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_outline,
                              size: 20,
                              color: _isLiked ? Colors.red : Colors.black54,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '좋아요 ${_post['likes'] ?? 0}',
                              style: TextStyle(color: _isLiked ? Colors.red : Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.black54),
                          const SizedBox(width: 6),
                          Text('댓글 ${_comments.length}', style: const TextStyle(color: Colors.black54, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // 댓글 목록
                  if (_loadingComments)
                    const Center(child: CircularProgressIndicator())
                  else if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('첫 댓글을 남겨보세요', style: TextStyle(color: Colors.grey, fontSize: 13))),
                    )
                  else
                    ..._comments.map((comment) {
                      final commentAnonymous = comment['anonymous'] == true;
                      final commentAuthor = commentAnonymous ? '익명' : (comment['user']?['name'] ?? '익명');
                      final commentDate = _formatDate((comment['createdAt'] ?? '').toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.person, color: Colors.black54, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(commentAuthor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 6),
                                      Text(commentDate, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(comment['content'] ?? '', style: const TextStyle(fontSize: 14, height: 1.4)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),

          // 댓글 입력창
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isAnonymous = !_isAnonymous),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isAnonymous ? Colors.black87 : const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '익명',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isAnonymous ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}