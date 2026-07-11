import 'package:flutter/material.dart';
import 'package:transfer_app/services/api_service.dart';

class SchedulePage extends StatefulWidget {
  final List<Map<String, String>> favorites;

  const SchedulePage({super.key, this.favorites = const []});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> _schedules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  @override
  void didUpdateWidget(SchedulePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favorites != widget.favorites) {
      _loadSchedules();
    }
  }

  Future<void> _loadSchedules() async {
    try {
      final List<Map<String, dynamic>> schedules = [];

      for (final fav in widget.favorites) {
        final name = fav['name'] ?? '';
        if (name.isEmpty) continue;

        final u = await ApiService.getUniversityByName(name);
        if (u == null) continue;

        if (u['admissionStart'] != null && u['admissionStart'].toString().isNotEmpty) {
          schedules.add({'university': name, 'type': '접수 시작', 'date': u['admissionStart'].toString()});
        }
        if (u['admissionEnd'] != null && u['admissionEnd'].toString().isNotEmpty) {
          schedules.add({'university': name, 'type': '접수 마감', 'date': u['admissionEnd'].toString()});
        }
        if (u['examDate'] != null && u['examDate'].toString().isNotEmpty) {
          schedules.add({'university': name, 'type': '시험일', 'date': u['examDate'].toString()});
        }
        if (u['resultDate'] != null && u['resultDate'].toString().isNotEmpty) {
          schedules.add({'university': name, 'type': '합격 발표', 'date': u['resultDate'].toString()});
        }
      }

      schedules.sort((a, b) => a['date'].compareTo(b['date']));

      setState(() {
        _schedules = schedules;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print('일정 불러오기 실패: $e');
    }
  }

  String _formatDate(String date) {
    if (date.length < 10) return date;
    final parts = date.substring(0, 10).split('-');
    return '${parts[1]}/${parts[2]}';
  }

  String _getMonth(String date) {
    if (date.length < 10) return '';
    final parts = date.substring(0, 10).split('-');
    return '${parts[0]}년 ${parts[1]}월';
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case '접수 시작': return Colors.blue;
      case '접수 마감': return Colors.red;
      case '시험일': return Colors.orange;
      case '합격 발표': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('일정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : widget.favorites.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('즐겨찾기한 대학이 없어요', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Text('대학 검색에서 ★ 눌러서 추가해보세요', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      )
          : _schedules.isEmpty
          ? const Center(
        child: Text('일정 정보가 없어요', style: TextStyle(color: Colors.grey)),
      )
          : Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _legendItem(Colors.blue, '접수 시작'),
                _legendItem(Colors.red, '접수 마감'),
                _legendItem(Colors.orange, '시험일'),
                _legendItem(Colors.green, '합격 발표'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                final showMonth = index == 0 ||
                    _getMonth(_schedules[index - 1]['date']) != _getMonth(schedule['date']);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showMonth)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Text(
                          _getMonth(schedule['date']),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _getTypeColor(schedule['type']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _formatDate(schedule['date']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getTypeColor(schedule['type']),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(schedule['university'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(schedule['type']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    schedule['type'],
                                    style: TextStyle(fontSize: 11, color: _getTypeColor(schedule['type']), fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}