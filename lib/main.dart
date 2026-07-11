import 'package:flutter/material.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart';
import 'screens/find_id_page.dart';
import 'screens/find_password_page.dart';
import 'package:transfer_app/services/api_service.dart';
import 'package:transfer_app/services/user_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '편입 정보',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A2B4A)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 로고
              const Icon(Icons.school, size: 64, color: Color(0xFF1A2B4A)),
              const SizedBox(height: 12),
              const Text(
                '편입로드',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A2B4A)),
              ),
              const SizedBox(height: 8),
              const Text('편입 정보의 모든 것', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 40),

              // 아이디 입력
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력
              TextField(
                controller: _pwController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),

              // 아이디/비밀번호 찾기
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindIdPage()));
                    },
                    child: const Text('아이디 찾기', style: TextStyle(fontSize: 12)),
                  ),                  const Text('|', style: TextStyle(color: Colors.grey)),

                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindPasswordPage()));
                    },
                    child: const Text('비밀번호 찾기', style: TextStyle(fontSize: 12)),
                  ),                ],
              ),
              const SizedBox(height: 8),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: // onPressed 이렇게 바꿔
                ElevatedButton(
                  // 이렇게 바꿔
                  onPressed: () async {
                    try {
                      final result = await ApiService.login(
                        username: _idController.text,
                        password: _pwController.text,
                      );
                      UserSession.login(
                        result['userId'],
                        result['username'],
                        userName: result['name'],
                        userEmail: result['email'],
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('아이디 또는 비밀번호가 틀렸습니다.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A2B4A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('로그인', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),

              // 회원가입
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 계정이 없으신가요?', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text('회원가입'),
                  ),                ],
              ),

              const SizedBox(height: 10),

              // 구분선
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('또는', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // 카카오 로그인
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('K', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('카카오로 로그인', style: TextStyle(color: Colors.black87, fontSize: 15)),
                    ],
                  ),                ),
              ),
              const SizedBox(height: 12),

              // 네이버 로그인
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03C75A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('N', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('네이버로 로그인', style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),                ),
              ),
              const SizedBox(height: 12),

              // 구글 로그인
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('Google로 로그인', style: TextStyle(color: Colors.black87, fontSize: 15)),
                    ],
                  ),                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}