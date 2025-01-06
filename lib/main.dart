import 'package:flutter/material.dart';
import 'package:lab4/screens/calendar_screen.dart';
import 'package:lab4/screens/map_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Exam',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: "/",
      routes: {
        "/": (context) => const CalendarScreen(),
        "/map": (context) => const MapScreen(latitude: 41.99646, longitude: 21.43141,),
      },
    );
  }
}