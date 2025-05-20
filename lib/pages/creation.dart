import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

enum QuestionType { multiple, trueFalse, freeform }

class TeacherQuestionPage extends StatefulWidget {
  final String quizTitle;
  final String quizId;
  final int questionIndex;
  final int totalQuestions;

  const TeacherQuestionPage({
    Key? key,
    required this.quizTitle,
    required this.quizId,
    this.questionIndex = 1,
    this.totalQuestions = 5,
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

  QuestionType _type = QuestionType.multiple;
  String _selectedCorrect = 'A';

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

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    final question = _questionCtrl.text.trim();
    Map<String, String> choices;
    String correct;

    switch (_type) {
      case QuestionType.multiple:
        choices = {
          'A': _choiceA.text.trim(),
          'B': _choiceB.text.trim(),
          'C': _choiceC.text.trim(),
          'D': _choiceD.text.trim(),
        };
        correct = _selectedCorrect;
        break;

      case QuestionType.trueFalse:
        choices = {
          'A': 'True',
          'B': 'False',
        };
        correct = _selectedCorrect;
        break;

      case QuestionType.freeform:
        choices = {};
        correct = '';
        break;
    }

    await _firestore.addQuestion(
      quizId: widget.quizId,
      question: question,
      choices: choices,
      correctAnswer: correct,
    );

    if (widget.questionIndex < widget.totalQuestions) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TeacherQuestionPage(
            quizTitle: widget.quizTitle,
            quizId: widget.quizId,
            questionIndex: widget.questionIndex + 1,
            totalQuestions: widget.totalQuestions,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('All questions saved!')));
      Navigator.of(context).pop();
    }
  }

  Widget choiceField(String letter, TextEditingController ctrl, String hint) {
    return Expanded(
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          prefix: Text('$letter  ', style: titleStyle(textColor: Colors.black, fontSize: 16)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(strokeColor)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: (v) {
          if (_type == QuestionType.multiple && (v ?? '').isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 900.0, gap = 16.0;
    // for ToggleButtons:
    final isSelected = [
      _type == QuestionType.multiple,
      _type == QuestionType.trueFalse,
      _type == QuestionType.freeform,
    ];

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
                  // ── HEADER ─────────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CheezQuiz',
                            style: titleStyle(textColor: const Color(primaryColor), fontSize: 32)),
                        const SizedBox(width: 8),
                        Image.asset('assets/cheese-icon.png', width: 32, height: 32),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(child: Text('TEACHER', style: titleStyle(textColor: Colors.black, fontSize: 16))),
                  const SizedBox(height: 32),

                  // ── QUESTION INDEX ────────────────────
                  Text('Question ${widget.questionIndex} / ${widget.totalQuestions}',
                      style: titleStyle(textColor: Colors.black, fontSize: 24)),
                  const SizedBox(height: 4),
                  Text('Fill up the following fields.',
                      style: subtitleStyle(textColor: Colors.black, fontSize: 16)),
                  const SizedBox(height: 16),

                  // ── TYPE SELECTOR ─────────────────────
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (i) => setState(() {
                      _type = QuestionType.values[i];
                      // reset correct answer default
                      _selectedCorrect = (_type == QuestionType.trueFalse) ? 'A' : 'A';
                    }),
                    borderColor: const Color(strokeColor),
                    selectedBorderColor: const Color(primaryColor),
                    fillColor: const Color(primaryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Multiple Choice')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('True / False')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Freeform')),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── QUESTION BOX ─────────────────────
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

                  // ── MULTIPLE CHOICE FIELDS ───────────
                  if (_type == QuestionType.multiple) ...[
                    const SizedBox(height: 24),
                    Text('Choices:', style: titleStyle(textColor: Colors.black, fontSize: 18)),
                    const SizedBox(height: 12),
                    Row(children: [
                      choiceField('A.', _choiceA, 'Write Choice A'),
                      SizedBox(width: gap),
                      choiceField('C.', _choiceC, 'Write Choice C'),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      choiceField('B.', _choiceB, 'Write Choice B'),
                      SizedBox(width: gap),
                      choiceField('D.', _choiceD, 'Write Choice D'),
                    ]),
                  ],

                  // ── TRUE / FALSE CHOICE (preset) ────
                  if (_type == QuestionType.trueFalse) ...[
                    const SizedBox(height: 24),
                    Text('Select the correct answer:',
                        style: titleStyle(textColor: Colors.black, fontSize: 18)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Radio<String>(
                        value: 'A',
                        groupValue: _selectedCorrect,
                        onChanged: (v) => setState(() => _selectedCorrect = v!),
                      ),
                      const Text('True'),
                      const SizedBox(width: 32),
                      Radio<String>(
                        value: 'B',
                        groupValue: _selectedCorrect,
                        onChanged: (v) => setState(() => _selectedCorrect = v!),
                      ),
                      const Text('False'),
                    ]),
                  ],

                  // ── NO CHOICES FOR FREEFORM ──────────

                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _saveQuestion,
                    child: Text('NEXT',
                        style: titleStyle(textColor: Colors.black, fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(strokeColor)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('RETURN',
                        style: subtitleStyle(textColor: Colors.black, fontSize: 16)),
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

// ── TEXT STYLES ─────────────────────────────────────

TextStyle titleStyle({required Color textColor, required double? fontSize}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
    );

TextStyle subtitleStyle({required Color textColor, required double? fontSize}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: fontSize, color: textColor),
    );
