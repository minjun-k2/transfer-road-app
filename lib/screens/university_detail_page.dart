import 'package:flutter/material.dart';

// 이렇게 바꿔
class UniversityDetailPage extends StatefulWidget {
  final Map<String, String> university;
  final bool isFavorite;
  final Function(Map<String, String>) onToggleFavorite;
  final String transferType;
  final String category;

  const UniversityDetailPage({
    super.key,
    required this.university,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.transferType,
    required this.category,
  });

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.university;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        // 이렇게 바꿔
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(u['name']!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('${widget.transferType} · ${widget.category}계열', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_outline,
              color: _isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              widget.onToggleFavorite(widget.university);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 상단 대학 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF2D6CDF), size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(u['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tag(u['category']!),
                      const SizedBox(width: 8),
                      _tag(u['exam']!),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 모집 정보
            _sectionBox(
              title: '모집 정보',
              children: [
                _infoRow(Icons.people_outline, '모집인원 (TO)', u['to']!),
                _divider(),
                _infoRow(Icons.edit_outlined, '전형 방법', u['exam']!),
                _divider(),
                _infoRow(Icons.category_outlined, '계열', u['category']!),
              ],
            ),
            const SizedBox(height: 16),

            // 일정 정보
            _sectionBox(
              title: '전형 일정',
              children: [
                _infoRow(Icons.assignment_outlined, '원서 접수', u['deadline']!),
                _divider(),
                _infoRow(Icons.edit_calendar_outlined, '시험일', '2025.02.01'),
                _divider(),
                _infoRow(Icons.campaign_outlined, '합격 발표', '2025.02.15'),
              ],
            ),
            const SizedBox(height: 16),

            // 지원 자격
            _sectionBox(
              title: '지원 자격',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('• 전문대학 졸업(예정)자', style: TextStyle(fontSize: 14, height: 1.8)),
                      Text('• 4년제 대학교 1학년 이상 수료자', style: TextStyle(fontSize: 14, height: 1.8)),
                      Text('• 학점은행제 70학점 이상 취득자', style: TextStyle(fontSize: 14, height: 1.8)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionBox({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2D6CDF), size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE));

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF2D6CDF), fontWeight: FontWeight.w600)),
    );
  }
}