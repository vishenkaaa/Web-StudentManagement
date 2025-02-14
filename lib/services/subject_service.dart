import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_management_app/models/subject_model.dart';

class SubjectService {
  static const String baseUrl = "http://localhost:5000";

  // Отримати список всіх предметів
  static Future<List<Subject>> getAllSubjects(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/subjects/student/$studentId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> subjectJson = jsonDecode(response.body);
      return subjectJson.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Помилка завантаження списку предметів');
    }
  }

  // Додати новий предмет
  static Future<Subject> addSubject(String studentId, String name, String teacherId, int hoursPerWeek) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subjects/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId,
        'name': name,
        'teacherId': teacherId,
        'hoursPerWeek': hoursPerWeek,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Subject.fromJson(responseData['subject']);
    } else {
      throw Exception('Помилка додавання предмета');
    }
  }

  // Оновити дані предмета
  static Future<Subject> updateSubject(String id, String name, String teacherId, int hoursPerWeek) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subjects/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'teacherId': teacherId,
        'hoursPerWeek': hoursPerWeek,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Subject.fromJson(responseData['subject']);
    } else {
      throw Exception('Помилка оновлення даних предмета');
    }
  }

  // Видалити предмет
  static Future<void> deleteSubject(String id, String studentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/subjects/$id?studentId=$studentId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Помилка видалення предмета');
    }
  }

  // Обробка помилок
  static String handleError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'Сталася невідома помилка';
  }
}
