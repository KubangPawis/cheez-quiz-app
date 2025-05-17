import 'package:cheez_quiz_app/pages/home_page.dart';
import 'package:cheez_quiz_app/pages/login_student.dart';
import 'package:cheez_quiz_app/pages/login_teacher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CheezQuizApp());
}

class CheezQuizApp extends StatelessWidget {
  const CheezQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cheez Quiz',
      debugShowCheckedModeBanner: false,
      home: TeacherLoginPage(),
    );
  }
}
