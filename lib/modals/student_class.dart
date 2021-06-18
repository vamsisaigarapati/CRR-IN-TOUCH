import 'package:flutter/foundation.dart';

class Student {
  final String id;
  final int rno;
  final String name;
  final String department;
  final int year;
  final String section;
  bool isTeacher;
  final String address;

  Student({
    @required this.id,
    @required this.rno,
    @required this.name,
    @required this.department,
    @required this.year,
    @required this.section,
    @required this.address,
    this.isTeacher=false,
  });
}
