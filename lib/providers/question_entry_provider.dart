import 'dart:convert';
import 'package:flutter/material.dart';
import '../modals/question.dart';
import 'package:intl/intl.dart';
import '../modals/quiz.dart';
import 'package:http/http.dart' as http;
class QuestionEntry with ChangeNotifier{
List<Question> _items = [
    
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String authUserId;
  QuestionEntry(this.authToken, this.authUserId, this._items);
  List<Question> get items {
    
    return [..._items];
  }

  

  
  Future<void> addListOfQuestions(QuizClass details,List<Question> questions) async {
    final String stringFilter=DateFormat.y().format(details.dateTime)+'_'+DateFormat.M().format(details.dateTime)+'_'+DateFormat.d().format(details.dateTime)+details.department+details.year.toString();
    final String table='quizon'+stringFilter;
    final String subTable="questions"+stringFilter;

    final url = 'https://crr-coe.firebaseio.com/quiz/$table/$subTable.json?auth=$authToken';
    
    final response = await http.post(
      url,
      body: json.encode({
        
        details.subject: questions
            .map((q) => {
                  'question': q.question,
                  'optA': q.optA,
                  'optB': q.optB,
                  'optC': q.optC,
                  'optD': q.optD,
                  'correct_option': q.correctOpt,
                })
            .toList(),
      }),
    );
    
    
  }
}


 
