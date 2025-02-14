import 'package:flutter/material.dart';
import 'package:student_management_app/services/student_service.dart';
import 'package:student_management_app/styles/fonts.dart';
import '../models/student_model.dart';
import '../screens/student_screen.dart';
import '../styles/colors.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  TextEditingController _searchController = TextEditingController();
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await StudentService.getAllStudents();
      print("Student response: $response");

      setState(() {
        students = response;
        filteredStudents = response;
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

  void _filterStudents(String query) {
    setState(() {
      filteredStudents = students.where((student) =>
      student.surname.toLowerCase().contains(query.toLowerCase()) ||
          student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.className.toLowerCase().contains(query.toLowerCase()) ||
          student.email.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  Future<void> _addStudent(String email, String password, String surname,
      String name, String className, DateTime dateOfBirth) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      await StudentService.addStudent(
          email,
          password,
          surname,
          name,
          className,
          dateOfBirth
      );

      await _loadStudents();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Учня успішно додано')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка додавання учня: ${e.toString()}')),
      );
    }
  }

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
              onPressed: () async {
                try {
                  final student = filteredStudents[index];
                  print("Видаляю студента з ID: ${student.id}");
                  await StudentService.deleteStudent(student.id);
                  await _loadStudents();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Учня успішно видалено')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Помилка видалення: ${e.toString()}')),
                  );
                  print("Помилка видалення: $e");
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
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
      readOnly: readOnly,
      onTap: onTap,
    );
  }

  void _showAddStudentDialog() {
    TextEditingController surnameController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController classController = TextEditingController();
    TextEditingController dateOfBirthController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Додати учня"),
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
                  readOnly: true,
                  onTap: () async {
                    final date = await _showDatePicker(dateOfBirthController);
                    if (date != null) {
                      selectedDate = date;
                      dateOfBirthController.text = "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
                    }
                  },
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
                if (classController.text.isEmpty ||
                    nameController.text.isEmpty ||
                    surnameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Будь ласка, заповніть всі поля"))
                  );
                  return;
                }

                if (!_isValidEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Невірний формат email"))
                  );
                  return;
                }
                _addStudent(emailController.text, passwordController.text, classController.text, nameController.text, classController.text, selectedDate!);
                Navigator.pop(context);
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

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    );
    return emailRegex.hasMatch(email);
  }

  Future<DateTime?> _showDatePicker(TextEditingController controller) async {
    final DateTime initialDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.carribbeanCurrent,
              onPrimary: Colors.white,
              surface: AppColors.white,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      controller.text = formattedDate;
    }

    return picked;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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
                    hintText: "Введіть слово для пошуку учнів",
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
              child: students.isEmpty
              ? Center(child: Text('Немає учнів'))
              : ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.person, color: AppColors.moonstone),
                      title: Text("${students[index].surname} ${students[index].name} - ${students[index].className} - ${students[index].email}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteStudentDialog(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentScreen(
                              studentId: filteredStudents[index].id,
                            ),
                          ),
                        );
                      },
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
