import 'package:flutter/material.dart';


import '../screens/tabs_screen_students.dart';
import '../screens/staff_home.dart';
import '../screens/subjects_key_overview.dart';
import '../screens/quiz_entry_screen.dart';
import '../quiz/quizhome.dart';
import '../screens/year_for_result.dart';
import '../screens/attendance_for_student.dart';
import '../screens/attendance_options.dart';

class NavigationModel {
  String studentTitle;
  String staffTitile;
  IconData icon;
  String studentRoute;
  String staffRoute;
  NavigationModel({this.studentTitle,this.staffTitile, this.icon,this.studentRoute,this.staffRoute});
}

List<NavigationModel> navigationItems = [
  NavigationModel(studentTitle: "Home",staffTitile: "Home", icon: Icons.insert_chart,studentRoute:Home.routeName,staffRoute: StaffHome.routeName ),
  NavigationModel(studentTitle: "Key", icon: Icons.error,staffTitile: "Results",studentRoute:KeyHomePage.routName,staffRoute: YearForResult.routName ),
  NavigationModel(studentTitle: "Attendance", icon: Icons.border_color,staffTitile: "Attendance",studentRoute: AttendanceForStudent.routeName,staffRoute: AttendanceOptions.routName),
  NavigationModel(studentTitle: "Quiz", icon: Icons.group_work,staffTitile: "Set a quiz",studentRoute: QuizHomePage.routName,staffRoute: QuizDetailsEntryScreen.routeName),
 
];