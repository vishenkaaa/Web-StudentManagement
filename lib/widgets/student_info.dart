import 'package:flutter/material.dart';
import 'package:student_management_app/styles/fonts.dart';
import '../styles/colors.dart';

class StudentInfo extends StatefulWidget {
  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo>{
  bool isEditing = false;
  Map<String, String> student = {
    "Прізвище": "08:00",
    "Ім'я": "3",
    "Дата народження": "30",
    "Клас": "10",
    "Email": "",
  };
  Map<String, String> tempStudent = {};

  void _showDeleteStudentDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ви впевнені, що хочете видалити цього учня?"),
          backgroundColor: AppColors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.lightBlueAccent,
                  textStyle: AppTextStyles.h3
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //код для  видалення
                Navigator.pop(context);
              },
              child: Text("Видалити"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.h3
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.h3.copyWith(color: Colors.grey[700]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.h3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: AppColors.moonstone,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.moonstone),
                    onPressed: () {
                      // Додайте логіку редагування тут
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      //_showDeleteStudentDialog(index)
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildInfoRow("Прізвище:", "Нагалка"),
        _buildInfoRow("Ім'я:", "Анна"),
        _buildInfoRow("Дата народження:", "01.01.2007"),
        _buildInfoRow("Email:", "student@example.com"),
        _buildInfoRow("Клас:", "ПІ-211"),
      ],
    );
  }
}