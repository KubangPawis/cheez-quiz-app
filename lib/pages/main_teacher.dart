import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class TeacherMainPage extends StatelessWidget {
  const TeacherMainPage({Key? key}) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to your login screen. Replace '/login' with your actual route:
    Navigator.of(context).pushReplacementNamed('/login_teacher');
  }

  @override
  Widget build(BuildContext context) {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(primaryColor),
        child: Icon(Icons.add, color: Colors.black, size: 36),
        onPressed: () {
          Navigator.pushNamed(context, '/create_quiz');
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── LOGO + LOGOUT BUTTON ─────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // placeholder to keep logo centered
                  const SizedBox(width: 48),
                  // your logo
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CheezQuiz',
                        style: titleStyle(
                          textColor: const Color(primaryColor),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/cheese-icon.png',
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  // logout button
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.black,
                    onPressed: () => _handleLogout(context),
                  ),
                ],
              ),

              const SizedBox(height: 4),
              Center(
                child: Text(
                  'TEACHER',
                  style: titleStyle(textColor: Colors.black, fontSize: 16),
                ),
              ),

              const SizedBox(height: 32),
              Text(
                'Hi, Teacher!',
                style: titleStyle(textColor: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to manage your quizzes?',
                style: subtitleStyle(textColor: Colors.black, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // ── Quiz List ────────────────────────────────
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: quizRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading quizzes.'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final quizzes = snapshot.data!.docs;
                    if (quizzes.isEmpty) {
                      return const Center(
                        child: Text('No quizzes created yet.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/quiz_view',
                              arguments: {
                                'quizId': quiz.id,
                                'quizTitle': quiz['title'] ?? 'Untitled',
                              },
                            );
                          },
                          child: QuizCard(
                            quizId: quiz.id,
                            title: quiz['title'] ?? 'Untitled',
                            subtitle: 'Prelims',
                            itemsCount: 'Questions: ?',
                            imagePath: 'assets/differentiation-bg.png',
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String quizId;
  final String title;
  final String subtitle;
  final String itemsCount;
  final String imagePath;

  const QuizCard({
    Key? key,
    required this.quizId,
    required this.title,
    required this.subtitle,
    required this.itemsCount,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(strokeColor)),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title + Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: titleStyle(textColor: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: subtitleStyle(textColor: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            // Placeholder
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class AddQuizCard extends StatelessWidget {
  const AddQuizCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(strokeColor)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.add, size: 40, color: Color(strokeColor)),
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
    textStyle: TextStyle(fontSize: fontSize, color: textColor),
  );
}
