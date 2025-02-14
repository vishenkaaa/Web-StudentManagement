import 'package:flutter/material.dart';
import 'package:student_management_app/styles/fonts.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import '../styles/colors.dart';
import 'package:intl/intl.dart';

class StudentInfo extends StatefulWidget {
  final String studentId;
  const StudentInfo({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  bool isEditing = false;
  bool isLoading = true;
  String? error;
  Student? student;
  Student? tempStudent;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await StudentService.getStudentById(widget.studentId);
      print("Student response: $response");

      setState(() {
        student = response;
        tempStudent = student?.copyWith();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading student: $e");
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _showDeleteStudentDialog() {
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
              onPressed: () async {
                try {
                  await StudentService.deleteStudent(widget.studentId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Учня успішно видалено'))
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

  Widget _buildInfoRow(String label, String? value, Function(String) onChanged) {
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
            child: isEditing
                ? TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
            )
                : Text(
              value ?? "Немає даних",
              style: AppTextStyles.h3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime? value, Function(DateTime) onChanged) {
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
            child: isEditing
                ? InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.carribbeanCurrent,
                          onPrimary: Colors.white,
                          surface: AppColors.lightBlue,
                        ),
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: AppColors.white,
                          hourMinuteTextColor: AppColors.carribbeanCurrent,
                          dialHandColor: AppColors.carribbeanCurrent,
                          dialBackgroundColor: AppColors.lightBlue,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    tempStudent = tempStudent?.copyWith(dateOfBirth: pickedDate);
                  });
                  onChanged(pickedDate);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  value != null ? formatDate(value) : "Оберіть дату",
                  style: AppTextStyles.h3,
                ),
              ),
            )
                : Text(
              value != null ? formatDate(value) : "Немає даних",
              style: AppTextStyles.h3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveStudent() async {
    try {
      setState(() {
        error = null;
      });

      await StudentService.updateStudent(
        tempStudent!.id, tempStudent!.surname, tempStudent!.name, tempStudent!.className, tempStudent!.dateOfBirth
      );

      setState(() {
        student = tempStudent;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Інформацію про учня успішно оновлено')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка при оновленні інформації про учня'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text("Помилка: $error"));
    }

    if (student == null) {
      return Center(child: Text("Учня не знайдено"));
    }

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
                  if (!isEditing)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(size: 18, Icons.edit, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              isEditing = true;
                              tempStudent = student?.copyWith();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: _showDeleteStudentDialog,
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: _saveStudent,
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildInfoRow("Прізвище:", tempStudent?.surname ?? "", (val) {
          setState(() => tempStudent = tempStudent?.copyWith(surname: val));
        }),
        _buildInfoRow("Ім'я:", tempStudent?.name ?? "", (val) {
          setState(() => tempStudent = tempStudent?.copyWith(name: val));
        }),
        _buildDateRow("Дата народження:", tempStudent?.dateOfBirth, (val) {
          setState(() => tempStudent = tempStudent?.copyWith(dateOfBirth: val));
        }),
        _buildInfoRow("Email:", tempStudent?.email ?? "", (val) {
          setState(() => tempStudent = tempStudent?.copyWith(email: val));
        }),
        _buildInfoRow("Клас:", tempStudent?.className ?? "", (val) {
          setState(() => tempStudent = tempStudent?.copyWith(className: val));
        }),
      ],
    );
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }
}
