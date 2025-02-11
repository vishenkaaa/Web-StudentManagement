import 'package:flutter/material.dart';
import 'package:student_management_app/styles/fonts.dart';
import '../styles/colors.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  TextEditingController _searchController = TextEditingController();
  List<String> students = List.generate(10, (index) => "$index клас - Учень $index - email$index@gmail.com");
  List<String> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  void _filterStudents(String query) {
    setState(() {
      filteredStudents = students
          .where((student) => student.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addStudent(String className, String name, String email) {
    setState(() {
      String newStudent = "$className клас - $name - $email";
      students.add(newStudent);
      _filterStudents(_searchController.text); // Оновити фільтрований список
    });
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

  void _showAddStudentDialog() {
    TextEditingController surnameController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController classController = TextEditingController();
    TextEditingController dateOfBirthController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Додати учня"),
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
                  controller: classController,
                  label: "Клас",
                  hint: "Введіть назву класу",
                  icon: Icons.class_sharp,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: dateOfBirthController,
                  label: "Дата народження",
                  hint: "01.01.1999",
                  icon: Icons.cake,
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: emailController,
                  label: "Email",
                  hint: "example@email.com",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                buildTextField(
                  controller: passwordController,
                  label: "Пароль",
                  hint: "Введіть пароль",
                  icon: Icons.password,
                  keyboardType: TextInputType.visiblePassword,
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
                if (classController.text.isNotEmpty && nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  _addStudent(classController.text, nameController.text, emailController.text);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterStudents,
                  style: AppTextStyles.h2.copyWith(color: Colors.black),

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    hintText: "Введіть клас",
                    hintStyle: AppTextStyles.h2.copyWith(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: AppColors.carribbeanCurrent),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text("Учні", style: AppTextStyles.h3),
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
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.person, color: AppColors.moonstone),
                      title: Text(filteredStudents[index]),
                      trailing: Icon(Icons.delete, color: Colors.red),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: _showAddStudentDialog,
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
