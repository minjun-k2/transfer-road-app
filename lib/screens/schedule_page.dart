import 'package:flutter/material.dart';
import '../models/university_event.dart';

class SchedulePage extends StatefulWidget {
  final List<Map<String, String>> favorites;

  const SchedulePage({super.key, this.favorites = const []});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedMonth = DateTime(2025, 1);
  DateTime? _selectedDay;

  List<UniversityEvent> get _activeEvents {
    if (widget.favorites.isEmpty) return mockEvents;
    return mockEvents.where((e) => widget.favorites.any((f) => f['name'] == e.name)).toList();
  }

  List<UniversityEvent> _eventsForDay(DateTime day) {
    return _activeEvents.where((e) {
      final isAdmission = !day.isBefore(e.admissionStart) && !day.isAfter(e.admissionEnd);
      final isExam = day.year == e.examDate.year && day.month == e.examDate.month && day.day == e.examDate.day;
      final isResult = day.year == e.resultDate.year && day.month == e.resultDate.month && day.day == e.resultDate.day;
      return isAdmission || isExam || isResult;
    }).toList();
  }

  String _eventType(UniversityEvent e, DateTime day) {
    if (day.year == e.examDate.year && day.month == e.examDate.month && day.day == e.examDate.day) return '시험';
    if (day.year == e.resultDate.year && day.month == e.resultDate.month && day.day == e.resultDate.day) return '발표';
    return '접수';
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('일정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 월 이동
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                      }),
                    ),
                    Text(
                      '${_focusedMonth.year}년 ${_focusedMonth.month}월',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 요일 헤더
                Row(
                  children: ['일', '월', '화', '수', '목', '금', '토'].map((d) {
                    return Expanded(
                      child: Center(
                        child: Text(d, style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: d == '일' ? Colors.red : d == '토' ? Colors.blue : Colors.grey,
                        )),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // 날짜 그리드
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: startWeekday + lastDay.day,
                  itemBuilder: (context, index) {
                    if (index < startWeekday) return const SizedBox();
                    final day = DateTime(_focusedMonth.year, _focusedMonth.month, index - startWeekday + 1);
                    final events = _eventsForDay(day);
                    final isSelected = _selectedDay != null &&
                        _selectedDay!.year == day.year &&
                        _selectedDay!.month == day.month &&
                        _selectedDay!.day == day.day;
                    final isToday = DateTime.now().year == day.year &&
                        DateTime.now().month == day.month &&
                        DateTime.now().day == day.day;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2D6CDF) : isToday ? const Color(0xFFEEF3FF) : null,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? Colors.white : day.weekday == 7 ? Colors.red : day.weekday == 6 ? Colors.blue : Colors.black,
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // 이렇게 바꿔
                          // 이렇게 바꿔
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: events.take(3).map((e) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: e.color,
                                shape: BoxShape.circle,
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 범례
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _activeEvents.map((e) => Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: e.color, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(e.name, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // 선택된 날짜 일정
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('날짜를 선택하면 일정이 표시됩니다', style: TextStyle(color: Colors.grey)))
                : _eventsForDay(_selectedDay!).isEmpty
                ? const Center(child: Text('선택한 날짜에 일정이 없어요', style: TextStyle(color: Colors.grey)))
                : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${_selectedDay!.month}월 ${_selectedDay!.day}일 일정',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._eventsForDay(_selectedDay!).map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: e.color.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: e.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: e.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _eventType(e, _selectedDay!),
                              style: TextStyle(fontSize: 12, color: e.color, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}