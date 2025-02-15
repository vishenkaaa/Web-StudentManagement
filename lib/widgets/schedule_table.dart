import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';
import '../services/schedule_service.dart';
import '../services/subject_service.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';

class ScheduleTable extends StatefulWidget {
  final String studentId;

  const ScheduleTable({Key? key, required this.studentId}) : super(key: key);

  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  List<Schedule> schedules = [];
  List<Subject> subjects = [];
  bool isEditing = false;
  bool isLoading = true;
  String? error;

  final Map<int, String> daysOfWeek = {
    1: 'Понеділок',
    2: 'Вівторок',
    3: 'Середа',
    4: 'Четвер',
    5: "П'ятниця",
    6: 'Субота',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => isLoading = true);
      schedules = await ScheduleService.getSchedule(widget.studentId);
      subjects = await SubjectService.getAllSubjects(widget.studentId);
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void refreshSchedule() {
    _loadData(); // Викликаємо оновлення
  }

  Future<void> _updateSchedule(Schedule schedule, String? newSubjectId) async {
    try {
      if (newSubjectId == null) {
        await ScheduleService.deleteSchedule(schedule.id, widget.studentId);
      } else {
        if (schedule.id.isEmpty) {
          await ScheduleService.addSchedule(
            studentId: widget.studentId,
            dayOfWeek: schedule.dayOfWeek,
            lessonNumber: schedule.lessonNumber,
            subjectId: newSubjectId,
          );
        } else {
          await ScheduleService.updateSchedule(
            scheduleId: schedule.id,
            dayOfWeek: schedule.dayOfWeek,
            lessonNumber: schedule.lessonNumber,
            subjectId: newSubjectId,
          );
        }
      }
      await _loadData();
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildScheduleTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Розклад занять', style: AppTextStyles.h2),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit, color: isEditing ? Colors.green : Colors.grey),
          onPressed: () => setState(() => isEditing = !isEditing),
        ),
      ],
    );
  }

  Widget _buildScheduleTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(AppColors.lightBlue),
        columns: [
          DataColumn(label: Text('Час')),
          ...daysOfWeek.values.map((day) => DataColumn(label: Text(day))),
        ],
        rows: List.generate(8, (lessonNumber) {
          return DataRow(
            cells: [
              DataCell(Text('${lessonNumber + 1} урок')),
              ...List.generate(6, (dayIndex) {
                final schedule = schedules.firstWhere(
                      (s) => s.dayOfWeek == dayIndex + 1 && s.lessonNumber == lessonNumber + 1,
                  orElse: () => Schedule(id: '', dayOfWeek: dayIndex + 1, lessonNumber: lessonNumber + 1, subject: Subject(id: '', name: '—', teacherId: "", hoursPerWeek: 0)),
                );

                return DataCell(
                  isEditing ? _buildEditableCell(schedule) : Text(schedule.subject.name),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEditableCell(Schedule schedule) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            value: schedule.subject.id.isEmpty ? null : schedule.subject.id,
            hint: Text('Оберіть предмет'),
            items: subjects.map((subject) {
              return DropdownMenuItem(value: subject.id, child: Text(subject.name));
            }).toList(),
            onChanged: (String? newValue) => _updateSchedule(schedule, newValue),
          ),
        ),
        if (schedule.subject.id.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: () => _updateSchedule(schedule, null),
          ),
      ],
    );
  }
}
