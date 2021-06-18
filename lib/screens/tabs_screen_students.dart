import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/drawer/collapsing_navigation_drawer_widget.dart';
import './student_home_screen.dart';
import './display_announcements.dart';
import './quiz-notifications.dart';
class Home extends StatefulWidget {
  static const routeName='/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      // initialIndex: 0,
      child: Scaffold(
        drawer: CollapsingNavigationDrawer(),
        appBar: AppBar(
          
          title: Text('C R Reddy College Of Engineering'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.home,
                ),
                text: 'Home',
              ),
              Tab(
                icon: Icon(
                  Icons.notifications,
                ),
                text: 'Announcemnts',
              ),
               Tab(
                icon: Icon(
                  Icons.question_answer,
                ),
                text: 'Quiz Notifications',
              ),
              
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            StudentHome(),
            AnnouncementsScreen(),
            QuizesAnnouncementsScreen(),
          ],
        ),
      ),
    );
  }
}
