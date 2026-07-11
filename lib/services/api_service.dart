import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // 대학 목록 조회
  static Future<List<dynamic>> getUniversities() async {
    final response = await http.get(Uri.parse('$baseUrl/universities'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('대학 목록 조회 실패');
  }

  // 회원가입
  static Future<String> signup({
    required String username,
    required String password,
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('회원가입 실패');
  }

  // 로그인
  // 이렇게 바꿔
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('로그인 실패');
  }

  // 즐겨찾기 추가
  static Future<String> addFavorite(int userId, int universityId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/$userId/$universityId'),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('즐겨찾기 추가 실패');
  }

  // 즐겨찾기 삭제
  static Future<String> removeFavorite(int userId, int universityId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/$userId/$universityId'),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('즐겨찾기 삭제 실패');
  }

  // 즐겨찾기 목록 조회
  static Future<List<dynamic>> getFavorites(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('즐겨찾기 조회 실패');
  }

  // 게시글 목록 조회
  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('게시글 조회 실패');
  }

  // 게시글 작성
  // 이렇게 바꿔
  static Future<dynamic> createPost({
    required int userId,
    required String category,
    required String title,
    required String content,
    required bool isAnonymous,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'category': category,
        'title': title,
        'content': content,
        'anonymous': isAnonymous,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('게시글 작성 실패');
  }
  // 좋아요
  static Future<dynamic> toggleLike(int postId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/like/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('좋아요 실패');
  }

  // 댓글 작성
  static Future<dynamic> createComment({
    required int postId,
    required int userId,
    required String content,
    required bool isAnonymous,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': postId,
        'userId': userId,
        'content': content,
        'anonymous': isAnonymous,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('댓글 작성 실패');
  }

// 댓글 목록 조회
  static Future<List<dynamic>> getComments(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/comments/post/$postId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('댓글 조회 실패');
  }
  // 좋아요 여부 확인
  static Future<bool> isLiked(int postId, int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/like/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return false;
  }
  // 비밀번호 변경
  static Future<String> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('비밀번호 변경 실패');
  }

// 이메일 변경
  static Future<String> changeEmail({
    required int userId,
    required String newEmail,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/change-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'newEmail': newEmail,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('이메일 변경 실패');
  }
  // 관심 대학 저장
  static Future<dynamic> saveInterest({
    required int userId,
    required String firstName,
    required String secondName,
    required String thirdName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interests'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'firstName': firstName,
        'secondName': secondName,
        'thirdName': thirdName,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('관심 대학 저장 실패');
  }

// 관심 대학 조회
  static Future<dynamic> getInterest(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/interests/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
  // 대학 이름으로 검색
  static Future<dynamic> getUniversityByName(String name) async {
    final data = await getUniversities();
    return data.firstWhere(
          (u) => u['name'] == name,
      orElse: () => null,
    );
  }
  // 게시글 삭제
  static Future<void> deletePost(int postId) async {
    await http.delete(Uri.parse('$baseUrl/posts/$postId'));
  }

// 댓글 삭제
  static Future<void> deleteComment(int commentId) async {
    await http.delete(Uri.parse('$baseUrl/comments/$commentId'));
  }
  // 공고 목록 조회
  static Future<List<dynamic>> getAnnouncements() async {
    final response = await http.get(Uri.parse('$baseUrl/announcements'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('공고 조회 실패');
  }
}
