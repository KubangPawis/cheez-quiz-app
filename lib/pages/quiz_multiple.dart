import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_good_student.dart';
import 'result_bad_student.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizPage extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final List<dynamic>
  questions; // each question map must have 'question', 'choices', 'correctAnswer'

  const QuizPage({
    Key? key,
    required this.quizId,
    required this.quizTitle,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _auth = FirebaseAuth.instance;

  int _current = 0;
  final Map<int, String> _selected = {};

  bool get _isLast => _current == widget.questions.length - 1;

  bool _hasAnswered() {
    return (_selected[_current]?.isNotEmpty ?? false);
  }

  void _nextOrSubmit() {
    if (!_hasAnswered()) return;
    if (_isLast) {
      _submit();
    } else {
      setState(() => _current++);
    }
  }

  Future<void> _submit() async {
    final user = _auth.currentUser;
    if (user == null) return;

    int correct = 0;
    final answers = <Map<String, dynamic>>[];

    for (var i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i] as Map<String, dynamic>;
      final correctAns = q['correctAnswer'] as String? ?? '';
      final selectedAns = _selected[i] ?? '';
      final isCorrect = selectedAns == correctAns;
      if (isCorrect) correct++;

      answers.add({
        'question': q['question'],
        'selectedAnswer': selectedAns,
        'correctAnswer': correctAns,
        'isCorrect': isCorrect,
      });
    }

    final scorePercent =
        (widget.questions.isEmpty)
            ? 0
            : (correct / widget.questions.length) * 100;

    await FirebaseFirestore.instance.collection('submissions').add({
      'studentId': user.uid,
      'quizId': widget.quizId,
      'answers': answers,
      'score': correct,
      'scorePercentage': scorePercent,
      'submittedAt': Timestamp.now(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                scorePercent >= 60
                    ? StudentResultGoodPage(
                      quizScore: correct,
                      itemCount: widget.questions.length,
                    )
                    : StudentResultBadPage(
                      quizScore: correct,
                      itemCount: widget.questions.length,
                    ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_current] as Map<String, dynamic>;
    final choices = q['choices'] as Map<String, dynamic>;
    final selected = _selected[_current];

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
                children: [
                  Text(
                    widget.quizTitle,
                    style: titleStyle(textColor: Colors.black, fontSize: 24),
                  ),
                  const Spacer(),
                  Text(
                    'Question ${_current + 1} / ${widget.questions.length}',
                    style: subtitleStyle(
                      textColor: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 24),

              // QUESTION TEXT
              Text(
                q['question'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // MULTIPLE CHOICE OPTIONS A–D
              ...['A', 'B', 'C', 'D'].map((ltr) {
                final txt = (choices[ltr] ?? '') as String;
                return _buildOption(
                  label: ltr,
                  text: txt,
                  selected: selected == ltr,
                  onTap: () => setState(() => _selected[_current] = ltr),
                );
              }),

              const Spacer(),

              // NAVIGATION
              Row(
                children: [
                  if (_current > 0)
                    OutlinedButton(
                      onPressed: () => setState(() => _current--),
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _hasAnswered() ? _nextOrSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _isLast ? 'Submit' : 'Next',
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

  Widget _buildOption({
    required String label,
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? const Color(primaryColor) : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Radio<String>(
          value: label,
          groupValue: selected ? label : null,
          onChanged: (_) => onTap(),
          activeColor: const Color(primaryColor),
        ),
        title: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
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
