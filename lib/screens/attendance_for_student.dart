import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/attendance.dart';
import '../providers/student_provider.dart';

class AttendanceForStudent extends StatefulWidget {
  static const routeName = 'attendance-for-student';
  @override
  _AttendanceForStudentState createState() => _AttendanceForStudentState();
}

class _AttendanceForStudentState extends State<AttendanceForStudent> {
  var _isInit = false;
  var _isLoading = false;
  List profileData;
  double percentage;
  int totalPeriodsAttended;
  int totalPeriodsHeld;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );

      Provider.of<Students>(context).fetchUserDetails().then((_) {
        profileData = Provider.of<Students>(context).items;
        Provider.of<Attendance>(context)
            .fetchStudentAttendanceInaMonth(profileData[0])
            .then((_) {
          percentage = Provider.of<Attendance>(context).percentage;
          totalPeriodsAttended =
              Provider.of<Attendance>(context).presenceCounter;
          totalPeriodsHeld =
              Provider.of<Attendance>(context).totalPeriodsInAMonth.length;
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total Periods held in this Month  ' +
                      totalPeriodsHeld.toString(),
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontFamily: "Quando",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Total Periods you attended in this Month  ' +
                      totalPeriodsAttended.toString(),
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontFamily: "Quando",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  percentage.toString() + '%',
                  style: TextStyle(
                    fontSize: 70,
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Quando",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )),
    );
  }
}
