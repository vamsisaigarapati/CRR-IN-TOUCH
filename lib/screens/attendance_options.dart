import 'package:flutter/material.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import './attendance_details_entry_scree.dart';
import 'fetch_attendance_screen.dart';
class AttendanceOptions extends StatelessWidget {
static const routName='attendance-options';

Widget customcard(String route,BuildContext context,String name) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: Container(
        height: 100,
        child: InkWell(
          onTap: () {
             Navigator.of(context).pushNamed(route);
          },
          child: Material(
            color: Colors.amber,
            elevation: 10.0,
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: "Quando",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            drawer: CollapsingNavigationDrawer(),
            appBar: AppBar(
              title: Text(
                "Quiz",
                style: TextStyle(
                  fontFamily: "Quando",
                ),
              ),
            ),
            body:ListView(children: <Widget>[
              SizedBox(height: 20,),
              customcard(FetchAttendanceDetailsEntryScreen.routeName,context,'Attendance on A Date'),
              SizedBox(height: 100,),
              customcard(AttendanceDetailsEntryScreen.routeName,context,'Take Attendance'),
            
            ],)
          );
  }
}