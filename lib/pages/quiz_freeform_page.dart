import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quiz_success_page.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizFreeformPage extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final List<dynamic> questions;

  const QuizFreeformPage({
    Key? key,
    required this.quizId,
    required this.quizTitle,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizFreeformPage> createState() => _QuizFreeformPageState();
}

class _QuizFreeformPageState extends State<QuizFreeformPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.questions.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitAnswers() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final List<Map<String, dynamic>> answers = [];

    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i] as Map<String, dynamic>;
      answers.add({
        'question': question['question'],
        'answer': _controllers[i].text.trim(),
        'isCorrect': null, // Teacher will review
      });
    }

    await FirebaseFirestore.instance.collection('submissions').add({
      'studentId': user.uid,
      'quizId': widget.quizId,
      'answers': answers,
      'score': null,
      'submittedAt': Timestamp.now(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuizSuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView(
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
                      '${widget.questions.length} Questions',
                      style: subtitleStyle(textColor: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Question Text Fields
                for (int i = 0; i < widget.questions.length; i++) ...[
                  Text(
                    'Q${i + 1}: ${widget.questions[i]['question']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controllers[i],
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type your answer...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(strokeColor)),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter your answer'
                        : null,
                  ),
                  const SizedBox(height: 24),
                ],

                // Submit Button
                ElevatedButton(
                  onPressed: _submitAnswers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'SUBMIT QUIZ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
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

  TextStyle subtitleStyle({required Color textColor, required double? fontSize}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
