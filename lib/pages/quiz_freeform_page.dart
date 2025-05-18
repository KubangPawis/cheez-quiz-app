import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class StudentFreeformQuestionPage extends StatefulWidget {
  const StudentFreeformQuestionPage({Key? key}) : super(key: key);

  @override
  _StudentFreeformQuestionPageState createState() =>
      _StudentFreeformQuestionPageState();
}

class _StudentFreeformQuestionPageState
    extends State<StudentFreeformQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _answerCtrl;

  @override
  void initState() {
    super.initState();
    _answerCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pull args via Navigator.settings.arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final int questionIndex = args?['index'] ?? 1;
    final int totalQuestions = args?['total'] ?? 1;
    final String prompt = args?['question'] ??
        'Write your answer here…';

    const maxWidth = 600.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo + STUDENT ─────────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CheezQuiz',
                          style: titleStyle(
                              textColor: Color(primaryColor),
                              fontSize: 32),
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
                      'STUDENT',
                      style:
                          titleStyle(textColor: Colors.black, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Question header ────────────────────────────
                  Text(
                    'Question $questionIndex / $totalQuestions',
                    style:
                        titleStyle(textColor: Colors.black, fontSize: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    prompt,
                    style: subtitleStyle(
                        textColor: Colors.black, fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // ── Freeform answer box ───────────────────────
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _answerCtrl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write your answer…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Color(strokeColor), width: 1),
                        ),
                        contentPadding:
                            const EdgeInsets.all(16),
                      ),
                      validator: (v) => (v ?? '').isEmpty
                          ? 'Please enter your answer'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── NEXT button ───────────────────────────────
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: submit answer & navigate
                        }
                      },
                      child: Text(
                        'NEXT',
                        style: titleStyle(
                            textColor: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── RETURN button ─────────────────────────────
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(strokeColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'RETURN',
                        style: subtitleStyle(
                            textColor: Colors.black, fontSize: 16),
                      ),
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
}

/// Poppins styles
TextStyle titleStyle(
        {required Color textColor, required double? fontSize}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

TextStyle subtitleStyle(
        {required Color textColor, required double? fontSize}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
    );
