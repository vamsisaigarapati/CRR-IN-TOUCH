import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/modals/student_class.dart';
import '../modals/question.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../modals/staff_class.dart';


class ResultProvider with ChangeNotifier {
  Map _items = {};
  // var _showFavoritesOnly = false;
  final String authToken;
  final String authUserId;
  ResultProvider(this.authToken, this.authUserId);
  Map get items {
    return _items;
  }

  Future<void> updateResult(Student details, String subject, int marks) async {
    print(marks);
    print('marks');
    print(subject);
    final String stringFilter = DateFormat.y().format(DateTime.now()) +
        '_' +
        DateFormat.M().format(DateTime.now()) +
        '_' +
        DateFormat.d().format(DateTime.now()) +
        details.department +
        details.year.toString();
    final String resultsTable = 'resultson' + stringFilter;
    final String quizTakenTable = 'takenon' + stringFilter;

    final resultsUrl =
        'https://crr-coe.firebaseio.com/results/$resultsTable/$subject.json?auth=$authToken';
    final quizTakenUrl =
        'https://crr-coe.firebaseio.com/taken/$quizTakenTable/$subject.json?auth=$authToken';
    String updateTakenId;
    String resultId;
    final takenResponse = await http.get(quizTakenUrl);
    
    final resulTableResponse = await http.get(resultsUrl);
    final takenExtractedData =
        json.decode(takenResponse.body) as Map<String, dynamic>;
    final resultExtractedData =
        json.decode(resulTableResponse.body) as Map<String, dynamic>;
    print(resultExtractedData);
    print('result');
    print(takenExtractedData);
    print('taken');
    takenExtractedData.forEach((id, data) {
      updateTakenId = id;
    });
    resultExtractedData.forEach((id, data) {
      resultId = id;
    });
    print(updateTakenId);
    print(resultId);

    final updateResultsUrl =
        'https://crr-coe.firebaseio.com/results/$resultsTable/$subject/$resultId.json?auth=$authToken';
    final updateQuizTakenUrl =
        'https://crr-coe.firebaseio.com/taken/$quizTakenTable/$subject/$updateTakenId.json?auth=$authToken';
    try {
      await http.patch(updateResultsUrl,
          body: json.encode({details.rno.toString() + 'r': marks}));
      await http.patch(updateQuizTakenUrl,
          body: json.encode({details.rno.toString() + 'r': 1}));
    } catch (error) {
      throw error;
    }
  }





 Future<void> fetchResult(Staff details,int year) async {
    print('ommmm');
    List subject = [];

    // final filterString =
    //      'orderBy="userId"&equalTo="$authUserId"';
    
    final String stringFilter = DateFormat.y().format(DateTime.now()) +
        '_' +
        DateFormat.M().format(DateTime.now()) +
        '_' +
        DateFormat.d().format(DateTime.now()) +
        details.department +
       year.toString();
    final String table = 'quizon' + stringFilter;
    final String questionsTable = "questions" + stringFilter;
    final String resultTable = 'resultson' + stringFilter;
    
    final url =
        'https://crr-coe.firebaseio.com/quiz/$table.json?auth=$authToken';
    final resultUrl='https://crr-coe.firebaseio.com/results/$resultTable.json?auth=$authToken';
   
    try {
      final response = await http.get(url);
      final resultResponse = await http.get(resultUrl);
      final resultExtractedData =
          json.decode(resultResponse.body) as Map<String, dynamic>;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      print(resultExtractedData);
      if (extractedData == null) {
        print('returning');
        return;
      }
      List resultSub=[];
      List finalSubjectList=[];
      resultExtractedData.forEach((sub,result){
          resultSub.add(sub);
      });
      

      extractedData.forEach((id, data) {
        
        if (id != questionsTable) {
          
          final DateTime time = DateTime.parse(data['dateTime']);

          
          final DateTime afterTime =
              DateTime(time.year, time.month, time.day, time.hour+1, time.minute);
          print(DateFormat.Hm().format(time));
          print(DateFormat.Hm().format(afterTime));
          if (
              DateTime.now().isAfter(afterTime)) {
            subject.add(data['subject']);
          }
        }
      });
      
      
      resultSub.forEach((i){
        subject.forEach((j){
          if(i==j){
            finalSubjectList.add(i);
          }
        });
      });
     
     
      if (finalSubjectList.length != 0) {
        resultExtractedData.forEach((sub,result){
          finalSubjectList.forEach((i){
            if(i==sub){
              result.forEach((id,res){
                _items[sub]=res;
              });
            }
          });
        });
      } else {
        _items = {};
      }
      print(_items);
    } catch (error) {
      throw (error);
    }
  }
}
