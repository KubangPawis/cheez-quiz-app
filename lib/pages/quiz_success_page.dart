import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class QuizSuccessPage extends StatelessWidget {
  const QuizSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // max width for larger screens
    const double maxContentWidth = 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // — Logo + TEACHER —
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
                      'TEACHER',
                      style:
                          titleStyle(textColor: Colors.black, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // — Main Content: Congratulations + Mascot —
                  Expanded(
                    child: Row(
                      children: [
                        // Left side: text + button
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Congratulations!',
                                style: titleStyle(
                                    textColor: Colors.black, fontSize: 36),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "You've successfully created another quiz.",
                                style: subtitleStyle(
                                    textColor: Colors.black, fontSize: 14),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: 300,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: navigate onward
                                  },
                                  child: Text(
                                    'CONTINUE',
                                    style: titleStyle(
                                        textColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side: mascot image
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/mascot-teacher.png',
                              // adjust to taste:
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
