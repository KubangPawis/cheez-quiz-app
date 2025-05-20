import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cheez_quiz_app/pages/quiz_review_page.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({Key? key}) : super(key: key);

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  final _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  Future<void> _handleLogout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login_student');
  }

  Future<void> _openQuiz(
    BuildContext context,
    Map<String, dynamic> quizData,
    String quizId,
  ) async {
    // 1) fetch questions
    final qSnap =
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
            .collection('questions')
            .get();
    final questions = qSnap.docs.map((d) => d.data()..['id'] = d.id).toList();
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This quiz has no questions yet.")),
      );
      return;
    }

    // 2) see if they've already submitted
    final subSnap =
        await FirebaseFirestore.instance
            .collection('submissions')
            .where('studentId', isEqualTo: _user.uid)
            .where('quizId', isEqualTo: quizId)
            .limit(1)
            .get();

    if (subSnap.docs.isNotEmpty) {
      // REVIEW mode
      final submission = subSnap.docs.first.data();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QuizReviewPage(
                quizTitle: quizData['title'] ?? 'Quiz',
                questions: questions,
                submission: submission,
              ),
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        '/quiz_multiple',
        arguments: {
          'quizId': quizId,
          'quizTitle': quizData['title'] ?? 'Quiz',
          'questions': questions,
        },
      );
    }
  }

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
              // HEADER + LOGOUT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CheezQuiz',
                        style: titleStyle(
                          textColor: Color(primaryColor),
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
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _handleLogout,
                  ),
                ],
              ),

              const SizedBox(height: 4),
              Center(
                child: Text(
                  'STUDENT',
                  style: titleStyle(textColor: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Hi, ${_user.email}',
                style: titleStyle(textColor: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select a quiz to begin.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // QUIZ LIST
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('quizzes')
                          .snapshots(),
                  builder: (c, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snap.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(child: Text('No quizzes available.'));
                    }
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final quizId = docs[i].id;
                        return FutureBuilder<QuerySnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('quizzes')
                                  .doc(quizId)
                                  .collection('questions')
                                  .get(),
                          builder: (c2, s2) {
                            final count = s2.data?.docs.length ?? 0;
                            return GestureDetector(
                              onTap: () => _openQuiz(context, data, quizId),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(strokeColor)),
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/algebra-bg.png'),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black38,
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['title'] ?? 'Quiz',
                                          style: titleStyle(
                                            textColor: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$count Questions',
                                          style: subtitleStyle(
                                            textColor: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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

// keep your styles...
TextStyle titleStyle({required Color textColor, required double? fontSize}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
TextStyle subtitleStyle({
  required Color textColor,
  required double? fontSize,
}) => GoogleFonts.poppins(
  textStyle: TextStyle(fontSize: fontSize, color: textColor),
);
