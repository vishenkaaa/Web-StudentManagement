import 'package:flutter/material.dart';
import '../widgets/settings_panel.dart';
import '../widgets/student_list.dart';
import '../widgets/teacher_list.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: Text("Student Management", style: AppTextStyles.h1.copyWith(color: AppColors.carribbeanCurrent)),
      ),
      backgroundColor: AppColors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsPanel(),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: StudentList()),
                  SizedBox(width: 16),
                  Expanded(child: TeacherList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
