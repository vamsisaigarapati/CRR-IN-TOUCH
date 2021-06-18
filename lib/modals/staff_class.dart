import 'package:flutter/foundation.dart';

class Staff {
  final String id;
  final int sid;
  final String name;
  final String department;

  bool isTeacher;
  

  Staff({
    @required this.id,
    @required this.sid,
    @required this.name,
    @required this.department,
   
    this.isTeacher = true,
  });
}
