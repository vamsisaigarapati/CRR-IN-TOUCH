import 'package:flutter/material.dart';
import '../modals/quiz.dart';

import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/quiz_provider.dart';
import 'package:intl/intl.dart';

class QuizesAnnouncementsScreen extends StatefulWidget {
  static const routeName = 'quizes-announcements-screen';
  @override
  _QuizesAnnouncementsScreenState createState() => _QuizesAnnouncementsScreenState();
}

class _QuizesAnnouncementsScreenState extends State<QuizesAnnouncementsScreen> {
  List<QuizClass> _totalAnnoouncements = [];

  Future<void> _refreshFeed(BuildContext context) async {
    print('azsazasa');
    await Provider.of<Students>(context, listen: false).fetchUserDetails();
    await Provider.of<QuizProvider>(context, listen: false)
        .fetchQuizForNotifications(
            Provider.of<Students>(context, listen: false).items[0])
        .then((_) {
      _totalAnnoouncements = Provider.of<QuizProvider>(context, listen: false)
          .quizDetailsForNotifications;
    });
  }

  Widget buildEachAnnouncement(QuizClass data) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                // CircleAvatar(
                //   backgroundColor: Theme.of(context).primaryColor,
                //   child: Padding(
                //     padding: EdgeInsets.all(5),
                //     child: FittedBox(
                //       child: Text('A'),
                //     ),
                //   ),
                // ),
                Chip(
                  label: Text(
                    data.subject,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryTextTheme.title.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                Spacer(),

                // Text(
                //   data.uploader.name,
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // )
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                Text(
                  'Starts at',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Times new Roman',
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat.yMEd().format(data.dateTime) +
                      '\n' +
                      'at ' +
                      DateFormat.Hm().format(data.dateTime),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Times new Roman',
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                Text(
                  'ends at',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Times new Roman',
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat.yMEd().format(data.dateTime) +
                      '\n' +
                      'at ' +
                      DateFormat.Hm()
                          .format(data.dateTime.add(Duration(minutes: 20))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Times new Roman',
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                Text(
                  'Key will Available at',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Times new Roman',
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat.yMEd().format(data.dateTime) +
                      '\n' +
                      'at ' +
                      DateFormat.Hm()
                          .format(data.dateTime.add(Duration(hours: 1))),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Times new Roman',
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
        body: RefreshIndicator(
          onRefresh:()=> _refreshFeed(context),
                  child: FutureBuilder(
            future: _refreshFeed(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                          itemBuilder: (_, i) {
                            return buildEachAnnouncement(_totalAnnoouncements[
                                _totalAnnoouncements.length - i - 1]);
                          },
                          itemCount: _totalAnnoouncements.length,
                        ),
                      
          ),
        ));
  }
}
