import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = 0xFFFFCC00;
const strokeColor = 0xFF6C6C6C;

class StudentLoginPage extends StatelessWidget {
  const StudentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1200, // Constrain maximum width
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* HEADER */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to',
                            style: titleStyle(
                              textColor: Color(primaryColor),
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'CheezQuiz',
                            style: titleStyle(
                              textColor: Color(primaryColor),
                              fontSize: 96,
                            ),
                          ),
                          Text(
                            'STUDENT',
                            style: titleStyle(
                              textColor: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Image.asset(
                          'assets/cheese-icon.png',
                          width: 300,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40), // Spacing between header and body
                  /* BODY CONTENT*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /* LOGIN FORM */
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // EMAIL TEXT FIELD
                            Text(
                              'Username',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                            ),

                            // PASSWORD TEXT FIELD
                            SizedBox(height: 16),
                            Text(
                              'Password',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              obscureText: true,
                            ),

                            // BUTTON GROUP
                            SizedBox(height: 32),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  children: [
                                    //LOG IN BUTTON
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          backgroundColor: Color(primaryColor),
                                          foregroundColor: Colors.black,
                                          padding: EdgeInsets.all(15),
                                        ),
                                        child: Text(
                                          'LOG IN',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //SIGN UP BUTTON
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          foregroundColor: Colors.black,
                                          padding: EdgeInsets.all(15),
                                        ),
                                        child: Text(
                                          'RETURN',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 40),

                      /* CHEESE MASCOT */
                      Image.asset(
                        'assets/mascot-happy.jpg',
                        width: 400,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ],
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
