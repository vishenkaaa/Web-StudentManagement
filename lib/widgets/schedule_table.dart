import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';


class ScheduleTable extends StatefulWidget {
  final String studentId;

  const ScheduleTable({Key? key, required this.studentId}) : super(key: key);

  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  List<Schedule> schedules = [];
  bool isEditing = false;
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
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    // TODO: Завантаження розкладу з API
    setState(() {
      // Тут буде оновлення schedules
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Розклад занять', style: AppTextStyles.h2),
                if (!isEditing)
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.moonstone),
                    onPressed: () => setState(() => isEditing = true),
                  )
                else
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          // TODO: Зберегти зміни через API
                          setState(() => isEditing = false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => isEditing = false),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppColors.lightBlue),
                columns: [
                  DataColumn(label: Text('Час')),
                  ...daysOfWeek.values.map((day) =>
                      DataColumn(label: Text(day))
                  ).toList(),
                ],
                rows: List.generate(8, (lessonNumber) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${lessonNumber + 1} урок')),
                      ...List.generate(6, (dayIndex) {
                        final schedule = schedules.firstWhere(
                              (s) => s.dayOfWeek == dayIndex + 1 && s.lessonNumber == lessonNumber + 1,
                          orElse: () => Schedule(
                            dayOfWeek: dayIndex + 1,
                            lessonNumber: lessonNumber + 1,
                            time: '',
                            subject: Subject(id: '', name: ''),
                          ),
                        );

                        return DataCell(
                          isEditing
                              ? _buildEditableCell(schedule)
                              : Text(schedule.subject.name),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableCell(Schedule schedule) {
    return DropdownButton<String>(
      value: schedule.subject.id.isEmpty ? null : schedule.subject.id,
      hint: Text('Оберіть предмет'),
      items: [
        // TODO: Додати список предметів з API
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          // TODO: Оновити розклад
        }
      },
    );
  }
}