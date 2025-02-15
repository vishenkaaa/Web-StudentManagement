import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';
import '../models/subject_model.dart';

class ScheduleService {
  static const String baseUrl = 'http://localhost:5000/schedule';

  /// **Отримати розклад студента**
  static Future<List<Schedule>> getSchedule(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/student/$studentId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Schedule.fromJson(item)).toList();
    } else {
      throw Exception('Не вдалося завантажити розклад');
    }
  }

  /// **Додати заняття до розкладу**
  static Future<void> addSchedule({
    required String studentId,
    required int dayOfWeek,
    required int lessonNumber,
    required String subjectId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId,
        'dayOfWeek': dayOfWeek,
        'lessonNumber': lessonNumber,
        'subjectId': subjectId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Не вдалося додати заняття');
    }
  }

  /// **Оновити заняття**
  static Future<void> updateSchedule({
    required String scheduleId,
    required int dayOfWeek,
    required int lessonNumber,
    required String subjectId,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$scheduleId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dayOfWeek': dayOfWeek,
        'lessonNumber': lessonNumber,
        'subject': subjectId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося оновити заняття');
    }
  }

  /// **Видалити заняття з розкладу**
  static Future<void> deleteSchedule(String scheduleId, String studentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$scheduleId?studentId=$studentId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося видалити заняття');
    }
  }
}
