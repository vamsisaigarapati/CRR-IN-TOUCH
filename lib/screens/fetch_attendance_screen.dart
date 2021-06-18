import 'package:flutter/material.dart';
import './display_attendance.dart';
import 'package:intl/intl.dart';
import '../providers/attendance.dart';

import 'package:provider/provider.dart';


class FetchAttendanceDetailsEntryScreen extends StatefulWidget {
  static const routeName = 'fetch-attendance';
  @override
  _FetchAttendanceDetailsEntryScreenState createState() => _FetchAttendanceDetailsEntryScreenState();
}

class _FetchAttendanceDetailsEntryScreenState extends State<FetchAttendanceDetailsEntryScreen> {
 


  var i = 0;
  var j = 0;
 
  int yearDropValue = 1;
  DateTime submittedDate;
  String section="A";
  String department="IT";
  
  var _isLoading = false;


  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate:DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        submittedDate = pickedDate;
       
      });
    });
  }

  int y = 0;
  Future<void> _saveForm() async {
    
    setState(() {
      _isLoading = true;
    });

      try {
        print(department+yearDropValue.toString()+section+submittedDate.toString());
        print('yyyyy');
        await Provider.of<Attendance>(context, listen: false)
            .fetchAttendanceOnDate(department,yearDropValue,section,submittedDate);
      } catch (error) {
        y = 1;
        print('em');
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
      Navigator.of(context).pushReplacementNamed('/staff-home');
    } else {
      print('uuuu');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ShowAttendance(department,section,yearDropValue,Provider.of<Attendance>(context).periodsList),
            ));
    }
  }


  

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
             
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(submittedDate == null
                                ? 'NO date choosen'
                                : 'Picked Date:  ${DateFormat.yMd().format(submittedDate)}'),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              'choose date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          )
                        ],
                      ),
                    ),
                  
                    
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
                          value: department,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                             
                              department = newValue;
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

                    FlatButton(
                      child: Text('Submit'),
                      onPressed: () {
                    _saveForm();
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
