import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizMultiplePage extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;

  const QuizMultiplePage({
    Key? key,
    this.questionIndex = 1,
    this.totalQuestions = 5,
  }) : super(key: key);

  @override
  _QuizMultiplePageState createState() => _QuizMultiplePageState();
}

class _QuizMultiplePageState extends State<QuizMultiplePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionCtrl,
      _choiceA,
      _choiceB,
      _choiceC,
      _choiceD;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          // 1) Center everything
          child: ConstrainedBox(
            // 2) Constrain the width
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HEADER (same as before) ---
                  Center(
                    child: Row(
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
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'TEACHER',
                      style: titleStyle(textColor: Colors.black, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- QUESTION LABELS ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Question ${widget.questionIndex} / ${widget.totalQuestions}',
                      style: titleStyle(textColor: Colors.black, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Which of the following is a variable?',
                      style: subtitleStyle(
                        textColor: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- CHOICES LABEL ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choices:',
                      style: titleStyle(textColor: Colors.black, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- TWO ROWS OF TWO FIELDS ---
                  Row(
                    children: [
                      Text('A. 7'),
                      const SizedBox(width: 16),
                      Text('C. 12'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('B. x'),
                      const SizedBox(width: 16),
                      Text('D. 3.5'),
                    ],
                  ),

                  const SizedBox(height: 24),

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
                      onPressed: () {},
                      child: Text(
                        'NEXT',
                        style: titleStyle(
                          textColor: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                          textColor: Colors.black,
                          fontSize: 16,
                        ),
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

  // reuse your text styles:
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
