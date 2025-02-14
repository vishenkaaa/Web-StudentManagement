import 'package:student_management_app/models/subject_model.dart';

class Schedule {
  //final String id;
  final int dayOfWeek;
  final int lessonNumber;
  final String time;
  final Subject subject;

  Schedule({
    //required this.id,
    required this.dayOfWeek,
    required this.lessonNumber,
    required this.time,
    required this.subject,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      //id: json['_id'],
      dayOfWeek: json['dayOfWeek'],
      lessonNumber: json['lessonNumber'],
      time: json['time'],
      subject: Subject.fromJson(json['subject']),
    );
  }
}