import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/student_class.dart';
import '../providers/student_provider.dart';

class StudentEntryScreen extends StatefulWidget {
  static const routeName = '/add-student';

  @override
  _StudentEntryScreenState createState() => _StudentEntryScreenState();
}

class _StudentEntryScreenState extends State<StudentEntryScreen> {
  final _nameFocusNode = FocusNode();
  final _departmentFocusNode = FocusNode();

  final _yearFocusNode = FocusNode();
  final _sectionFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _newStudent = Student(
      id: null,
      rno: 0,
      name: '',
      department: '',
      year: 0,
      section: '',
      address: '');
  var _initValues = {
    'id': '',
    'rno': '',
    'name': '',
    'department': '',
    'year': '',
    'section': '',
    'address': '',
  };

  var _isLoading = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _departmentFocusNode.dispose();
    _yearFocusNode.dispose();
    _sectionFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    
    if (_newStudent != null) {
      try {
        await Provider.of<Students>(context, listen: false)
            .addStudent(_newStudent);
      } catch (error) {
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Student added'),
        content: Text('Do you want to add another one.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['rno'],
                      decoration: InputDecoration(labelText: 'Roll No'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_nameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid rno.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a valid rno';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: int.parse(value),
                            name: _newStudent.name,
                            department: _newStudent.department,
                            year: _newStudent.year,
                            section: _newStudent.section,
                            address: _newStudent.address);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      focusNode: _nameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_departmentFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: _newStudent.rno,
                            name: value,
                            department: _newStudent.department,
                            year: _newStudent.year,
                            section: _newStudent.section,
                            address: _newStudent.address);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['department'],
                      decoration: InputDecoration(labelText: 'Department'),
                      focusNode: _departmentFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_yearFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Department.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: _newStudent.rno,
                            name: _newStudent.name,
                            department: value,
                            year: _newStudent.year,
                            section: _newStudent.section,
                            address: _newStudent.address);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['year'],
                      decoration: InputDecoration(labelText: 'Year'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _yearFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_sectionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid year.';
                        }
                        if (double.parse(value) <= 0 ||
                            double.parse(value) >= 5) {
                          return 'Please enter a valid rno';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: _newStudent.rno,
                            name: _newStudent.name,
                            department: _newStudent.department,
                            year: int.parse(value),
                            section: _newStudent.section,
                            address: _newStudent.address);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['section'],
                      decoration: InputDecoration(labelText: 'Section'),
                      focusNode: _sectionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Department.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: _newStudent.rno,
                            name: _newStudent.name,
                            department: _newStudent.department,
                            year: _newStudent.year,
                            section: value,address: _newStudent.address);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['address'],
                      decoration: InputDecoration(labelText: 'Address'),
                      focusNode: _addressFocusNode,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Address.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newStudent = Student(
                            id: _newStudent.id,
                            rno: _newStudent.rno,
                            name: _newStudent.name,
                            department: _newStudent.department,
                            year: _newStudent.year,
                            section: _newStudent.section,
                            address: value,
                            );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text('Submit'),
                      onPressed: _saveForm,
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
