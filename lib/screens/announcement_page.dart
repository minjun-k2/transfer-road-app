import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<dynamic> _announcements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data = await ApiService.getAnnouncements();
      setState(() {
        _announcements = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String _formatDate(String createdAt) {
    if (createdAt.length < 10) return '';
    return createdAt.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('공고', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _announcements.isEmpty
          ? const Center(child: Text('공고가 없어요', style: TextStyle(color: Colors.grey)))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _announcements.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFCCCCCC)),
        itemBuilder: (context, index) {
          final a = _announcements[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementDetailPage(announcement: a),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a['universityName'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(a['title'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate((a['createdAt'] ?? '').toString()),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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

class AnnouncementDetailPage extends StatelessWidget {
  final dynamic announcement;

  const AnnouncementDetailPage({super.key, required this.announcement});

  String _formatDate(String createdAt) {
    if (createdAt.length < 10) return '';
    return createdAt.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('공고 상세', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement['universityName'] ?? '',
              style: const TextStyle(fontSize: 13, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              announcement['title'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate((announcement['createdAt'] ?? '').toString()),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              announcement['content'] ?? '',
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}