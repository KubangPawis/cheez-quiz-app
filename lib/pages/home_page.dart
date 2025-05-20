import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_student.dart';
import 'login_teacher.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToRole(BuildContext context, String role) {
    if (role == 'student') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentLoginPage()),
      );
    } else if (role == 'teacher') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherLoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* TOP ICON */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CheezQuiz',
                  style: titleStyle(
                    textColor: const Color(primaryColor),
                    fontSize: 48,
                  ),
                ),
                Image.asset(
                  'assets/cheese-icon.png',
                  width: 120,
                  height: 60,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'WHAT ARE YOU?',
              style: titleStyle(
                textColor: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 60),

            /* CHOICES */
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 80,
              runSpacing: 30,
              children: [
                // STUDENT
                GestureDetector(
                  onTap: () => _navigateToRole(context, 'student'),
                  child: Container(
                    width: 500,
                    height: 600,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/student-onboarding.png',
                            width: 250,
                            height: 340,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Student',
                            style: subtitleStyle(
                              textColor: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // TEACHER
                GestureDetector(
                  onTap: () => _navigateToRole(context, 'teacher'),
                  child: Container(
                    width: 500,
                    height: 600,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/teacher-onboarding.png',
                            width: 250,
                            height: 340,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Teacher',
                            style: subtitleStyle(
                              textColor: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle titleStyle({required Color textColor, required double? fontSize}) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
  );
}

TextStyle subtitleStyle({required Color textColor, required double? fontSize}) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: textColor,
    ),
  );
}
