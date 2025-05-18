import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'creation.dart'; // Make sure this path is correct

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class TeacherMainPage extends StatelessWidget {
  const TeacherMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Row(
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
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'TEACHER',
                  style: titleStyle(
                    textColor: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Greeting
              Text(
                'Hi, Joe!',
                style: titleStyle(
                  textColor: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to create new quizzes?',
                style: subtitleStyle(
                  textColor: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Quiz list from Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('quizzes')
                      // .where('createdBy', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No quizzes yet'));
                    }

                    final quizzes = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        final quizId = quiz.id;
                        final title = quiz['title'] ?? 'Untitled';

                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('quizzes')
                              .doc(quizId)
                              .collection('questions')
                              .get(),
                          builder: (context, qSnap) {
                            final count = qSnap.data?.docs.length ?? 0;
                            return QuizCard(
                              title: title,
                              subtitle: 'Prelims',
                              itemsCount: '$count Items',
                              imagePath: 'assets/cheese-icon.png',
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Add New Quiz Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherQuestionPage(),
                    ),
                  );
                },
                child: const AddQuizCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String itemsCount;
  final String imagePath;

  const QuizCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.itemsCount,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
                  style: titleStyle(
                    textColor: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: subtitleStyle(
                    textColor: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // Item count badge on the right
            Text(
              itemsCount,
              style: subtitleStyle(
                textColor: Colors.white,
                fontSize: 14,
              ),
            ),
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
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(strokeColor),
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
