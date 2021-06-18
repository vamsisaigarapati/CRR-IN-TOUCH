import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';
import '../providers/auth.dart';
class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isInit = false;
  var _isLoading = false;
  bool isTeacher;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      isTeacher=Provider.of<Auth>(context).isTeacher;
      print(isTeacher);
      if(isTeacher){
        print('sds');
        Provider.of<Students>(context).fetchStaffDetails().then((_){
          setState(
          () {
            _isLoading = false;
          },
        );
        });
      }
      else{
        
        Provider.of<Students>(context).fetchUserDetails().then((_) {
        setState(
          () {
            _isLoading = false;
          },
        );
      });
      }
      
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  Widget buildRow(String head, var data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          head,
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(width: 100),
        Text(
          data.toString(),
          style: TextStyle(fontSize: 25),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    List profileData;
    if(isTeacher){
      profileData= Provider.of<Students>(context).staffItems;
    }
    else{
profileData = Provider.of<Students>(context).items;
    }
    
    return Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                          child: Container(
                height: 600,
                child: Stack(
                  
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: ClipPath(
                          clipBehavior: Clip.antiAlias,
                          child: Container(color: Colors.amber.withOpacity(0.8)),
                          clipper: GetClipper(),
                        ),
                      ),
                      Positioned(
                       height: 800,
                       width: 400,
                          top: MediaQuery.of(context).size.height / 7,
                         
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      
                                        color: Theme.of(context).accentColor,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://images.unsplash.com/photo-1545062990-4a95e8e4b96d?ixlib=rb-1.2.1&dpr=1&auto=format&fit=crop&w=416&h=312&q=60'),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10.0,
                                              color: Colors.deepPurple)
                                        ])),
                                Column(
                                  
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      // decoration: BoxDecoration(color: Colors.grey),
                                      child: DataTable(
                                      
                                        columns: [
                                        DataColumn(label: Text('')),
                                        DataColumn(label: Text(''))
                                      ], rows: [
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Name',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(profileData[0].name,
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                        if(!isTeacher)
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Roll NO',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(profileData[0].rno.toString(),
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                        if(isTeacher)
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Staff Id',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(profileData[0].sid.toString(),
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Department',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(profileData[0].department,
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                        if(!isTeacher)
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Year',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(
                                              profileData[0].year.toString()+'/'+'4',
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                        if(!isTeacher)
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Section',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo),
                                          )),
                                          DataCell(Text(profileData[0].section,
                                              style: TextStyle(fontSize: 20)))
                                        ]),
                                         if(!isTeacher)
                                        DataRow(cells: [
                                          DataCell(Text(
                                            'Address',
                                            style: TextStyle(fontSize: 22,color: Colors.indigo,fontStyle: FontStyle.italic),
                                          )),
                                          DataCell(Text(profileData[0].address,
                                              style: TextStyle(fontSize: 20,)))
                                        ])
                                      ]),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
              ),
            ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
