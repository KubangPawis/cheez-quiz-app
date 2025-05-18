import 'package:cheez_quiz_app/pages/creation.dart';
import 'package:cheez_quiz_app/pages/home_page.dart';
import 'package:cheez_quiz_app/pages/login_student.dart';
import 'package:cheez_quiz_app/pages/login_teacher.dart';
import 'package:cheez_quiz_app/pages/main_teacher.dart';
import 'package:cheez_quiz_app/pages/quiz_success_page.dart';
import 'package:cheez_quiz_app/pages/quiz_freeform_page.dart';
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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/login_teacher': (context) => const TeacherLoginPage(),
        '/login_student': (context) => const StudentLoginPage(),
        '/main_teacher': (context) => const TeacherMainPage(),
        '/creation': (context) => const TeacherQuestionPage(),
        '/quiz_success': (context) => const QuizSuccessPage(),
        '/quiz_freeform': (context) => const StudentFreeformQuestionPage(),
      }
    );
  }
}
