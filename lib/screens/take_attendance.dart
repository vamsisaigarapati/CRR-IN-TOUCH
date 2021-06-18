import 'package:flutter/material.dart';
import '../providers/attendance.dart';
import 'package:provider/provider.dart';
class TakeAttenDace extends StatefulWidget {
  static const routName='take-attendance';
 final String department;
 final int year;
 final String section;
 final String period;
 TakeAttenDace(this.department,this.year,this.section,this.period);
  @override
  
  _TakeAttenDaceState createState() => _TakeAttenDaceState();
}


class _TakeAttenDaceState extends State<TakeAttenDace> {
  List details=[];
  bool _isInit=false;
   Map attendance={};
   bool _isLoading=false;

  @override
  void didChangeDependencies() {
    if(!_isInit){
details=Provider.of<Attendance>(context).items;
details.forEach((rno){
  attendance[rno.toString()]=false;
});
    }
    _isInit=true;
    super.didChangeDependencies();
  }

 
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
        appBar: AppBar(
          title: Text("Take Attendance"),
          actions: <Widget>[
             IconButton(
            icon: Icon(Icons.save),
           onPressed: () {
                        setState(() {
                          _isLoading=true;
                        });
                        Provider.of<Attendance>(context).addAttendance(widget.department,widget.year,widget.section,widget.period,attendance).then((_){
                            showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Attendance Submitted'),
            content: Text('Doe.'),
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
                        });
                      },
          ),
          ],

        ),
        body:_isLoading?Center(child: CircularProgressIndicator(),): 
        //  Column(children: <Widget>[
ListView.builder(
            itemCount: details.length,
            itemBuilder: (_,i){
              
              return CheckboxListTile(
        title: Text(details[i].toString()),
        value: attendance[details[i].toString()],
        
        onChanged: (bool value) {
          setState(() {
           
             attendance[details[i].toString()]= value;
          });
        },
      );
  
            }
          
          ),
        //    FlatButton(
        //               child: Text('Submit'),
        //               onPressed: () {
        //                 setState(() {
        //                   _isLoading=true;
        //                 });
        //                 Provider.of<Attendance>(context).addAttendance(widget.department,widget.year,widget.section,widget.period,attendance).then((_){
        //                     showDialog(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: Text('Attendance Submitted'),
        //     content: Text('Doe.'),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Okay'),
        //         onPressed: () {
        //           Navigator.of(context).pushReplacementNamed('/staff-home');
        //         },
        //       )
        //     ],
        //   ),
        // );
        //                 });
        //               },
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //               textColor: Theme.of(context).primaryColor,
        //             ),
        //  ],) 
        );
  }
}