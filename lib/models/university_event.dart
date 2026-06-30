import 'package:flutter/material.dart';

class UniversityEvent {
  final String name;
  final Color color;
  final DateTime admissionStart;  // 접수 시작일
  final DateTime admissionEnd;    // 접수 마감일
  final DateTime examDate;        // 시험일
  final DateTime resultDate;      // 발표일

  const UniversityEvent({
    required this.name,
    required this.color,
    required this.admissionStart,
    required this.admissionEnd,
    required this.examDate,
    required this.resultDate,
  });
}

// 임시 Mock 데이터
final List<UniversityEvent> mockEvents = [
  UniversityEvent(
    name: '서울대학교',
    color: Colors.blue,
    admissionStart: DateTime(2025, 1, 5),
    admissionEnd: DateTime(2025, 1, 10),
    examDate: DateTime(2025, 1, 20),
    resultDate: DateTime(2025, 2, 5),
  ),
  UniversityEvent(
    name: '연세대학교',
    color: Colors.green,
    admissionStart: DateTime(2025, 1, 8),
    admissionEnd: DateTime(2025, 1, 13),
    examDate: DateTime(2025, 1, 25),
    resultDate: DateTime(2025, 2, 10),
  ),
  UniversityEvent(
    name: '고려대학교',
    color: Colors.red,
    admissionStart: DateTime(2025, 1, 10),
    admissionEnd: DateTime(2025, 1, 15),
    examDate: DateTime(2025, 1, 28),
    resultDate: DateTime(2025, 2, 12),
  ),
  UniversityEvent(
    name: '한양대학교',
    color: Colors.orange,
    admissionStart: DateTime(2025, 1, 12),
    admissionEnd: DateTime(2025, 1, 18),
    examDate: DateTime(2025, 2, 1),
    resultDate: DateTime(2025, 2, 15),
  ),
];