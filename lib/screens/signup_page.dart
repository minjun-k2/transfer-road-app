import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePw = true;
  bool _obscurePwConfirm = true;
  bool _agreeAll = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;

  void _onAgreeAll(bool? value) {
    setState(() {
      _agreeAll = value ?? false;
      _agreeTerms = _agreeAll;
      _agreePrivacy = _agreeAll;
    });
  }

  void _updateAgreeAll() {
    setState(() {
      _agreeAll = _agreeTerms && _agreePrivacy;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwConfirmController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        title: const Text('회원가입', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 이름
              const Text('이름', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              // 이메일
              const Text('이메일', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'example@email.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              // 전화번호
              // 이렇게 바꿔
              const Text('전화번호', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '010-0000-0000',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2B4A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    child: const Text('인증번호 발송', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('인증번호', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '인증번호 6자리 입력',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 28),

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

              // 비밀번호
              const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _pwController,
                obscureText: _obscurePw,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePw = !_obscurePw),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 확인
              const Text('비밀번호 확인', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _pwConfirmController,
                obscureText: _obscurePwConfirm,
                decoration: InputDecoration(
                  hintText: '비밀번호를 다시 입력하세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePwConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePwConfirm = !_obscurePwConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 20),


              // 약관 동의
              const Text('약관 동의', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _agreeAll,
                      onChanged: _onAgreeAll,
                      title: const Text('전체 동의', style: TextStyle(fontWeight: FontWeight.bold)),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),
                    CheckboxListTile(
                      value: _agreeTerms,
                      onChanged: (v) {
                        setState(() => _agreeTerms = v ?? false);
                        _updateAgreeAll();
                      },
                      title: const Text('이용약관 동의 (필수)'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: _agreePrivacy,
                      onChanged: (v) {
                        setState(() => _agreePrivacy = v ?? false);
                        _updateAgreeAll();
                      },
                      title: const Text('개인정보 처리방침 동의 (필수)'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 회원가입 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // 이렇게 바꿔
                  onPressed: () async {
                    try {
                      await ApiService.signup(
                        username: _idController.text,
                        password: _pwController.text,
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('회원가입 성공!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('회원가입 실패. 다시 시도해주세요.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A2B4A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('회원가입', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}