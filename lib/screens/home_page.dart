import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';
import 'package:transfer_app/services/user_session.dart';
import 'community_page.dart';
import 'announcement_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 이렇게 바꿔
  List<dynamic> _posts = [];
  List<dynamic> _announcements = [];
  bool _loading = true;
  bool _loadingAnnouncements = true;
  List<dynamic> _interestUniversities = [];
  bool _loadingInterest = true;

  // 이렇게 바꿔
  @override
  void initState() {
    super.initState();
    _loadPosts();
    _loadInterestUniversities();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data = await ApiService.getAnnouncements();
      setState(() {
        _announcements = data;
        _loadingAnnouncements = false;
      });
    } catch (e) {
      setState(() => _loadingAnnouncements = false);
      print('공고 불러오기 실패: $e');
    }
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
    }
  }

  Future<void> _loadInterestUniversities() async {
    try {
      final interest = await ApiService.getInterest(UserSession.userId!);
      if (interest == null) {
        setState(() => _loadingInterest = false);
        return;
      }

      final List<dynamic> result = [];
      for (final name in [interest['firstName'], interest['secondName'], interest['thirdName']]) {
        if (name != null && name.toString().isNotEmpty) {
          final u = await ApiService.getUniversityByName(name.toString());
          if (u != null) result.add(u);
        }
      }

      setState(() {
        _interestUniversities = result;
        _loadingInterest = false;
      });
    } catch (e) {
      setState(() => _loadingInterest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '편입로드',
          style: TextStyle(color: Color(0xFF1A2B4A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 관심 대학 공고 섹션
            if (!_loadingInterest && _interestUniversities.isNotEmpty)
              _sectionBox(
                title: '관심 대학 공고',
                children: _interestUniversities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final u = entry.value;
                  final ranks = ['1지망', '2지망', '3지망'];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EEF7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ranks[index],
                                style: const TextStyle(fontSize: 11, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u['name'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '접수: ${u['admissionStart'] ?? ''} ~ ${u['admissionEnd'] ?? ''}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '시험: ${u['examDate'] ?? ''}  발표: ${u['resultDate'] ?? ''}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != _interestUniversities.length - 1)
                        const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE)),
                    ],
                  );
                }).toList(),
              ),
            if (!_loadingInterest && _interestUniversities.isNotEmpty)
              const SizedBox(height: 16),

            // 최근 공고 섹션
            // 이렇게 바꿔
            _sectionBox(
              title: '최근 공고',
              // 이렇게 바꿔
              onMore: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
              },
              children: _loadingAnnouncements
                  ? [const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))]
                  : _announcements.isEmpty
                  ? [const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('공고가 없어요', style: TextStyle(color: Colors.grey))))]
              // 이렇게 바꿔
                  : _announcements.take(4).expand((a) {
                final createdAt = a['createdAt'] ?? '';
                final date = createdAt.toString().length >= 10 ? createdAt.toString().substring(0, 10) : '';
                return [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnnouncementDetailPage(announcement: a)),
                      );
                    },
                    child: _announcementItem(a['universityName'] ?? '', a['title'] ?? '', date),
                  ),
                  if (a != _announcements[_announcements.length > 4 ? 3 : _announcements.length - 1])
                    _divider(),
                ];
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 커뮤니티 섹션
            _sectionBox(
              title: '커뮤니티',
              onMore: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
              },
              children: _loading
                  ? [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ]
                  : _posts.isEmpty
                  ? [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text('아직 게시글이 없어요', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ]
                  : _buildCommunityItems(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommunityItems() {
    List<Widget> items = [];
    final displayPosts = _posts.take(4).toList();
    for (int i = 0; i < displayPosts.length; i++) {
      final post = displayPosts[i];
      items.add(_communityItem(
        post['category'] ?? '',
        post['title'] ?? '',
        (post['anonymous'] == true) ? '익명' : (post['user']?['name'] ?? '익명'),
        '좋아요 ${post['likes'] ?? 0}',
      ));
      if (i != displayPosts.length - 1) items.add(_divider());
    }
    return items;
  }

  Widget _sectionBox({required String title, required List<Widget> children, VoidCallback? onMore}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: onMore,
                  child: const Text('더보기', style: TextStyle(color: Color(0xFF1A2B4A), fontSize: 13)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ...children,
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE));

  Widget _announcementItem(String university, String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _communityItem(String category, String title, String author, String likes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEF7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              category,
              style: const TextStyle(fontSize: 11, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(author, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(likes, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}