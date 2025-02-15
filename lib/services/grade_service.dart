import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grade_model.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';

class GradeService {
  static const String baseUrl = 'http://localhost:5000/grades';

  //Отримати оцінки студента
  static Future<List<Grade>> getGrades(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/student/$studentId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Grade.fromJson(item)).toList();
    } else {
      throw Exception('Не вдалося завантажити оцінки');
    }
  }

  // Додати нову оцінку
  static Future<void> addGrade(Grade grade) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "studentId": grade.studentId,
          "subjectId": grade.subjectId,
          "grade": grade.grade,
          "date": grade.date.toLocal().toIso8601String(),
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception('Не вдалося додати оцінку');
      }
    } catch (e) {
      print("Помилка при додаванні оцінки: $e");
      rethrow;
    }
  }

  // Оновити оцінку
  static Future<void> updateGrade(String gradeId, int newGrade, DateTime newDate) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$gradeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'grade': newGrade, 'date': newDate.toIso8601String()}),
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося оновити оцінку');
    }
  }

  // Видалити оцінку
  static Future<void> deleteGrade(String gradeId, String studentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$gradeId?studentId=$studentId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося видалити оцінку');
    }
  }
}
