import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class StudentMainPage extends StatelessWidget {
  const StudentMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      width: 80,
                      height: 40,
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

              Text(
                'Hi, John!',
                style: titleStyle(textColor: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to answer some quizzes?',
                style: subtitleStyle(textColor: Colors.black, fontSize: 16),
              ),

              const SizedBox(height: 24),

              QuizCard(
                title: 'Rules of Differentiation',
                subtitle: 'Prelims',
                itemsCount: '5 Items',
                imagePath: 'assets/differentiation-bg.png',
              ),
              const SizedBox(height: 16),
              QuizCard(
                title: 'Basics of Algebra',
                subtitle: 'Prelims',
                itemsCount: '5 Items',
                imagePath: 'assets/algebra-bg.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String itemsCount;
  final String imagePath;

  const QuizCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.itemsCount,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Color(strokeColor)),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title + Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: titleStyle(textColor: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: subtitleStyle(textColor: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            // Item count badge on the right
            Text(
              itemsCount,
              style: subtitleStyle(textColor: Colors.white, fontSize: 14),
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
