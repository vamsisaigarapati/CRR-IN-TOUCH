import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import '../modals/student_class.dart';
import '../modals/quiz.dart';
import '../modals/staff_class.dart';
class Students with ChangeNotifier {
  List<Student> _items = [
    
  ];
List<Staff> _staffItems = [
    
  ];
 
  final String authToken;
  final String authUserId;
  Students(this.authToken, this.authUserId, this._items);
  List<Student> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }
List<Staff> get staffItems{
    return [..._staffItems];
}
  // Student findById(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchUserDetails() async {
   
    final filterString = 'orderBy="userId"&equalTo="$authUserId"';
    final url =
        'https://crr-coe.firebaseio.com/students.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final List<Student> loadedStudent = [];

      extractedData.forEach((studId, studData) {
        loadedStudent.add(Student(
            id: studId,
            rno: studData['rno'],
            name: studData['name'],
            department: studData['department'],
            year: studData['year'],
            section: studData['section'],
            address: studData['address']));
      });
      _items = loadedStudent;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
  Future<void> fetchStaffDetails() async {
   
    final filterString = 'orderBy="userId"&equalTo="$authUserId"';
    final url =
        'https://crr-coe.firebaseio.com/staff.json?auth=$authToken&$filterString';
    try {
      
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
          print(extractedData);
      final List<Staff> loadedStaff = [];

      extractedData.forEach((staffId, staffData) {
        loadedStaff.add(Staff(id: staffData['userId'], sid: staffData['sid'], name: staffData['name'], department: staffData['department']));
      });
      _staffItems = loadedStaff;
      
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addStudent(Student student) async {
    final url = 'https://crr-coe.firebaseio.com/students.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'rno': student.rno,
          'name': student.name,
          'department': student.department,
          'year': student.year,
          'section': student.section,
          'address': student.address,
          'isTeacher': student.isTeacher,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchStudentsOnDeptAndYear(QuizClass quiz) async {
    print('1111');
    List rno = [];
    final String stringFilter = DateFormat.y().format(quiz.dateTime) +
        '_' +
        DateFormat.M().format(quiz.dateTime) +
        '_' +
        DateFormat.d().format(quiz.dateTime) +
        quiz.department +
        quiz.year.toString();
    final String resultsTable = 'resultson' + stringFilter;
    final String quizTakenTable='takenon'+stringFilter;
    final departmentFilterString =
        'orderBy="department"&equalTo="${quiz.department}"';
    final detailsUrl =
        'https://crr-coe.firebaseio.com/students.json?auth=$authToken&$departmentFilterString';
        print(departmentFilterString);
    final resultsUrl =
        'https://crr-coe.firebaseio.com/results/$resultsTable/${quiz.subject}.json?auth=$authToken';
    final quizTakenUrl='https://crr-coe.firebaseio.com/taken/$quizTakenTable/${quiz.subject}.json?auth=$authToken';
    try {
      final response = await http.get(detailsUrl);

      final extractedData = await json.decode(response.body);
      extractedData.forEach((stuId, sData) {
        if (sData['year'] == quiz.year) {
          rno.add(sData['rno']);
        }

      });
      Map resultTemp={};
      Map takenTemp={};
      rno.forEach((i){
        resultTemp[i.toString()+'r']=0;
        takenTemp[i.toString()+'r']=0;
      });
        
        
        print('onnnnnnn');
        
        await http.post(
          resultsUrl,
          body: json.encode(resultTemp),
        );
        await http.post(
          quizTakenUrl,
          body: json.encode(resultTemp),
        );
      
    } catch (error) {
      throw (error);
    }
  }


}
