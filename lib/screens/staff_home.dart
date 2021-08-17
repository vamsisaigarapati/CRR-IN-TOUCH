import 'package:flutter/material.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import 'package:intl/intl.dart';
import '../modals/quiz.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_entry_provider.dart';
import './question_entry_screen.dart';
import '../providers/student_provider.dart';

class QuizDetailsEntryScreen extends StatefulWidget {
  static const routeName = 'quiz-entry';
  @override
  _QuizDetailsEntryScreenState createState() => _QuizDetailsEntryScreenState();
}

class _QuizDetailsEntryScreenState extends State<QuizDetailsEntryScreen> {
  final _subjectFocusNode = FocusNode();
  final _noOfQuestionsFocusNode = FocusNode();

  final _departmentFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectFocusNode.dispose();
    _noOfQuestionsFocusNode.dispose();
    _departmentFocusNode.dispose();
    super.dispose();
  }

  var i = 0;
  var j = 0;
  var _newDetails = QuizClass(
      dateTime: DateTime.now(),
      department: '',
      year: 0,
      subject: '',
      noOfQuestions: 0);

  DateTime _submittedDate;
  TimeOfDay _submittedTime;
  var _isLoading = false;
  void _quizTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _submittedTime = pickedTime;
        final now = new DateTime.now();
        final DateTime finalDateAndTime = DateTime(
            _submittedDate.year,
            _submittedDate.month,
            _submittedDate.day,
            pickedTime.hour,
            pickedTime.minute);
        _newDetails = QuizClass(
            dateTime: finalDateAndTime,
            department: _newDetails.department,
            year: _newDetails.year,
            subject: _newDetails.subject,
            noOfQuestions: _newDetails.noOfQuestions);
      });
    });
  }

  void _presentDatePicker() {
    print("checking merge possibility")
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _submittedDate = pickedDate;
        _newDetails = QuizClass(
            dateTime: pickedDate,
            department: _newDetails.department,
            year: _newDetails.year,
            subject: _newDetails.subject,
            noOfQuestions: _newDetails.noOfQuestions);
      });
    });
  }

  int y = 0;
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_newDetails != null) {
      try {
        await Provider.of<Students>(context)
            .fetchStudentsOnDeptAndYear(_newDetails);
        await Provider.of<QuizEntry>(context, listen: false)
            .addQuizEntry(_newDetails);
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
    }

    setState(() {
      _isLoading = false;
    });
    if (y == 1) {
      Navigator.of(context).pushReplacementNamed('/staff-home');
    } else {
      Navigator.of(context).pushReplacementNamed(QuestionEntryScreen.routeName,
          arguments: _newDetails);
    }
  }

  int yearDropValue = 1;
  String departmentDropValue = 'IT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CollapsingNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(_submittedDate == null
                                ? 'NO date choosen'
                                : 'Picked Date:  ${DateFormat.yMd().format(_submittedDate)}'),
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
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(_submittedTime == null
                                ? 'NO Time choosen'
                                : 'Picked Time:  ${_submittedTime.format(context)}'),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              'Pick Time to Take Quiz',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _quizTimePicker,
                          )
                        ],
                      ),
                    ),
                    // TextFormField(
                    //   initialValue: '',
                    //   decoration: InputDecoration(labelText: 'Studying Year'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context)
                    //         .requestFocus(_departmentFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter Year of Studying.';
                    //     }
                    //     if (double.tryParse(value) == null) {
                    //       return 'Please enter a valid Year.';
                    //     }
                    //     if (double.parse(value) <= 0 ||
                    //         double.parse(value) >= 5) {
                    //       return 'Please enter a number less than or equal to 4.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _newDetails = QuizClass(
                    //         dateTime: _newDetails.dateTime,
                    //         department: _newDetails.department,
                    //         year: int.parse(value),
                    //         subject: _newDetails.subject,
                    //         noOfQuestions: _newDetails.noOfQuestions);
                    //   },
                    // ),
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
                              _newDetails = QuizClass(
                                  dateTime: _newDetails.dateTime,
                                  department: _newDetails.department,
                                  year: newValue,
                                  subject: _newDetails.subject,
                                  noOfQuestions: _newDetails.noOfQuestions);
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
                              _newDetails = QuizClass(
                                  dateTime: _newDetails.dateTime,
                                  department: newValue,
                                  year: _newDetails.year,
                                  subject: _newDetails.subject,
                                  noOfQuestions: _newDetails.noOfQuestions);
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
                    TextFormField(
                      initialValue: '',
                      decoration: InputDecoration(labelText: 'Subject '),
                      textInputAction: TextInputAction.next,
                      focusNode: _subjectFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_noOfQuestionsFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a correct value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        value=value.split(" ").join('_');
                        _newDetails = QuizClass(
                            dateTime: _newDetails.dateTime,
                            department: _newDetails.department,
                            year: _newDetails.year,
                            subject: value,
                            noOfQuestions: _newDetails.noOfQuestions);
                      },
                    ),
                    TextFormField(
                      initialValue: '',
                      decoration: InputDecoration(labelText: 'No Of Questions'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter No of questions.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 1.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newDetails = QuizClass(
                            dateTime: _newDetails.dateTime,
                            department: _newDetails.department,
                            year: _newDetails.year,
                            subject: _newDetails.subject,
                            noOfQuestions: int.parse(value));
                      },
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
            ),
    );
  }
}
