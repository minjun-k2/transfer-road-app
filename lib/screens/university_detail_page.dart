import 'package:flutter/material.dart';

class UniversityDetailPage extends StatefulWidget {
  final Map<String, String> university;
  final bool isFavorite;
  final Function(Map<String, String>) onToggleFavorite;

  const UniversityDetailPage({
    super.key,
    required this.university,
    required this.isFavorite,
    required this.onToggleFavorite,
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

  void _showToTable(BuildContext context) {
    String? selectedType;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('모집인원 확인', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),
                if (selectedType == null) ...[
                  const Text('편입 유형을 선택하세요', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedType = '일반편입'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EEF7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.school_outlined, color: Color(0xFF1A2B4A), size: 32),
                                SizedBox(height: 8),
                                Text('일반편입', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2B4A))),
                                SizedBox(height: 4),
                                Text('전문대 졸업자', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedType = '학사편입'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3EE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.menu_book_outlined, color: Colors.orange, size: 32),
                                SizedBox(height: 8),
                                Text('학사편입', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                                SizedBox(height: 4),
                                Text('4년제 재학자', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (selectedType != null) ...[
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => setModalState(() => selectedType = null),
                      ),
                      Text(selectedType!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFE8EEF7)),
                        children: const [
                          Padding(padding: EdgeInsets.all(10), child: Text('학과', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Padding(padding: EdgeInsets.all(10), child: Text('TO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
                        ],
                      ),
                      _tableRow('경영학과', '3'),
                      _tableRow('경제학과', '2'),
                      _tableRow('컴퓨터공학과', '5'),
                      _tableRow('전자공학과', '4'),
                      _tableRow('기계공학과', '3'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('※ 임시 데이터입니다. 실제 모집요강을 확인하세요.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _tableRow(String dept, String to) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(10), child: Text(dept, style: const TextStyle(fontSize: 13))),
        Padding(padding: const EdgeInsets.all(10), child: Text(to, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.university;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(u['name'] ?? '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
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
                      color: const Color(0xFFE8EEF7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF1A2B4A), size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(u['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if ((u['campus'] ?? '').isNotEmpty)
                    Text(
                      u['campus']!,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 전형 일정
            _sectionBox(
              title: '전형 일정',
              children: [
                _infoRow(Icons.assignment_outlined, '원서 접수 시작', u['admissionStart'] ?? ''),
                _divider(),
                _infoRow(Icons.assignment_outlined, '원서 접수 마감', u['deadline'] ?? ''),
                _divider(),
                _infoRow(Icons.edit_calendar_outlined, '시험일', u['examDate'] ?? ''),
                _divider(),
                _infoRow(Icons.campaign_outlined, '합격 발표', u['resultDate'] ?? ''),
              ],
            ),
            const SizedBox(height: 16),

            // 모집인원 확인 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _showToTable(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2B4A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('모집인원 확인하기', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
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
          Icon(icon, color: const Color(0xFF1A2B4A), size: 20),
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
        color: const Color(0xFFE8EEF7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF1A2B4A), fontWeight: FontWeight.w600)),
    );
  }
}