import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class StudentService {
  static const String baseUrl = "http://localhost:5000";

  static Future<List<Student>> getAllStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      final List<dynamic> studentsJson = jsonDecode(response.body);
      return studentsJson.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Помилка завантаження списку учнів');
    }
  }

  static Future<Student> getStudentById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/students/$id'));

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Помилка отримання даних студента');
    }
  }

  static Future<Student> addStudent(String email, String password, String surname,
      String name, String className, DateTime dateOfBirth) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'surname': surname,
        'name': name,
        'studentClass': className,
        'dateOfBirth': dateOfBirth.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return await getStudentById(responseData['studentId']);
    } else {
      throw Exception('Помилка додавання учня');
    }
  }

  static Future<Student> updateStudent(String id, String email, String surname, String name,
      String className, DateTime dateOfBirth) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'surname': surname,
        'name': name,
        'studentClass': className,
        'dateOfBirth': dateOfBirth.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Student.fromJson(responseData['student']);
    } else {
      throw Exception('Помилка оновлення даних учня');
    }
  }

  static Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/students/$id'));

    if (response.statusCode != 200) {
      throw Exception('Помилка видалення учня');
    }
  }

  static String handleError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'Сталася невідома помилка';
  }
}