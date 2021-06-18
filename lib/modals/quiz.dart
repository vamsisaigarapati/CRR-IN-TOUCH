import 'package:flutter/cupertino.dart';

// import './question.dart';

class QuizClass {
  final DateTime dateTime;
  final String department;
  final String subject;
  final int year;
  final int noOfQuestions;
  // final List<Question> questions;
  QuizClass({
   @required this.dateTime,
   @required this.department,
   @required this.year,
  //  @required this.questions,
   @required this.subject,
   @required this.noOfQuestions
  });
}
