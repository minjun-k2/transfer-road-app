import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';
import 'package:transfer_app/services/user_session.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'schedule_page.dart';
import 'favorite_page.dart';
import 'my_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // 즐겨찾기 불러오기
  Future<void> _loadFavorites() async {
    if (UserSession.userId == null) return;
    try {
      final data = await ApiService.getFavorites(UserSession.userId!);
      setState(() {
        // 이렇게 바꿔
        _favorites = data.map<Map<String, String>>((f) {
          final u = f['university'];
          return {
            'name': u['name'] ?? '',
            'category': u['category'] ?? '',
            'exam': u['examType'] ?? '',
            'to': '',
            'deadline': u['admissionEnd'] ?? '',
            'admissionStart': u['admissionStart'] ?? '',
            'examDate': u['examDate'] ?? '',
            'resultDate': u['resultDate'] ?? '',
            'campus': u['campus'] ?? '',
          };
        }).toList();
      });
    } catch (e) {
      print('즐겨찾기 불러오기 실패: $e');
    }
  }

  // 즐겨찾기 토글
  void _toggleFavorite(Map<String, String> university) async {
    if (UserSession.userId == null) return;

    final exists = _favorites.any((u) => u['name'] == university['name']);

    try {
      // 대학 ID 찾기
      final universities = await ApiService.getUniversities();
      final found = universities.firstWhere(
            (u) => u['name'] == university['name'],
        orElse: () => null,
      );
      print('찾은 대학: $found');
      if (found == null) return;

      final universityId = found['id'];

      if (exists) {
        await ApiService.removeFavorite(UserSession.userId!, universityId);
        setState(() {
          _favorites.removeWhere((u) => u['name'] == university['name']);
        });
      } else {
        await ApiService.addFavorite(UserSession.userId!, universityId);
        setState(() {
          _favorites.add(university);
        });
      }
    } catch (e) {
      print('즐겨찾기 토글 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      SearchPage(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      SchedulePage(favorites: _favorites),
      FavoritePage(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      const MyPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A2B4A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search), label: '대학검색'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: '일정'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), activeIcon: Icon(Icons.star), label: '즐겨찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}