import 'package:cheez_quiz_app/pages/creation.dart';
import 'package:cheez_quiz_app/pages/home_page.dart';
import 'package:cheez_quiz_app/pages/login_student.dart';
import 'package:cheez_quiz_app/pages/login_teacher.dart';
import 'package:cheez_quiz_app/pages/main_student.dart';
import 'package:cheez_quiz_app/pages/main_teacher.dart';
import 'package:cheez_quiz_app/pages/quiz_multiple.dart';
import 'package:cheez_quiz_app/pages/result_bad_student.dart';
import 'package:cheez_quiz_app/pages/result_good_student.dart';
import 'package:cheez_quiz_app/pages/quiz_success_page.dart';
import 'package:cheez_quiz_app/pages/create_quiz_page.dart';
import 'package:cheez_quiz_app/pages/quiz_freeform_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CheezQuizApp());
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
        '/main_student': (context) => const StudentMainPage(),
        '/result_good_student': (context) => const StudentResultGoodPage(),
        '/result_bad_student': (context) => const StudentResultBadPage(),
        '/quiz_success': (context) => const QuizSuccessPage(),
        '/quiz_multiple': (context) => const QuizMultiplePage(),
        '/create_quiz': (context) => const CreateQuizPage(),
        '/quiz_freeform': (context) => const StudentFreeformQuestionPage(),
      },
    );
  }
}
