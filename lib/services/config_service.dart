import 'dart:convert';
import 'package:http/http.dart' as http;

class ConfigService {
  static const String baseUrl = "http://localhost:5000";

  // Отримати налаштування
  static Future<Map<String, dynamic>> getSettings() async {
    final response = await http.get(Uri.parse('$baseUrl/config'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Помилка завантаження налаштувань');
    }
  }

  // Оновити налаштування
  static Future<void> updateSettings(Map<String, dynamic> settings) async {
    final response = await http.put(
      Uri.parse('$baseUrl/config'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(settings),
    );
    if (response.statusCode != 200) {
      throw Exception('Помилка оновлення налаштувань');
    }
  }
}
