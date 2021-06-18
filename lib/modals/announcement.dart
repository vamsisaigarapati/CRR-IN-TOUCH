import 'package:flutter/cupertino.dart';
import '../modals/staff_class.dart';

class Announcement {
  final String announcement;
  final int toStudentYear;
  final String toStudentSection;
  final Staff uploader;
  final DateTime time;
  Announcement(
      {@required this.announcement,
      @required this.toStudentYear,
      @required this.toStudentSection,
      @required this.uploader,
      @required this.time});
}
