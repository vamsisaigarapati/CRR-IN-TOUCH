import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modals/student_class.dart';
import 'package:http/http.dart' as http;
import '../modals/quiz.dart';

// class UserIdProvider with ChangeNotifier{
//   final List<Student> student;
//   UserIdProvider(this.student);
// }
class QuizProvider with ChangeNotifier {
  Map<String, dynamic> _items = {};
  List<QuizClass> _quizDetailsForNotifications = [];
  final String authToken;
  final String authUserId;
  DateTime date;
  QuizProvider(this.authToken, this.authUserId);
  Map<String, dynamic> get items {
    return _items;
  }

  List<QuizClass> get quizDetailsForNotifications {
    return [..._quizDetailsForNotifications];
  }

  Future<void> fetchQuiz(Student details) async {
    print('ommmm');
    List subject = [];

    // final filterString =
    //      'orderBy="userId"&equalTo="$authUserId"';
    _items = {};
    final String stringFilter = DateFormat.y().format(DateTime.now()) +
        '_' +
        DateFormat.M().format(DateTime.now()) +
        '_' +
        DateFormat.d().format(DateTime.now()) +
        details.department +
        details.year.toString();
    final String table = 'quizon' + stringFilter;
    final String questionsTable = "questions" + stringFilter;
    final String takenTable = 'takenon' + stringFilter;
    print(table);
    final url =
        'https://crr-coe.firebaseio.com/quiz/$table.json?auth=$authToken';
    final takenUrl =
        'https://crr-coe.firebaseio.com/taken/$takenTable.json?auth=$authToken';
    print(takenTable);
    try {
      final response = await http.get(url);
      final takenResponse = await http.get(takenUrl);
      final takenExtractedData =
          json.decode(takenResponse.body) as Map<String, dynamic>;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(takenExtractedData);
      if (extractedData == null) {
        print('returning');
        return;
      }
      List takenSubjectList = [];
      takenExtractedData.forEach((sub, data) {
        data.forEach((id, takenValue) {
          takenValue.forEach((id, value) {
            print(id);
            print('id');
            if (details.rno.toString() + 'r' == id && value == 0) {
              takenSubjectList.add(sub);
            }
          });
        });
      });

      extractedData.forEach((id, data) {
        if (id != questionsTable) {
          int min;
          int hr;
          final DateTime time = DateTime.parse(data['dateTime']);

          if (time.minute + 20 > 60) {
            min = 20 - (60 - time.minute);
            hr = time.hour + 1;
          } else {
            min = time.minute + 20;
            hr = time.hour;
          }
          final DateTime afterTime =
              DateTime(time.year, time.month, time.day, hr, min);
          print(DateFormat.Hm().format(time));
          print(DateFormat.Hm().format(afterTime));
          if (DateTime.now().isBefore(afterTime) &&
              DateTime.now().isAfter(time)) {
            subject.add(data['subject']);
          }
        }
      });
      print('takensub');
      print(takenSubjectList);
      List finalSubjectList = [];
      takenSubjectList.forEach((i) {
        subject.forEach((j) {
          if (i == j) {
            finalSubjectList.add(i);
          }
        });
      });

      print(finalSubjectList);
      print('object');
      if (finalSubjectList.length != 0) {
        extractedData.forEach((id, data) {
          if (id == questionsTable) {
            data.forEach((qid, qdata) {
              qdata.forEach((subid, ques) {
                for (var i = 0; i < finalSubjectList.length; i++) {
                  if (subid == finalSubjectList[i]) {
                    _items[subid] = ques;
                  }
                }
              });
            });
          }
        });
      } else {
        _items = {};
      }
      print(_items.length);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchQuizForKey(Student details) async {
    print('ommmm');
    List subject = [];

    // final filterString =
    //      'orderBy="userId"&equalTo="$authUserId"';
    _items = {};
    final String stringFilter = DateFormat.y().format(DateTime.now()) +
        '_' +
        DateFormat.M().format(DateTime.now()) +
        '_' +
        DateFormat.d().format(DateTime.now()) +
        details.department +
        details.year.toString();
    final String table = 'quizon' + stringFilter;
    final String questionsTable = "questions" + stringFilter;
    final String takenTable = 'takenon' + stringFilter;
    print(table);
    final url =
        'https://crr-coe.firebaseio.com/quiz/$table.json?auth=$authToken';
    // final takenUrl =
    //     'https://crr-coe.firebaseio.com/taken/$takenTable.json?auth=$authToken';
    print(takenTable);
    try {
      final response = await http.get(url);
      // final takenResponse = await http.get(takenUrl);
      // final takenExtractedData =
      //     json.decode(takenResponse.body) as Map<String, dynamic>;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(takenExtractedData);
      if (extractedData == null) {
        print('returning');
        return;
      }
      // List takenSubjectList = [];
      // takenExtractedData.forEach((sub, data) {
      //   data.forEach((id, takenValue) {
      //     takenValue.forEach((id, value) {
      //       print(id);
      //       print('id');
      //       if (details.rno.toString() + 'r' == id && value == 0) {
      //         takenSubjectList.add(sub);
      //       }
      //     });
      //   });
      // });

      extractedData.forEach((id, data) {
        if (id != questionsTable) {
          final DateTime time = DateTime.parse(data['dateTime']);
          date = time;

          final DateTime afterTime = DateTime(
              time.year, time.month, time.day, time.hour + 1, time.minute);

          if (DateTime.now().isAfter(afterTime)) {
            subject.add(data['subject']);
          }
        }
        if (id == questionsTable) {
          data.forEach((qid, qdata) {
            qdata.forEach((subid, ques) {
              if (subject.contains(subid)) _items[subid] = ques;
            });
          });
        }
      });

      print(_items.length);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchQuizForNotifications(Student details) async {
    print('ssdsdswdsdsd');
    _quizDetailsForNotifications = [];

    // final filterString =
    //      'orderBy="userId"&equalTo="$authUserId"';
    _items = {};
    final String stringFilter = DateFormat.y().format(DateTime.now()) +
        '_' +
        DateFormat.M().format(DateTime.now()) +
        '_' +
        DateFormat.d().format(DateTime.now()) +
        details.department +
        details.year.toString();
    final String table = 'quizon' + stringFilter;
    final String questionsTable = "questions" + stringFilter;

    final url =
        'https://crr-coe.firebaseio.com/quiz/$table.json?auth=$authToken';

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        print('returning');
        return;
      }

      extractedData.forEach((id, data) {
        if (id != questionsTable) {
          _quizDetailsForNotifications.add(QuizClass(
              dateTime:DateTime.parse(data['dateTime']) ,
              department: data['department'],
              year: data['year'],
              subject: data['subject'],
              noOfQuestions: null));
        }
      });
      print(quizDetailsForNotifications);
    } catch (error) {
      throw (error);
    }
  }
}
