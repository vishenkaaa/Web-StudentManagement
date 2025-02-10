class Teacher {
  final String surname;
  final String name;
  final String fatherName;

  Teacher({required this.surname, required this.name, required this.fatherName});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      surname: json['surname'],
      name: json['name'],
      fatherName: json['fatherName'],
    );
  }
}
