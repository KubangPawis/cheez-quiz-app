import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class TeacherQuestionPage extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;

  const TeacherQuestionPage({
    Key? key,
    this.questionIndex = 1,
    this.totalQuestions = 5,
  }) : super(key: key);

  @override
  State<TeacherQuestionPage> createState() => _TeacherQuestionPageState();
}

class _TeacherQuestionPageState extends State<TeacherQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreService();

  late TextEditingController _questionCtrl,
      _choiceA,
      _choiceB,
      _choiceC,
      _choiceD;

  static String? _quizId; // Persist across pages

  @override
  void initState() {
    super.initState();
    _questionCtrl = TextEditingController();
    _choiceA = TextEditingController();
    _choiceB = TextEditingController();
    _choiceC = TextEditingController();
    _choiceD = TextEditingController();
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    _choiceA.dispose();
    _choiceB.dispose();
    _choiceC.dispose();
    _choiceD.dispose();
    super.dispose();
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final question = _questionCtrl.text.trim();
      final choices = {
        'A': _choiceA.text.trim(),
        'B': _choiceB.text.trim(),
        'C': _choiceC.text.trim(),
        'D': _choiceD.text.trim(),
      };

      const correctAnswer = 'A'; // Default

      if (_quizId == null) {
        _quizId = await _firestore.createQuiz('Untitled Quiz', user.uid);
      }

      await _firestore.addQuestion(
        quizId: _quizId!,
        question: question,
        choices: choices,
        correctAnswer: correctAnswer,
      );

      if (widget.questionIndex < widget.totalQuestions) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TeacherQuestionPage(
              questionIndex: widget.questionIndex + 1,
              totalQuestions: widget.totalQuestions,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All questions saved!')),
        );
        _quizId = null; // Reset for next quiz
        Navigator.of(context).pop();
      }
    }
  }

  Widget choiceField(String label, TextEditingController ctrl, String hintText) {
    return Expanded(
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(strokeColor)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          prefix: Text(
            '$label  ',
            style: titleStyle(textColor: Colors.black, fontSize: 16),
          ),
        ),
        validator: (v) => (v ?? '').isEmpty ? 'Please enter a choice' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CheezQuiz', style: titleStyle(textColor: const Color(primaryColor), fontSize: 32)),
                        const SizedBox(width: 8),
                        Image.asset('assets/cheese-icon.png', width: 32, height: 32),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(child: Text('TEACHER', style: titleStyle(textColor: Colors.black, fontSize: 16))),
                  const SizedBox(height: 32),
                  Text('Question ${widget.questionIndex} / ${widget.totalQuestions}', style: titleStyle(textColor: Colors.black, fontSize: 24)),
                  const SizedBox(height: 4),
                  Text('Fill up the following fields.', style: subtitleStyle(textColor: Colors.black, fontSize: 16)),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _questionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your question…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(strokeColor)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (v) => (v ?? '').isEmpty ? 'Please enter a question' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Choices:', style: titleStyle(textColor: Colors.black, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(children: [choiceField('A.', _choiceA, 'Write Choice A'), const SizedBox(width: 16), choiceField('C.', _choiceC, 'Write Choice C')]),
                  const SizedBox(height: 12),
                  Row(children: [choiceField('B.', _choiceB, 'Write Choice B'), const SizedBox(width: 16), choiceField('D.', _choiceD, 'Write Choice D')]),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: _saveQuestion,
                      child: Text('NEXT', style: titleStyle(textColor: Colors.black, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(strokeColor)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('RETURN', style: subtitleStyle(textColor: Colors.black, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle titleStyle({required Color textColor, required double? fontSize}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
    );
  }

  TextStyle subtitleStyle({required Color textColor, required double? fontSize}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
