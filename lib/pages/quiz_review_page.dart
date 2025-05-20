import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;

class QuizReviewPage extends StatelessWidget {
  final String quizTitle;
  final List<Map<String, dynamic>> questions;
  final Map<String, dynamic> submission;

  const QuizReviewPage({
    Key? key,
    required this.quizTitle,
    required this.questions,
    required this.submission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scorePercentage = submission['scorePercentage'] as num? ?? 0;
    final answers = submission['answers'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(quizTitle, style: GoogleFonts.poppins(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Your Score: ${scorePercentage.toStringAsFixed(1)}%',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (c, i) {
                  final a = answers[i] as Map<String, dynamic>;
                  final correct = a['correctAnswer'] ?? '';
                  final selected = a['selectedAnswer'] ?? '';
                  final isCorrect = a['isCorrect'] == true;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${i + 1}: ${a['question']}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your answer: $selected',
                            style: GoogleFonts.poppins(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (!isCorrect)
                            Text(
                              'Correct answer: $correct',
                              style: GoogleFonts.poppins(color: Colors.green),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'RETURN',
                style: titleStyle(textColor: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
