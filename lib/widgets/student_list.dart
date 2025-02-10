import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final students = List.generate(10, (index) => "10А клас - Учень $index - email$index@gmail.com");

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Учні", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(students[index]),
                  trailing: Icon(Icons.delete, color: Colors.red),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
