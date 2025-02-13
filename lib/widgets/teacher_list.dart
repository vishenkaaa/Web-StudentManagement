import 'package:flutter/material.dart';
import 'package:student_management_app/models/teacher_model.dart';
import 'package:student_management_app/services/teacher_service.dart';
import 'package:student_management_app/styles/fonts.dart';
import '../styles/colors.dart';

class TeacherList extends StatefulWidget{
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList>{
  List<Teacher> teachers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await TeacherService.getAllTeachers();
      print("Teachers response: $response");

      setState(() {
        this.teachers = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading teachers: $e");
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addTeacher(String surname, String name, String fatherName) async {
    try {
      setState(() {
        error = null;
      });

      await TeacherService.addTeacher(surname, name, fatherName);

      _loadTeachers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Учителя успішно додано')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _editTeacher(String id, String surname, String name, String fatherName) async {
    try {
      setState(() {
        error = null;
        isLoading = true;
      });

      await TeacherService.updateTeacher(id, surname, name, fatherName);
      await _loadTeachers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Дані вчителя успішно оновлено')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка оновлення даних: ${e.toString()}')),
      );
    }
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

  void _showAddTeacherDialog() {
    TextEditingController surnameController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController fatherNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Додати вчителя"),
          backgroundColor: AppColors.white,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(
                  controller: surnameController,
                  label: "Прізвище",
                  hint: "Введіть прізвище",
                  icon: Icons.person,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: nameController,
                  label: "Ім'я",
                  hint: "Введіть ім'я",
                  icon: Icons.person,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: fatherNameController,
                  label: "По батькові",
                  hint: "Введіть по батькові",
                  icon: Icons.class_sharp,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  textStyle: AppTextStyles.h3
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (surnameController.text.isNotEmpty && nameController.text.isNotEmpty && fatherNameController.text.isNotEmpty) {
                  _addTeacher(surnameController.text, nameController.text, fatherNameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Додати"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moonstone,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.h3
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditTeacherDialog(int index) {
    TextEditingController surnameController = TextEditingController(text: teachers[index].surname);
    TextEditingController nameController = TextEditingController(text: teachers[index].name);
    TextEditingController fatherNameController = TextEditingController(text: teachers[index].fatherName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Редагувати вчителя"),
          backgroundColor: AppColors.white,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(
                  controller: surnameController,
                  label: "Прізвище",
                  hint: "Введіть прізвище",
                  icon: Icons.person,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: nameController,
                  label: "Ім'я",
                  hint: "Введіть ім'я",
                  icon: Icons.person,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: fatherNameController,
                  label: "По батькові",
                  hint: "Введіть по батькові",
                  icon: Icons.class_sharp,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Скасувати"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  textStyle: AppTextStyles.h3
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (surnameController.text.isNotEmpty && nameController.text.isNotEmpty && fatherNameController.text.isNotEmpty) {
                  _editTeacher(teachers[index].id, surnameController.text, nameController.text, fatherNameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Зберегти"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moonstone,
                  foregroundColor: Colors.white,
                  textStyle: AppTextStyles.h3
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteTeacherDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ви впевнені, що хочете видалити цього вчителя?"),
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
                  await TeacherService.deleteTeacher(teachers[index].id);
                  await _loadTeachers();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Вчителя успішно видалено')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Помилка видалення: ${e.toString()}')),
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
    // Додайте індикатор завантаження
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Вчителі", style: AppTextStyles.h3),
        SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white2,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Expanded(
                child: teachers.isEmpty
                ? Center(child: Text('Немає вчителів'))
                : ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.person, color: AppColors.moonstone),
                        title: Text("${teachers[index].surname} ${teachers[index].name} ${teachers[index].fatherName}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey),
                              onPressed: () => _showEditTeacherDialog(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteTeacherDialog(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: _showAddTeacherDialog,
                    borderRadius: BorderRadius.circular(15),
                    hoverColor: AppColors.carribbeanCurrent.withOpacity(0.3),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.carribbeanCurrent, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 35,
                          color: AppColors.carribbeanCurrent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}