import 'package:flutter/material.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPwController = TextEditingController();
  final _newPwConfirmController = TextEditingController();
  bool _codeSent = false;
  bool _codeVerified = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;


  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _newPwController.dispose();
    _newPwConfirmController.dispose();
    super.dispose();
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
        title: const Text('비밀번호 찾기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('가입 시 입력한 아이디와\n이메일을 입력해주세요.', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),

            // 아이디
            const Text('아이디', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: '아이디를 입력하세요',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // 이메일 + 인증번호 발송
            const Text('이메일', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _codeSent = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A2B4A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                  child: const Text('인증번호\n발송', style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
                ),
              ],
            ),

            // 인증번호 입력
            if (_codeSent) ...[
              const SizedBox(height: 20),
              const Text('인증번호', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '인증번호 6자리 입력',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => setState(() => _codeVerified = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2B4A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    ),
                    child: const Text('확인', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
            ],

            // 새 비밀번호 입력
            if (_codeVerified) ...[
              const SizedBox(height: 20),
              const Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _newPwController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  hintText: '새 비밀번호를 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('새 비밀번호 확인', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _newPwConfirmController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: '새 비밀번호를 다시 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 비밀번호 변경 API 연결
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('완료'),
                        content: const Text('비밀번호가 변경되었습니다.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B4A)),
                            child: const Text('로그인하기', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A2B4A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('비밀번호 변경', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}