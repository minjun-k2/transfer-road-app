import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';
import 'university_detail_page.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, String>> favorites;
  final Function(Map<String, String>) onToggleFavorite;

  const SearchPage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = '전체';
  String _selectedExam = '전체';
  List<Map<String, String>> _universities = [];
  bool _loading = true;

  final List<String> _categories = ['전체', '인문', '자연', '예체능'];
  final List<String> _exams = ['전체', '수학', '영어', '수학+영어'];

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    try {
      final data = await ApiService.getUniversities();
      setState(() {
        _universities = data.map<Map<String, String>>((u) => {
          'id': u['id'].toString(),
          'name': u['name'] ?? '',
          'category': u['category'] ?? '',
          'exam': u['examType'] ?? '',
          'deadline': u['admissionEnd'] ?? '',
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print('대학 불러오기 실패: $e');
    }
  }

  List<Map<String, String>> get _filtered {
    return _universities.where((u) {
      final matchSearch = u['name']!.contains(_searchController.text);
      final matchCategory = _selectedCategory == '전체' || u['category'] == _selectedCategory;
      final matchExam = _selectedExam == '전체' || u['exam'] == _selectedExam;
      return matchSearch && matchCategory && matchExam;
    }).toList();
  }

  void _showFilterSheet() {
    String tempCategory = _selectedCategory;
    String tempExam = _selectedExam;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
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
                      const Text('필터', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('계열', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _categories.map((c) {
                      final isSelected = c == tempCategory;
                      return GestureDetector(
                        onTap: () => setModalState(() => tempCategory = c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2D6CDF) : const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('전형', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _exams.map((e) {
                      final isSelected = e == tempExam;
                      return GestureDetector(
                        onTap: () => setModalState(() => tempExam = e),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2D6CDF) : const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = tempCategory;
                          _selectedExam = tempExam;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D6CDF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('적용', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showUniversityBottomSheet(BuildContext context, Map<String, String> u, bool isFavorite) {
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
                Text(u['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('편입 유형을 선택하세요', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                if (selectedType == null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedType = '일반편입'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF3FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.school_outlined, color: Color(0xFF2D6CDF), size: 32),
                                SizedBox(height: 8),
                                Text('일반편입', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D6CDF))),
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
                  const SizedBox(height: 8),
                  const Text('계열을 선택하세요', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UniversityDetailPage(
                                  university: u,
                                  transferType: selectedType!,
                                  category: '인문',
                                  isFavorite: isFavorite,
                                  onToggleFavorite: widget.onToggleFavorite,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF3FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.history_edu_outlined, color: Color(0xFF2D6CDF), size: 32),
                                SizedBox(height: 8),
                                Text('인문계열', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D6CDF))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UniversityDetailPage(
                                  university: u,
                                  transferType: selectedType!,
                                  category: '자연',
                                  isFavorite: isFavorite,
                                  onToggleFavorite: widget.onToggleFavorite,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF3FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.science_outlined, color: Color(0xFF2D6CDF), size: 32),
                                SizedBox(height: 8),
                                Text('자연계열', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D6CDF))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('대학 검색', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '대학교 이름으로 검색',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: (_selectedCategory != '전체' || _selectedExam != '전체')
                          ? const Color(0xFF2D6CDF)
                          : const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: (_selectedCategory != '전체' || _selectedExam != '전체')
                          ? Colors.white
                          : Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedCategory != '전체' || _selectedExam != '전체')
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  if (_selectedCategory != '전체') _activeFilterTag(_selectedCategory, () => setState(() => _selectedCategory = '전체')),
                  if (_selectedExam != '전체') _activeFilterTag(_selectedExam, () => setState(() => _selectedExam = '전체')),
                ],
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                ? const Center(child: Text('검색 결과가 없어요', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final u = _filtered[index];
                final isFavorite = widget.favorites.any((f) => f['name'] == u['name']);
                return _universityCard(context, u, isFavorite);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeFilterTag(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF2D6CDF), fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Color(0xFF2D6CDF)),
          ),
        ],
      ),
    );
  }

  Widget _universityCard(BuildContext context, Map<String, String> u, bool isFavorite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showUniversityBottomSheet(context, u, isFavorite),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF3FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.school, color: Color(0xFF2D6CDF)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('접수: ${u['deadline']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onToggleFavorite(u),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_outline,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}