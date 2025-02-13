import 'package:student_management_app/models/subject_model.dart';

class Schedule {
  final int dayOfWeek;
  final int lessonNumber;
  final String time;
  final Subject subject;

  Schedule({
    required this.dayOfWeek,
    required this.lessonNumber,
    required this.time,
    required this.subject,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      dayOfWeek: json['dayOfWeek'],
      lessonNumber: json['lessonNumber'],
      time: json['time'],
      subject: Subject.fromJson(json['subject']),
    );
  }
}