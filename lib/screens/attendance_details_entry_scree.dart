import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/take_attendance.dart';
import '../providers/attendance.dart';
import 'package:provider/provider.dart';
class AttendanceDetailsEntryScreen extends StatefulWidget {
  static const routeName = 'attendance-entry';
  @override
  _AttendanceDetailsEntryScreenState createState() => _AttendanceDetailsEntryScreenState();
}

class _AttendanceDetailsEntryScreenState extends State<AttendanceDetailsEntryScreen> {
  final _subjectFocusNode = FocusNode();
  final _noOfQuestionsFocusNode = FocusNode();

  final _departmentFocusNode = FocusNode();


  @override
  void dispose() {
    _subjectFocusNode.dispose();
    _noOfQuestionsFocusNode.dispose();
    _departmentFocusNode.dispose();
    super.dispose();
  }

  var i = 0;
  var j = 0;



  var _isLoading = false;
  

  int y = 0;
  Future<void> _saveForm() async {
    
    
    setState(() {
      _isLoading = true;
    });

    
      try {
        await Provider.of<Attendance>(context)
            .fetchStudentsForAttendance(departmentDropValue, yearDropValue, section);
       
      } catch (error) {
        y = 1;
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      
    }

    setState(() {
      _isLoading = false;
    });
    if (y == 1) {
      Navigator.of(context).pushReplacementNamed('staff-home');
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => TakeAttenDace(departmentDropValue, yearDropValue, section, periodNo),
            ));
    }
  }

  int yearDropValue = 1;
  String departmentDropValue = 'IT';
  String periodNo='p1';
  String section ='A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ListView(
                  children: <Widget>[
                    
                    
                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Studying Year'),
                        SizedBox(width: 180),
                        DropdownButton<int>(
                          value: yearDropValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (int newValue) {
                            setState(() {
                              
                              i = 1;
                              yearDropValue = newValue;
                            });
                          },
                          items: <int>[1, 2, 3, 4]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Department'),
                        SizedBox(width: 180),
                        DropdownButton<String>(
                          value: departmentDropValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              
                              j = 1;
                              departmentDropValue = newValue;
                            });
                          },
                          items: <String>[
                            'IT',
                            'CSE',
                            'ECE',
                            'EEE',
                            'MECH',
                            'CIVIL'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Section'),
                        SizedBox(width: 180),
                        DropdownButton<String>(
                          value: section,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              
                              j = 1;
                              section = newValue;
                            });
                          },
                          items: <String>[
                            'A',
                            'B',
                            'C',
                            
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Period'),
                        SizedBox(width: 180),
                        DropdownButton<String>(
                          value: periodNo,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              
                              j = 1;
                              periodNo = newValue;
                            });
                          },
                          items: <String>[
                            'p1',
                            'p2',
                            'p3',
                            'p4',
                            'p5',
                            'p6',
                            'p7',
                            'p8'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    

                    FlatButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (i != 1 || j != 1) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title:
                                  Text('You didn\'t select department or year'),
                              content: Text('Please Select.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        } else {
                          _saveForm();
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            
    );
  }
}
