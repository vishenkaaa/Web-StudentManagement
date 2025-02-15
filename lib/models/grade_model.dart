class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final int grade;
  final DateTime date;

  Grade({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.grade,
    required this.date,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['_id'],
      studentId: json['student'],
      subjectId: json['subject'],
      grade: json['grade'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': studentId,
      'subject': subjectId,
      'grade': grade,
      'date': date.toIso8601String(),
    };
  }
}