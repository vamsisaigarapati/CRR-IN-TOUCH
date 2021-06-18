
import 'package:flutter/material.dart';


class QuizSplashScreen extends StatefulWidget {
  
  @override
  _QuizSplashScreenState createState() => _QuizSplashScreenState();
}

class _QuizSplashScreenState extends State<QuizSplashScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          "Quiz",
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.purple,
            fontFamily: "Satisfy",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}