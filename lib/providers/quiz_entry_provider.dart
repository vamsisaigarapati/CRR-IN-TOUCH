import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modals/quiz.dart';
import 'package:http/http.dart' as http;

class QuizEntry with ChangeNotifier{
List<QuizClass> _items = [
    
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String authUserId;
  QuizEntry(this.authToken, this.authUserId, this._items);
  List<QuizClass> get items {
    
    return [..._items];
  }

  

  
  Future<void> addQuizEntry(QuizClass quiz) async {
final String stringFilter=DateFormat.y().format(quiz.dateTime)+'_'+DateFormat.M().format(quiz.dateTime)+'_'+DateFormat.d().format(quiz.dateTime)+quiz.department+quiz.year.toString();
final String table='quizon'+stringFilter;
    final url = 'https://crr-coe.firebaseio.com/quiz/$table.json?auth=$authToken';
   
    try {
      await http.post(
        url,
        body: json.encode({
          "dateTime":quiz.dateTime.toIso8601String(),
          "department":quiz.department,
          "subject":quiz.subject,
          "year":quiz.year,
          "noOfQuestions":quiz.noOfQuestions,
          "questions":null,
        }),
      );
      
    } catch (error) {
      print(error);
      throw error;
    }
  }

 
}