import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/attendance.dart';

class ShowAttendance extends StatefulWidget {
  final List attendance;
  final int year;
  final String department;
  final String section;

  ShowAttendance(this.department, this.section, this.year, this.attendance);
  static const routeName = 'show-attendance';

  @override
  _ShowAttendanceState createState() => _ShowAttendanceState();
}

class _ShowAttendanceState extends State<ShowAttendance> {
  var _isInit = false;
  var _isLoading = false;
  List details = [];
  List<DataRow> rows = [];
  List<DataCell> datacells = [];
  List<DataColumn> cols = [];
  Map temp = {};
  List periods = [];

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      if(widget.attendance.isEmpty){
        setState(
        () {
          _isLoading = false;
        },
      );
      }
      try {
        Provider.of<Attendance>(context)
            .fetchStudentsForAttendance(
                widget.department, widget.year, widget.section)
            .then((_) {
          details = Provider.of<Attendance>(context).items;

          widget.attendance.forEach((period) {
            period.forEach((name, list) {
              temp[name] = list;
              periods.add(name);
            });
          });

          cols.add(DataColumn(label: Text('rno')));
          periods.forEach((name) {
            cols.add(DataColumn(label: Text(name)));
          });

          details.forEach((rno) {
            datacells = [];
            datacells.add(DataCell(Text(rno.toString())));
            periods.forEach((name) {
              if (temp[name].contains(rno.toString())) {
                datacells.add(DataCell(Text('P')));
              } else {
                datacells.add(DataCell(Text('A')));
              }
            });
            rows.add(DataRow(cells: datacells));
          });
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        print('ttttt');
        showDialog(
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
          ? Center(child: CircularProgressIndicator())
          :widget.attendance.isEmpty?Center(
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    
                      children: <Widget>[
                        Text(
                          'No Attedance on this day\nMay be a Holiday',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            height: 300,
                            child: Image.asset(
                              'assets/images/waiting.png',
                              fit: BoxFit.cover,
                            ))
                      ],
                    ),
                ): SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      // decoration: BoxDecoration(color: Colors.grey),
                      child: DataTable(columns: cols, rows: rows),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
