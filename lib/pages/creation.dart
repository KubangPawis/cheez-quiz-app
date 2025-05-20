import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class TeacherQuestionPage extends StatefulWidget {
  final String quizTitle;
  final String quizId;

  const TeacherQuestionPage({
    Key? key,
    required this.quizTitle,
    required this.quizId,
  }) : super(key: key);

  @override
  State<TeacherQuestionPage> createState() => _TeacherQuestionPageState();
}

class _TeacherQuestionPageState extends State<TeacherQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirestoreService();

  late TextEditingController _questionCtrl,
      _choiceA,
      _choiceB,
      _choiceC,
      _choiceD;
  String _selectedCorrect = 'A';
  int _currentIndex = 1;

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

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final question = _questionCtrl.text.trim();
    final choices = {
      'A': _choiceA.text.trim(),
      'B': _choiceB.text.trim(),
      'C': _choiceC.text.trim(),
      'D': _choiceD.text.trim(),
    };
    final correct = _selectedCorrect;

    await _firestore.addQuestion(
      quizId: widget.quizId,
      question: question,
      choices: choices,
      correctAnswer: correct,
      type: 'multiple', // always multiple
    );

    setState(() {
      _currentIndex++;
      _questionCtrl.clear();
      _choiceA.clear();
      _choiceB.clear();
      _choiceC.clear();
      _choiceD.clear();
      _selectedCorrect = 'A';
    });
  }

  void _finishQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz saved with ${_currentIndex - 1} questions!'),
      ),
    );
    Navigator.of(context).pop();
  }

  Widget _choiceField(String letter, TextEditingController ctrl, String hint) {
    return Expanded(
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          prefix: Text(
            '$letter  ',
            style: titleStyle(textColor: Colors.black, fontSize: 16),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(strokeColor)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 900, gap = 16;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HEADER
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
                      style: titleStyle(textColor: Colors.black, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // QUESTION NUMBER
                  Text(
                    'Question $_currentIndex',
                    style: titleStyle(textColor: Colors.black, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fill up the following fields.',
                    style: subtitleStyle(textColor: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // QUESTION BOX
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _questionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your question…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(strokeColor),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator:
                          (v) =>
                              (v ?? '').isEmpty
                                  ? 'Please enter a question'
                                  : null,
                    ),
                  ),

                  // CHOICES
                  const SizedBox(height: 24),
                  Text(
                    'Choices:',
                    style: titleStyle(textColor: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _choiceField('A.', _choiceA, 'Write Choice A'),
                      SizedBox(width: gap),
                      _choiceField('C.', _choiceC, 'Write Choice C'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _choiceField('B.', _choiceB, 'Write Choice B'),
                      SizedBox(width: gap),
                      _choiceField('D.', _choiceD, 'Write Choice D'),
                    ],
                  ),

                  // CORRECT ANSWER
                  const SizedBox(height: 24),
                  Text(
                    'Select correct answer:',
                    style: titleStyle(textColor: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children:
                        ['A', 'B', 'C', 'D'].map((l) {
                          return Row(
                            children: [
                              Radio<String>(
                                value: l,
                                groupValue: _selectedCorrect,
                                onChanged:
                                    (v) =>
                                        setState(() => _selectedCorrect = v!),
                              ),
                              Text(l),
                              const SizedBox(width: 16),
                            ],
                          );
                        }).toList(),
                  ),

                  const Spacer(),

                  // ADD vs FINISH
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(primaryColor),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _saveAndContinue,
                          child: Text(
                            'Add Question',
                            style: titleStyle(
                              textColor: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(strokeColor)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _finishQuiz,
                          child: Text(
                            'Finish Quiz',
                            style: titleStyle(
                              textColor: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TEXT STYLES

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
