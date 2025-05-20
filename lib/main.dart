import 'package:cheez_quiz_app/pages/creation.dart';
import 'package:cheez_quiz_app/pages/home_page.dart';
import 'package:cheez_quiz_app/pages/login_student.dart';
import 'package:cheez_quiz_app/pages/login_teacher.dart';
import 'package:cheez_quiz_app/pages/main_student.dart';
import 'package:cheez_quiz_app/pages/main_teacher.dart';
import 'package:cheez_quiz_app/pages/quiz_multiple.dart';
import 'package:cheez_quiz_app/pages/quiz_view_page.dart';
import 'package:cheez_quiz_app/pages/result_bad_student.dart';
import 'package:cheez_quiz_app/pages/result_good_student.dart';
import 'package:cheez_quiz_app/pages/quiz_success_page.dart';
import 'package:cheez_quiz_app/pages/create_quiz_page.dart';
import 'package:cheez_quiz_app/pages/sign_up_student.dart';
import 'package:cheez_quiz_app/pages/sign_up_teacher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/sign_up_student': (context) => const StudentSignUpPage(),
        '/sign_up_teacher': (context) => const TeacherSignUpPage(),
        '/main_teacher': (context) => const TeacherMainPage(),
        '/main_student': (context) => const StudentMainPage(),
        '/quiz_success': (context) => const QuizSuccessPage(),
        '/create_quiz': (context) => const CreateQuizPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/quiz_view') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => QuizViewPage(
                  quizId: args['quizId'],
                  quizTitle: args['quizTitle'],
                ),
          );
        } else if (settings.name == '/quiz_creation') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => TeacherQuestionPage(
                  quizId: args['quizId'],
                  quizTitle: args['quizTitle'],
                ),
          );
        } else if (settings.name == '/quiz_result_success') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) =>
                    StudentResultGoodPage(quizScore: args['quizScore']),
          );
        } else if (settings.name == '/quiz_result_fail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => StudentResultBadPage(quizScore: args['quizScore']),
          );
        } else if (settings.name == '/quiz_multiple') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => QuizPage(
                  quizId: args['quizId'],
                  quizTitle: args['quizTitle'],
                  questions: args['questions'],
                ),
          );
        }
        return null;
      },
    );
  }
}
