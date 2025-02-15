import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_management_app/models/subject_model.dart';
import '../models/grade_model.dart';
import '../services/grade_service.dart';
import '../services/subject_service.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';

class StudentGrades extends StatefulWidget {
  final String studentId;

  const StudentGrades({Key? key, required this.studentId}) : super(key: key);

  @override
  StudentGradesState createState() => StudentGradesState();
}

class StudentGradesState extends State<StudentGrades> {
  List<Grade> grades = [];
  List<Subject> subjects = [];
  bool isLoading = true;
  DateTime currentWeekStart = DateTime.now();
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => isLoading = true);
      grades = await GradeService.getGrades(widget.studentId);
      subjects = await SubjectService.getAllSubjects(widget.studentId);
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void refreshGrades() {
    _loadData();
  }

  List<String> _getWeekDates() {
    DateTime start = currentWeekStart.subtract(Duration(days: currentWeekStart.weekday - 1));
    return List.generate(7, (index) {
      DateTime date = start.add(Duration(days: index));
      return DateFormat('yyyy-MM-dd').format(date);
    });
  }

  void _changeWeek(int direction) {
    setState(() {
      currentWeekStart = currentWeekStart.add(Duration(days: direction * 7));
    });
    _loadData();
  }

  Future<void> _editOrAddGrade(Grade? grade, String subjectId, String date) async {
    TextEditingController gradeController = TextEditingController(text: grade?.grade.toString() ?? '');
    bool isNew = grade == null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? "Додати оцінку" : "Редагувати оцінку", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        content: TextField(
          controller: gradeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Оцінка",
            labelStyle: AppTextStyles.h2.copyWith(color: Colors.grey[700]),
            hintText: "Введіть оцінку",
            hintStyle: AppTextStyles.h2.copyWith(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.grade, color: AppColors.carribbeanCurrent),
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
        ),
        actions: [
          if (!isNew)
            TextButton(
              onPressed: () async {
                await GradeService.deleteGrade(grade!.id, widget.studentId);
                Navigator.pop(context);
                _loadData();
              },
              child: Text("Видалити", style: AppTextStyles.h3.copyWith(color: Colors.red)),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Скасувати"),
            style: TextButton.styleFrom(
                foregroundColor: Colors.grey, textStyle: AppTextStyles.h3),
          ),
          ElevatedButton(
            onPressed: () async {
              if (gradeController.text.isNotEmpty) {
                if (isNew) {
                  DateTime localDate = DateTime.parse(date);
                  DateTime dateWithoutTime = DateTime(localDate.year, localDate.month, localDate.day, 12);

                  await GradeService.addGrade(
                    Grade(
                      id: '',
                      studentId: widget.studentId,
                      subjectId: subjectId,
                      grade: int.parse(gradeController.text),
                      date: dateWithoutTime,
                    ),
                  );
                }
                else {
                  await GradeService.updateGrade(grade!.id, int.parse(gradeController.text), grade.date);
                }
                Navigator.pop(context);
                _loadData();
              }
            },
            child: Text(isNew ? "Додати" : "Оновити"),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.moonstone,
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.h3),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> weekDates = _getWeekDates();
    String weekRange =
        "${DateFormat('dd.MM').format(DateTime.parse(weekDates.first))} - ${DateFormat('dd.MM').format(DateTime.parse(weekDates.last))}";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Оцінки', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.arrow_back), onPressed: () => _changeWeek(-1)),
                Text("Тиждень: $weekRange", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.arrow_forward), onPressed: () => _changeWeek(1)),
              ],
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30,
                columns: [
                  DataColumn(label: Text('Предмет', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                  for (var date in weekDates)
                    DataColumn(label: Text(DateFormat('dd.MM').format(DateTime.parse(date)))),
                ],
                rows: subjects.map((subject) {
                  return DataRow(cells: [
                    DataCell(Text(subject.name)),
                    for (var date in weekDates)
                      DataCell(
                        InkWell(
                          onTap: () {
                            DateTime selectedDate = DateTime.parse(date);
                            DateTime dateWithoutTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12);

                            Grade? grade = grades.firstWhere(
                                  (g) => DateFormat('yyyy-MM-dd').format(g.date) == DateFormat('yyyy-MM-dd').format(dateWithoutTime) &&
                                  g.subjectId == subject.id,
                              orElse: () => Grade(id: '', studentId: widget.studentId, subjectId: subject.id, grade: 0, date: dateWithoutTime),
                            );

                            _editOrAddGrade(grade.id.isEmpty ? null : grade, subject.id, dateWithoutTime.toIso8601String());
                          },
                          child: Text(
                            grades.any((g) =>
                            DateFormat('yyyy-MM-dd').format(g.date) == date && g.subjectId == subject.id)
                                ? grades.firstWhere((g) =>
                            DateFormat('yyyy-MM-dd').format(g.date) == date && g.subjectId == subject.id).grade.toString()
                                : "—",
                          ),
                        ),
                      )
                  ]);
                }).toList(),
              ),
            ),
          ],
        )
      )
    );
  }
}
