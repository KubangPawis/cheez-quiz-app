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
  int? _selectedIndex;

  // your static data for now; you can pull these from args or your model later
  final List<String> _labels = ['A.', 'B.', 'C.', 'D.'];
  final List<String> _choices = ['7', 'x', '12', '3.5'];

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 900;
    const double gap = 16;

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
                  // ─── HEADER ────────────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CheezQuiz',
                          style: titleStyle(
                              textColor: Color(primaryColor), fontSize: 32),
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
                      style: titleStyle(textColor: Colors.black, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── QUESTION LABELS ───────────────────────
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
                          textColor: Colors.black, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── CHOICES ───────────────────────────────
                  Row(
                    children: [
                      _buildChoiceButton(0),
                      SizedBox(width: gap),
                      _buildChoiceButton(2),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChoiceButton(1),
                      SizedBox(width: gap),
                      _buildChoiceButton(3),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ─── NEXT & RETURN ─────────────────────────
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _selectedIndex != null
                          ? () {
                              // TODO: lock in answer & navigate
                            }
                          : null, // disabled if none selected
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
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(strokeColor)),
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

  Widget _buildChoiceButton(int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // toggle selection
            _selectedIndex = (isSelected ? null : index);
          });
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? Color(primaryColor).withOpacity(0.4)
                : Colors.white,
            border: Border.all(color: Color(strokeColor)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${_labels[index]} ',
                  style: titleStyle(
                      textColor: Colors.black, fontSize: 16),
                ),
                TextSpan(
                  text: _choices[index],
                  style: subtitleStyle(
                      textColor: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable Poppins text styles
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
    textStyle: TextStyle(
      fontSize: fontSize,
      color: textColor,
    ),
  );
}
