class Student {
  final String email;
  final String password;
  final String surname;
  final String name;
  final String className;
  final DateTime dateOfBirth;

  Student({required this.email, required this.password, required this.surname, required this.name,
    required this.className, required this.dateOfBirth});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      email: json['email'],
      password: json['password'],
      surname: json['name'],
      name: json['name'],
      className: json['className'],
      dateOfBirth: json['dateOfBirth'],
    );
  }
}
