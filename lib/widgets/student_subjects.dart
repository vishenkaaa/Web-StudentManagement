import 'package:flutter/material.dart';
import 'package:student_management_app/models/subject_model.dart';
import 'package:student_management_app/models/teacher_model.dart';
import 'package:student_management_app/services/subject_service.dart';
import 'package:student_management_app/services/teacher_service.dart';
import 'package:student_management_app/styles/colors.dart';

class StudentSubjects extends StatefulWidget {
  final String studentId;

  const StudentSubjects({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentSubjectsState createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {
  List<Subject> subjects = [];
  Map<String, Teacher> teachers = {};
  bool isLoading = true;
  String? error;

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

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _showEditSubjectDialog(Subject subject) {
    TextEditingController nameController = TextEditingController(text: subject.name);
    TextEditingController hoursController = TextEditingController(text: subject.hoursPerWeek.toString());
    String selectedTeacherId = subject.teacherId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Редагувати предмет"),
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Назва предмета"),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Вчитель"),
                value: selectedTeacherId,
                items: teachers.entries.map((entry) {
                  final teacher = entry.value;
                  return DropdownMenuItem(
                    value: teacher.id,
                    child: Text("${teacher.surname} ${teacher.name} ${teacher.fatherName}"),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedTeacherId = value;
                },
              ),
              TextField(
                controller: hoursController,
                decoration: InputDecoration(labelText: "Годин на тиждень"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
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
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSubject(String subjectId) async {
    await SubjectService.deleteSubject(subjectId, widget.studentId);
    _loadData();
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
                Text("Предмети", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditSubjectDialog(subject),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSubject(subject.id),
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
