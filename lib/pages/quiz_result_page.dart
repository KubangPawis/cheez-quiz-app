import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class StudentResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const StudentResultPage({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decide heading & message based on performance
    final bool perfect = score == totalQuestions;
    final heading = perfect
        ? 'Congratulations!'
        : score == 0
            ? 'Ouch...'
            : 'Aww...';
    final message = perfect
        ? 'You aced it! Fantastic work.'
        : score == 0
            ? 'Don’t give up—practice makes perfect. Try again soon!'
            : 'Don’t worry—every mistake is a step toward mastery. Keep practicing, and you’ll get there!';

    const maxContentWidth = 800.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // ─── Logo + STUDENT label ─────────────────────────────
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

                  const SizedBox(height: 48),

                  // ─── Main content ──────────────────────────────────────
                  Expanded(
                    child: Row(
                      children: [
                        // ← Left: heading, score, message, button
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heading,
                                style: titleStyle(
                                  textColor:
                                      perfect ? Colors.green : Colors.red,
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Score: $score / $totalQuestions',
                                style: subtitleStyle(
                                    textColor: Colors.black, fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                message,
                                style: subtitleStyle(
                                    textColor: Colors.black, fontSize: 16),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: 200,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: navigate to next screen
                                  },
                                  child: Text(
                                    'CONTINUE',
                                    style: titleStyle(
                                        textColor: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // → Right: sad‐cheese mascot
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/images/sad_cheese.png',
                              width: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
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