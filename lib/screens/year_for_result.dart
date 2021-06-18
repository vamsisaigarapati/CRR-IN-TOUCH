import 'package:flutter/material.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import './results_overview_screen.dart';
class YearForResult extends StatelessWidget {
static const routName='yera-for-result';

Widget customcard(int year,BuildContext context) {
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
          builder: (context) => ResultOverView(year: year)
        ));
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
                        'year'+': '+year.toString(),
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
              customcard(1,context),
              customcard(2,context),
              customcard(3,context),
              customcard(4,context),
            ],)
          );
  }
}