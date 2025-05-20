import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quiz_success_page.dart';
import 'result_good_student.dart';
import 'result_bad_student.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizMultiplePage extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final List<dynamic> questions;

  const QuizMultiplePage({
    Key? key,
    required this.quizId,
    required this.quizTitle,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizMultiplePage> createState() => _QuizMultiplePageState();
}

class _QuizMultiplePageState extends State<QuizMultiplePage> {
  final _auth = FirebaseAuth.instance;
  int _currentQuestion = 0;
  Map<int, String> _selectedAnswers = {};

  void _submitQuiz() async {
    final user = _auth.currentUser;
    if (user == null) return;

    int correctCount = 0;
    final answerList = <Map<String, dynamic>>[];

    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i] as Map<String, dynamic>;
      final correct = q['correctAnswer'];
      final selected = _selectedAnswers[i] ?? '';
      final isCorrect = selected == correct;
      if (isCorrect) correctCount++;

      answerList.add({
        'question': q['question'],
        'selectedAnswer': selected,
        'correctAnswer': correct,
        'isCorrect': isCorrect,
      });
    }

    final score = correctCount;
    final scorePercentage = correctCount / widget.questions.length;

    await FirebaseFirestore.instance.collection('submissions').add({
      'studentId': user.uid,
      'quizId': widget.quizId,
      'answers': answerList,
      'score': score,
      'submittedAt': Timestamp.now(),
    });

    if (scorePercentage > 0.5) {
      Navigator.pushReplacementNamed(
        context,
        '/quiz_result_success',
        arguments: {'quizScore': score.toString()},
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/quiz_result_fail',
        arguments: {'quizScore': score.toString()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestion] as Map<String, dynamic>;
    final selected = _selectedAnswers[_currentQuestion];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    widget.quizTitle,
                    style: titleStyle(textColor: Colors.black, fontSize: 24),
                  ),
                  const Spacer(),
                  Text(
                    'Question ${_currentQuestion + 1} / ${widget.questions.length}',
                    style: subtitleStyle(
                      textColor: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(),

              const SizedBox(height: 24),
              Text(
                question['question'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Options
              ...['A', 'B', 'C', 'D'].map((letter) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selected == letter
                              ? Color(primaryColor)
                              : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      question['choices'][letter] ?? '',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    leading: Radio<String>(
                      value: letter,
                      groupValue: selected,
                      onChanged: (value) {
                        setState(
                          () => _selectedAnswers[_currentQuestion] = value!,
                        );
                      },
                      activeColor: Color(primaryColor),
                    ),
                  ),
                );
              }),

              const Spacer(),

              Row(
                children: [
                  if (_currentQuestion > 0)
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _currentQuestion--);
                      },
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        selected == null
                            ? null
                            : () {
                              if (_currentQuestion <
                                  widget.questions.length - 1) {
                                setState(() => _currentQuestion++);
                              } else {
                                _submitQuiz();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentQuestion < widget.questions.length - 1
                          ? 'Next'
                          : 'Submit',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
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
