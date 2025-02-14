class Subject {
  final String id;
  final String name;
  final String teacherId;
  final int hoursPerWeek;

  Subject({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.hoursPerWeek,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'] as String,
      name: json['name'] as String,
      teacherId: json['teacher'] as String,
      hoursPerWeek: json['hoursPerWeek'] as int,
    );
  }
}
