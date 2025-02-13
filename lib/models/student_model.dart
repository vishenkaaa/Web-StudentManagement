class Student {
  final String id;
  final String email;
  final String password;
  final String surname;
  final String name;
  final String className;
  final DateTime dateOfBirth;

  Student({required this.id, required this.email, required this.password, required this.surname, required this.name,
    required this.className, required this.dateOfBirth});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      surname: json['surname'],
      name: json['name'],
      className: json['class'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
    );
  }
}
