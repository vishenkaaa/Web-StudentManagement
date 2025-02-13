import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/teacher_model.dart';

class TeacherService {
  static const String baseUrl = "http://localhost:5000";

  // Отримати список всіх вчителів
  static Future<List<Teacher>> getAllTeachers() async {
    final response = await http.get(Uri.parse('$baseUrl/teachers'));

    if (response.statusCode == 200) {
      final List<dynamic> teachersJson = jsonDecode(response.body);
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Помилка завантаження списку вчителів');
    }
  }

  // Додати нового вчителя
  static Future<Teacher> addTeacher(String surname, String name, String fatherName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/teachers/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'surname': surname,
        'name': name,
        'fatherName': fatherName,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Teacher.fromJson(responseData['teacher']);
    } else {
      throw Exception('Помилка додавання вчителя');
    }
  }

  // Оновити дані вчителя
  static Future<Teacher> updateTeacher(String id, String surname, String name, String fatherName) async {
    final response = await http.put(
      Uri.parse('$baseUrl/teachers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'surname': surname,
        'name': name,
        'fatherName': fatherName,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Teacher.fromJson(responseData['teacher']);
    } else {
      throw Exception('Помилка оновлення даних вчителя');
    }
  }

  // Видалити вчителя
  static Future<void> deleteTeacher(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/teachers/$id'));

    if (response.statusCode != 200) {
      throw Exception('Помилка видалення вчителя');
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
