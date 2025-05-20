import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quiz_multiple.dart';
import 'quiz_freeform_page.dart';

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

  Future<bool> _hasSubmitted(String quizId) async {
    final snap =
        await FirebaseFirestore.instance
            .collection('submissions')
            .where('studentId', isEqualTo: _user.uid)
            .where('quizId', isEqualTo: quizId)
            .limit(1)
            .get();

    return snap.docs.isNotEmpty;
  }

  void _startQuiz(
    BuildContext context,
    Map<String, dynamic> quizData,
    String quizId,
  ) async {
    final alreadySubmitted = await _hasSubmitted(quizId);
    if (alreadySubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already completed this quiz.")),
      );
      return;
    }

    // 🔥 Fix: Fetch questions from the subcollection
    final questionSnap =
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
            .collection('questions')
            .get();

    final questions =
        questionSnap.docs.map((doc) => doc.data()..['id'] = doc.id).toList();

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This quiz has no questions yet.")),
      );
      return;
    }

    final isFreeform = questions.any((q) => q['type'] == 'freeform');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                isFreeform
                    ? QuizFreeformPage(
                      quizId: quizId,
                      quizTitle: quizData['title'],
                      questions: questions,
                    )
                    : QuizMultiplePage(
                      quizId: quizId,
                      quizTitle: quizData['title'],
                      questions: questions,
                    ),
      ),
    );
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
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CheezQuiz',
                    style: titleStyle(
                      textColor: Color(primaryColor),
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/cheese-icon.png', width: 32, height: 32),
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
                'Hi, ${_user.email ?? 'Student'}!',
                style: titleStyle(textColor: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select a quiz to begin.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 24),

              // Quizzes
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('quizzes')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final quizDocs = snapshot.data?.docs ?? [];

                    if (quizDocs.isEmpty) {
                      return const Center(child: Text('No quizzes available.'));
                    }

                    return ListView.separated(
                      itemCount: quizDocs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final data =
                            quizDocs[index].data() as Map<String, dynamic>;
                        final quizId = quizDocs[index].id;

                        return FutureBuilder<QuerySnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('quizzes')
                                  .doc(quizId)
                                  .collection('questions')
                                  .get(),
                          builder: (context, snapshot) {
                            final questionCount =
                                snapshot.data?.docs.length ?? 0;

                            return GestureDetector(
                              onTap: () => _startQuiz(context, data, quizId),
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
                                          'Prelims',
                                          style: subtitleStyle(
                                            textColor: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "$questionCount Questions",
                                      style: subtitleStyle(
                                        textColor: Colors.white70,
                                        fontSize: 14,
                                      ),
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

  TextStyle titleStyle({required Color textColor, required double? fontSize}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  TextStyle subtitleStyle({
    required Color textColor,
    required double? fontSize,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
