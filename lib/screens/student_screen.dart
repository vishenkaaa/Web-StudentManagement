import 'package:flutter/material.dart';
import 'package:student_management_app/widgets/student_info.dart';
import 'package:student_management_app/widgets/student_subjects.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';
import '../widgets/schedule_table.dart';

class StudentScreen extends StatelessWidget {
  final String studentId;
  final GlobalKey<ScheduleTableState> _scheduleKey = GlobalKey();
  StudentScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: Text("Інформація про учня",
            style: AppTextStyles.h1.copyWith(color: AppColors.carribbeanCurrent)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.carribbeanCurrent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white2,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentInfo(studentId: studentId),
                SizedBox(height: 16),
                StudentSubjects(
                  studentId: studentId,
                  onSubjectsUpdated: () {
                    _scheduleKey.currentState?.refreshSchedule();
                  },
                ),
                SizedBox(height: 16),
                ScheduleTable(key: _scheduleKey, studentId: studentId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}