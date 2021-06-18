import 'dart:convert';
import 'package:flutter/material.dart';
import '../modals/student_class.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Attendance with ChangeNotifier {
  List _periodsList = [];
  List _items = [];
  double _percentage = 0.0;
   int presenceCounter;
    List totalPeriodsInAMonth;
  // var _showFavoritesOnly = false;
  final String authToken;
  final String authUserId;
  Attendance(this.authToken, this.authUserId);
  List get items {
    return [..._items];
  }

  double get percentage {
    return _percentage;
  }

  List get periodsList {
    return [..._periodsList];
  }

  Future<void> fetchStudentsForAttendance(
      String department, int year, String section) async {
    final filterString = 'orderBy="department"&equalTo="$department"';
    final url =
        'https://crr-coe.firebaseio.com/students.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;

      List rno = [];
      extractedData.forEach((studId, studData) {
        if (studData['section'] == section && studData['year'] == year) {
          rno.add(studData['rno']);
        }
      });
      print(rno);
      _items = rno;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchStudentAttendanceInaMonth(Student details) async {
    final String classTable =
        details.department + details.year.toString() + details.section;
    final String attendanceyear = DateFormat.y().format(DateTime.now());
    final String attendanceMonth = DateFormat.M().format(DateTime.now());
    print(classTable);
    final url =
        'https://crr-coe.firebaseio.com/attendance/$attendanceyear/$attendanceMonth.json?auth=$authToken';
    final response = await http.get(url);

     totalPeriodsInAMonth = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    extractedData.forEach((date, map) {
      map.forEach((sec, rmap) {
        if (classTable == sec) {
          rmap.forEach((id, att) {
            att.forEach((period, list) {
              totalPeriodsInAMonth.add(list);
            });
          });
        }
      });
    });
    print(totalPeriodsInAMonth);
    presenceCounter = 0;
    totalPeriodsInAMonth.forEach((i) {
      if (i.contains(details.rno.toString())) {
        presenceCounter++;
      }
    });
    print(presenceCounter);
    _percentage = (presenceCounter / totalPeriodsInAMonth.length) * 100;
  }

  Future<void> fetchAttendanceOnDate(
      String department, int year, String section, DateTime date) async {
    _periodsList = [];
    final String attendanceyear = DateFormat.y().format(date);
    final String attendanceMonth = DateFormat.M().format(date);
    final String attendanceDate = DateFormat.d().format(date);
    final String table = department + year.toString() + section;
    print(attendanceDate);
    print(table);
    final url =
        'https://crr-coe.firebaseio.com/attendance/$attendanceyear/$attendanceMonth.json?auth=$authToken';
    print(attendanceMonth);
    print('xdsff');
    int r = 0;
    final response = await http.get(url);
    print('kop');
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    extractedData.forEach((dt, map) {
      print(dt);
      if (dt == attendanceDate) {
        r = 1;
        map.forEach((sec, rmap) {
          if (sec == table) {
            rmap.forEach((id, period) {
              _periodsList.add(period);
            });
          }
        });
      }
    });
    if (r == 0) {
      _periodsList = [];
    }
    print(_periodsList);
  }

  Future<void> addAttendance(String department, int year, String section,
      String period, Map attendance) async {
    final String attendanceyear = DateFormat.y().format(DateTime.now());
    final String attendanceMonth = DateFormat.M().format(DateTime.now());
    final String attendanceDate = DateFormat.d().format(DateTime.now());
    final String table = department + year.toString() + section;
    final url =
        'https://crr-coe.firebaseio.com/attendance/$attendanceyear/$attendanceMonth/$attendanceDate/$table.json?auth=$authToken';
    List att = [];
    attendance.forEach((rno, value) {
      if (value) {
        att.add(rno);
      }
    });
    if(att.isEmpty){
      att=[0];
       final response = await http.post(
      url,
      body: json.encode({period: att}),
    );
    }
    else{
 final response = await http.post(
      url,
      body: json.encode({period: att}),
    );
    }
   
    print('done');
  }
}
