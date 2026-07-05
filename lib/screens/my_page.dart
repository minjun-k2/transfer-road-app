import 'package:flutter/material.dart';
import 'package:transfer_app/main.dart';
import 'package:transfer_app/services/user_session.dart';
import 'package:transfer_app/services/api_service.dart';
import 'change_password_page.dart';
import 'change_email_page.dart';


class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _darkMode = false;
  bool _notification = true;
  bool _passcode = false;
  String _first = '';
  String _second = '';
  String _third = '';

  List<String> _allUniversities = [];

  void _showChangePasswordDialog() {
    final currentPwController = TextEditingController();
    final newPwController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '현재 비밀번호',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPwController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '새 비밀번호',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiService.changePassword(
                  userId: UserSession.userId!,
                  currentPassword: currentPwController.text,
                  newPassword: newPwController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호 변경 실패. 현재 비밀번호를 확인해주세요.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6CDF)),
            child: const Text('변경', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이메일 변경'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: '새 이메일',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiService.changeEmail(
                  userId: UserSession.userId!,
                  newEmail: emailController.text,
                );
                setState(() {
                  UserSession.email = emailController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이메일이 변경되었습니다.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이메일 변경 실패. 이미 사용 중인 이메일일 수 있습니다.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6CDF)),
            child: const Text('변경', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUniversitySettings() {
    String tempFirst = _first;
    String tempSecond = _second;
    String tempThird = _third;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('관심 대학 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _universitySearchField('1지망', tempFirst, (v) => setModalState(() => tempFirst = v), _allUniversities, setModalState),
                    const SizedBox(height: 12),
                    _universitySearchField('2지망', tempSecond, (v) => setModalState(() => tempSecond = v), _allUniversities, setModalState),
                    const SizedBox(height: 12),
                    _universitySearchField('3지망', tempThird, (v) => setModalState(() => tempThird = v), _allUniversities, setModalState),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // 이렇게 바꿔
                        onPressed: () async {
                          setState(() {
                            _first = tempFirst;
                            _second = tempSecond;
                            _third = tempThird;
                          });
                          try {
                            await ApiService.saveInterest(
                              userId: UserSession.userId!,
                              firstName: tempFirst,
                              secondName: tempSecond,
                              thirdName: tempThird,
                            );
                          } catch (e) {
                            print('관심 대학 저장 실패: $e');
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6CDF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('완료', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _universitySearchField(
      String label,
      String value,
      Function(String) onSelect,
      List<String> universities,
      StateSetter setModalState,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: value),
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return universities;
            }
            return universities.where((u) => u.contains(textEditingValue.text));
          },
          onSelected: (selection) {
            setModalState(() => onSelect(selection));
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (v) => setModalState(() => onSelect(v)),
              decoration: InputDecoration(
                hintText: '대학교 이름 입력',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    controller.clear();
                    onSelect('');
                    focusNode.requestFocus();
                    setModalState(() {});
                  },
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 120,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(option, style: const TextStyle(fontSize: 14)),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 이렇게 바꿔
  @override
  void initState() {
    super.initState();
    _loadUniversities();
    _loadInterest();
  }

  Future<void> _loadInterest() async {
    try {
      final data = await ApiService.getInterest(UserSession.userId!);
      if (data != null) {
        setState(() {
          _first = data['firstName'] ?? '';
          _second = data['secondName'] ?? '';
          _third = data['thirdName'] ?? '';
        });
      }
    } catch (e) {
      print('관심 대학 불러오기 실패: $e');
    }
  }

  Future<void> _loadUniversities() async {
    try {
      final data = await ApiService.getUniversities();
      setState(() {
        _allUniversities = data.map<String>((u) => u['name'].toString()).toList();
      });
    } catch (e) {
      print('대학 목록 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('마이페이지', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 프로필
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF3FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF2D6CDF), size: 32),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(UserSession.name ?? '사용자', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(UserSession.email ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showUniversitySettings,
                    child: const Text('대학 설정', style: TextStyle(color: Color(0xFF2D6CDF), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 관심 대학 카드
            if (_first.isNotEmpty || _second.isNotEmpty || _third.isNotEmpty)
              _sectionBox(
                title: '관심 대학',
                children: [
                  if (_first.isNotEmpty) ...[
                    _interestTile('1지망', _first),
                  ],
                  if (_first.isNotEmpty && _second.isNotEmpty) _divider(),
                  if (_second.isNotEmpty) ...[
                    _interestTile('2지망', _second),
                  ],
                  if (_second.isNotEmpty && _third.isNotEmpty) _divider(),
                  if (_third.isNotEmpty) ...[
                    _interestTile('3지망', _third),
                  ],
                ],
              ),
            if (_first.isNotEmpty || _second.isNotEmpty || _third.isNotEmpty)
              const SizedBox(height: 16),

            // 앱 설정
            _sectionBox(
              title: '앱 설정',
              children: [
                _switchTile(Icons.dark_mode_outlined, '다크모드', _darkMode, (v) => setState(() => _darkMode = v)),
                _divider(),
                _switchTile(Icons.notifications_outlined, '알림 설정', _notification, (v) => setState(() => _notification = v)),
                _divider(),
                _switchTile(Icons.lock_outline, '암호 잠금', _passcode, (v) => setState(() => _passcode = v)),
              ],
            ),
            const SizedBox(height: 16),

            // 계정
            _sectionBox(
              title: '계정',
              children: [
                _arrowTile(Icons.lock_outline, '비밀번호 변경', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                }),
                _divider(),
                _arrowTile(Icons.email_outlined, '이메일 변경', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeEmailPage()));
                }),
              ],
            ),
            const SizedBox(height: 16),

            // 로그아웃
            _sectionBox(
              title: '',
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('로그아웃', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  // 이렇게 바꿔
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
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
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE));

  Widget _interestTile(String rank, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(rank, style: const TextStyle(color: Color(0xFF2D6CDF), fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _switchTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFF2D6CDF)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      value: value,
      activeColor: const Color(0xFF2D6CDF),
      onChanged: onChanged,
    );
  }

  // 이렇게 바꿔
  Widget _arrowTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2D6CDF)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}