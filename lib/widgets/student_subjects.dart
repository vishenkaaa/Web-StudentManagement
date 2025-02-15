import 'package:flutter/material.dart';
import 'package:student_management_app/models/subject_model.dart';
import 'package:student_management_app/models/teacher_model.dart';
import 'package:student_management_app/services/subject_service.dart';
import 'package:student_management_app/services/teacher_service.dart';
import 'package:student_management_app/styles/colors.dart';

import '../styles/fonts.dart';

class StudentSubjects extends StatefulWidget {
  final String studentId;

  final VoidCallback onSubjectsUpdated;

  const StudentSubjects({Key? key, required this.studentId, required this.onSubjectsUpdated}) : super(key: key);

  @override
  _StudentSubjectsState createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {
  List<Subject> subjects = [];
  Map<String, Teacher> teachers = {};
  bool isLoading = true;
  String? error;

  void _onSubjectChanged() {
    widget.onSubjectsUpdated();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => isLoading = true);
      subjects = await SubjectService.getAllSubjects(widget.studentId);
      List<Teacher> teacherList = await TeacherService.getAllTeachers();

      teachers = {for (var teacher in teacherList) teacher.id: teacher};

      _onSubjectChanged();
      setState(() => isLoading = false);

    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _showAddSubjectDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController hoursController = TextEditingController();
    String? selectedTeacherId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Додати предмет", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.white,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(
                  controller: nameController,
                  label: "Назва предмета",
                  hint: "Введіть назву предмета",
                  icon: Icons.book,
                ),
                SizedBox(height: 12),
                buildDropdown(
                  label: "Вчитель",
                  value: selectedTeacherId,
                  items: teachers.entries.map((entry) {
                    final teacher = entry.value;
                    return DropdownMenuItem(
                      value: teacher.id,
                      child: Text("${teacher.surname} ${teacher.name} ${teacher.fatherName}"),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedTeacherId = value),
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: hoursController,
                  label: "Годин на тиждень",
                  hint: "Введіть кількість годин",
                  icon: Icons.access_time,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent, textStyle: AppTextStyles.h3),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedTeacherId != null &&
                    hoursController.text.isNotEmpty) {
                  await SubjectService.addSubject(
                    widget.studentId,
                    nameController.text,
                    selectedTeacherId!,
                    int.parse(hoursController.text),
                  );
                  _loadData();
                  Navigator.pop(context);
                }
              },
              child: Text("Додати"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moonstone,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.h3),
            ),
          ],
        );
      },
    );
  }

  void _showEditSubjectDialog(Subject subject) {
    TextEditingController nameController = TextEditingController(text: subject.name);
    TextEditingController hoursController = TextEditingController(text: subject.hoursPerWeek.toString());
    String selectedTeacherId = subject.teacherId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Редагувати предмет", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.white,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(
                  controller: nameController,
                  label: "Назва предмета",
                  hint: "Введіть назву предмета",
                  icon: Icons.book,
                ),
                SizedBox(height: 12),
                buildDropdown(
                  label: "Вчитель",
                  value: selectedTeacherId,
                  items: teachers.entries.map((entry) {
                    final teacher = entry.value;
                    return DropdownMenuItem(
                      value: teacher.id,
                      child: Text("${teacher.surname} ${teacher.name} ${teacher.fatherName}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedTeacherId = value);
                  },
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: hoursController,
                  label: "Годин на тиждень",
                  hint: "Введіть кількість годин",
                  icon: Icons.access_time,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent, textStyle: AppTextStyles.h3),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedTeacherId.isNotEmpty &&
                    hoursController.text.isNotEmpty) {
                  await SubjectService.updateSubject(
                    subject.id,
                    nameController.text,
                    selectedTeacherId,
                    int.parse(hoursController.text),
                  );
                  _loadData();
                  Navigator.pop(context);
                }
              },
              child: Text("Зберегти"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moonstone,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.h3),
            ),
          ],
        );
      },
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.h2.copyWith(color: Colors.grey[700]),
        hintStyle: AppTextStyles.h2.copyWith(color: Colors.grey[500]),
        prefixIcon: Icon(Icons.person, color: AppColors.carribbeanCurrent),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.carribbeanCurrent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.moonstone, width: 2),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.h2.copyWith(color: Colors.grey[700]),
        hintText: hint,
        hintStyle: AppTextStyles.h2.copyWith(color: Colors.grey[500]),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.carribbeanCurrent) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.carribbeanCurrent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.moonstone, width: 2),
        ),
      ),
    );
  }

  void _showDeleteStudentDialog(String subjectId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ви впевнені, що хочете видалити цей предмет?"),
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
              onPressed: () async {
                try {
                  await SubjectService.deleteSubject(subjectId, widget.studentId);
                  _loadData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Предмет успішно видалено'))
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Помилка видалення: ${e.toString()}'))
                  );
                }
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Предмети", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(size: 27, Icons.add, color: AppColors.moonstone),
                  onPressed: _showAddSubjectDialog,
                ),
              ],
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : error != null
                ? Center(child: Text(error!))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final teacher = teachers[subject.teacherId];

                return ListTile(
                  title: Text(subject.name),
                  subtitle: Text(
                    "Годин на тиждень: ${subject.hoursPerWeek}\n"
                        "Вчитель: ${teacher != null ? "${teacher.surname} ${teacher.name} ${teacher.fatherName}" : "Не знайдено"}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => _showEditSubjectDialog(subject),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteStudentDialog(subject.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
