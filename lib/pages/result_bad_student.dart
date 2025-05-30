import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;
const goodJobColor = 0xFF4CD861;
const badJobColor = 0xFFFF4931;

class StudentResultBadPage extends StatelessWidget {
  final int quizScore;
  final int itemCount;
  const StudentResultBadPage({
    super.key,
    required this.quizScore,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWideScreen = constraints.maxWidth > 800;

                    if (isWideScreen) {
                      // Desktop/Wide screen layout
                      return IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildTextContent(context),
                            ),
                            SizedBox(width: 60),
                            Expanded(flex: 2, child: _buildMascotContent()),
                          ],
                        ),
                      );
                    } else {
                      // Mobile/Narrow screen layout
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildMascotContent(),
                          SizedBox(height: 40),
                          _buildTextContent(context),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Awww...',
          style: titleStyle(textColor: Color(badJobColor), fontSize: 64),
        ),
        SizedBox(height: 8),
        Text(
          'Score: $quizScore/$itemCount',
          style: titleStyle(textColor: Colors.black, fontSize: 32),
        ),
        SizedBox(height: 20),
        Text(
          'Don\'t worry—every mistake is a step toward mastery. Keep practicing, and you\'ll get there!',
          style: subtitleStyle(textColor: Colors.black, fontSize: 16),
        ),

        SizedBox(height: 30),

        /* CONTINUE BUTTON */
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/main_student');
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color(primaryColor),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: Text(
              'CONTINUE',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotContent() {
    return Center(
      child: Image.asset(
        'assets/mascot-sad.png',
        width: 400,
        height: 400,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 100,
              color: Colors.grey[400],
            ),
          );
        },
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
