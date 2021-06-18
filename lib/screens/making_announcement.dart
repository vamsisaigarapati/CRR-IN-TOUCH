import 'package:flutter/material.dart';
import '../modals/announcement.dart';

import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/student_provider.dart';

class MakeAnAnnouncementScreen extends StatefulWidget {
  static const routeName = 'make-an-announcement';
  @override
  _MakeAnAnnouncementScreenState createState() =>
      _MakeAnAnnouncementScreenState();
}

class _MakeAnAnnouncementScreenState extends State<MakeAnAnnouncementScreen> {
  final _announcementFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  @override
  void dispose() {
    _announcementFocusNode.dispose();

    super.dispose();
  }

  int y = 1;
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_newAnnouncement != null) {
      try {
        await Provider.of<Students>(context).fetchStaffDetails();
        _newAnnouncement = Announcement(
            announcement: _newAnnouncement.announcement,
            toStudentYear: _yearDropDownValue,
            toStudentSection: _section,
            uploader: Provider.of<Students>(context).staffItems[0],
            time: DateTime.now());
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .makeAnAnnouncement(_newAnnouncement);
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
                  Navigator.of(context).pushReplacementNamed('/staff-home');
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
    await showDialog(
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: (){return;},
              child: AlertDialog(
          title: Text(
              'You Made an Announcent to ${_newAnnouncement.uploader.department} ${_newAnnouncement.toStudentSection} students'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/staff-home');
              },
            )
          ],
        ),
      ),
    );
  }

  var _yearDropDownValue = 1;
  var _section = 'A';

  var _newAnnouncement = Announcement(
      announcement: "",
      toStudentYear: 1,
      toStudentSection: 'A',
      uploader: null,
      time: null);
  var _initialValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Announcement'),
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
                      initialValue: _initialValue,
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newAnnouncement = Announcement(
                            announcement: value,
                            toStudentYear: 1,
                            toStudentSection: 'A',
                            uploader: _newAnnouncement.uploader,
                            time: _newAnnouncement.time);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Studying Year'),
                        SizedBox(width: 180),
                        DropdownButton<int>(
                          value: _yearDropDownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (int newValue) {
                            setState(() {
                              _yearDropDownValue = newValue;
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
                        Text('Section'),
                        SizedBox(width: 180),
                        DropdownButton<String>(
                          value: _section,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _section = newValue;
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
                    SizedBox(
                      height: 20,
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
            ),
    );
  }
}
