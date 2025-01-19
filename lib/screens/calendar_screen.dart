import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../domain/exam.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay = DateTime.utc(2020, 1, 1);
  final DateTime _lastDay = DateTime.utc(2025, 12, 31);

  final List<Exam> _exams = [
    Exam(name: 'Mathematics', latitude: 42.004120, longitude: 21.409543, dateTime: DateTime(2025, 1, 10, 9, 0)),
    Exam(name: 'Physics', latitude: 41.99646, longitude: 21.43141, dateTime: DateTime(2025, 1, 11, 14, 0)),
  ];

  bool _hasExamsOnDay(DateTime day) {
    return _exams.any((exam) => isSameDay(exam.dateTime, day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              firstDay: _firstDay,
              lastDay: _lastDay,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: _hasExamsOnDay(date) ? Colors.lightBlue.shade100 : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: _hasExamsOnDay(date) ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedDay == null
                  ? 'No day selected!'
                  : 'Selected day: ${_selectedDay.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Display the exams for the selected day
            Expanded(
              child: _selectedDay == null
                  ? const Center(
                child: Text(
                  'Please select a date.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : _exams.where((exam) => isSameDay(_selectedDay, exam.dateTime)).isEmpty
                  ? const Center(
                child: Text(
                  'There is no exam on the selected date.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView(
                children: _exams
                    .where((exam) => isSameDay(_selectedDay, exam.dateTime))
                    .map((exam) => ListTile(
                  title: Text(exam.name),
                  subtitle: Text(
                      'Time: ${exam.dateTime.hour}:${exam.dateTime.minute} h'),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/map',
                        arguments: {
                          'latitude': exam.latitude,
                          'longitude': exam.longitude,
                        },
                      );
                    },
                  ),
                ))
                    .toList(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
