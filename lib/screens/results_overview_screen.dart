import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modals/staff_class.dart';
import './each_result_screen.dart';

import '../drawer/collapsing_navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';


import '../providers/result_provider.dart';

class ResultOverView extends StatefulWidget {
  static const routName = 'result-overview';
final int year;
  ResultOverView({@required this.year});
  
  @override
  _ResultOverViewState createState() => _ResultOverViewState();
}

class _ResultOverViewState extends State<ResultOverView> {
  var _isInit = false;
  var _isLoading = false;
  List<Staff> details = [];
  Map totalResult = {};
  List subjects = [];
  List res = [];
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<Students>(context).fetchStaffDetails().then((_) {
        details = Provider.of<Students>(context).staffItems;
        Provider.of<ResultProvider>(context).fetchResult(details[0],widget.year).then((_) {
          totalResult=Provider.of<ResultProvider>(context).items;

          totalResult.forEach((sub, ques) {
            print(ques.length);
            print(ques);

            subjects.add(sub);
            res.add(ques);
          });
          setState(
            () {
              _isLoading = false;
            },
          );
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  Widget customcard(String subName, Map result) {
    print('........');
    print(subName);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: Container(
        height: 100,
        child: InkWell(
          onTap: () {
             Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => EachSubjectResult(result: result)));
            print(result);
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
                        subName,
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
    print(subjects);
    print(res);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return _isLoading
        ? Scaffold(
          appBar: AppBar(
              title: Text(
                "Result",
                style: TextStyle(
                  fontFamily: "Quando",
                ),
              ),
            ),
          body: Center(child: CircularProgressIndicator(),))
        : Scaffold(
            drawer: CollapsingNavigationDrawer(),
            appBar: AppBar(
              title: Text(
                "Result",
                style: TextStyle(
                  fontFamily: "Quando",
                ),
              ),
            ),
            body: res.isEmpty
                ? Center(
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    
                      children: <Widget>[
                        Text(
                          'No results yet',
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
                )
                : ListView.builder(
                    itemCount: res.length,
                    itemBuilder: (_, i) {
                      print(i);
                      print("kkkkkkk");
                      return customcard(subjects[i], res[i]);
                    },
                    // children: <Widget>[
                    //   customcard("Python"),
                    // ],
                  ),
          );
  }
}
