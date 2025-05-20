import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizPage extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final List<dynamic> questions; // each question map must have a `type` key

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
  final Map<int, String> _selectedChoices = {};
  final Map<int, TextEditingController> _freeformCtrls = {};

  @override
  void initState() {
    super.initState();
    // Prepare controllers for any freeform questions
    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i] as Map<String, dynamic>;
      if (q['type'] == 'freeform') {
        _freeformCtrls[i] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _freeformCtrls.values.forEach((c) => c.dispose());
    super.dispose();
  }

  bool get _isLast => _current == widget.questions.length - 1;

  bool _hasAnswered() {
    final q = widget.questions[_current] as Map<String, dynamic>;
    final t = q['type'] as String? ?? 'multiple';
    if (t == 'freeform') {
      return (_freeformCtrls[_current]?.text.trim().isNotEmpty ?? false);
    }
    return (_selectedChoices[_current]?.isNotEmpty ?? false);
  }

  void _nextOrSubmit() {
    if (!_hasAnswered()) return;
    if (_isLast) {
      _submitQuiz();
    } else {
      setState(() => _current++);
    }
  }

  Future<void> _submitQuiz() async {
    final user = _auth.currentUser;
    if (user == null) return;

    int correctCount = 0, scorable = 0;
    final answers = <Map<String, dynamic>>[];

    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i] as Map<String, dynamic>;
      final type = q['type'] as String? ?? 'multiple';
      final correctAns = q['correctAnswer'] as String? ?? '';
      String selected;

      if (type == 'freeform') {
        selected = _freeformCtrls[i]!.text.trim();
      } else {
        selected = _selectedChoices[i] ?? '';
        scorable++;
        if (selected == correctAns) correctCount++;
      }

      answers.add({
        'question': q['question'],
        'type': type,
        'selectedAnswer': selected,
        'correctAnswer': correctAns,
        'isCorrect': type == 'freeform' ? null : selected == correctAns,
      });
    }

    final score = correctCount;
    final scorePercentage = scorable == 0 ? 0 : (correctCount / scorable) * 100;

    await FirebaseFirestore.instance.collection('submissions').add({
      'studentId': user.uid,
      'quizId': widget.quizId,
      'answers': answers,
      'score': score,
      'scorePercentage': scorePercentage,
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
    final q = widget.questions[_current] as Map<String, dynamic>;
    final type = q['type'] as String? ?? 'multiple';
    final selected = _selectedChoices[_current];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────── HEADER ─────────────────────
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

              // ─────────── QUESTION TEXT ──────────────
              Text(
                q['question'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // ─────────── MULTIPLE CHOICE ────────────
              if (type == 'multiple')
                ...['A', 'B', 'C', 'D'].map((ltr) {
                  final txt = (q['choices'] as Map)[ltr] as String? ?? '';
                  return _buildOption(
                    label: ltr,
                    text: txt,
                    selected: selected == ltr,
                    onTap:
                        () => setState(() {
                          _selectedChoices[_current] = ltr;
                        }),
                  );
                }),

              // ─────────── TRUE / FALSE ──────────────
              if (type == 'trueFalse') ...[
                _buildOption(
                  label: 'A',
                  text: 'True',
                  selected: selected == 'A',
                  onTap:
                      () => setState(() {
                        _selectedChoices[_current] = 'A';
                      }),
                ),
                _buildOption(
                  label: 'B',
                  text: 'False',
                  selected: selected == 'B',
                  onTap:
                      () => setState(() {
                        _selectedChoices[_current] = 'B';
                      }),
                ),
              ],

              // ─────────── FREEFORM ───────────────────
              if (type == 'freeform')
                TextFormField(
                  controller: _freeformCtrls[_current],
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your answer…',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(strokeColor)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

              const Spacer(),

              // ─────────── NAVIGATION ────────────────
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

// ─────────── TEXT STYLES ───────────────────────

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
