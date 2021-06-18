import 'package:flutter/cupertino.dart';

class Question {
  final String question;
  final String optA;
  final String optB;
  final String optC;
  final String optD;
  final String correctOpt;
  Question({
   @required this.question,
   @required this.optA,
   @required this.optB,
   @required this.optC,
   @required this.optD,
   @required this.correctOpt,
   } );
}
