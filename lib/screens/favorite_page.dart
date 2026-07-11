import 'package:flutter/material.dart';
import 'university_detail_page.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, String>> favorites;
  final Function(Map<String, String>) onToggleFavorite;

  const FavoritePage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('즐겨찾기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('즐겨찾기한 대학이 없어요', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Text('대학 검색에서 ★ 눌러서 추가해보세요', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final u = favorites[index];
          final isFavorite = true;
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UniversityDetailPage(
                              university: u,
                              isFavorite: isFavorite,
                              onToggleFavorite: onToggleFavorite,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EEF7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.school, color: Color(0xFF1A2B4A)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u['name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('접수: ${u['deadline'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => onToggleFavorite(u),
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