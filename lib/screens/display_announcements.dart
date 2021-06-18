import 'package:flutter/material.dart';
import '../modals/announcement.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/announcement_provider.dart';
import 'package:intl/intl.dart';
class AnnouncementsScreen extends StatefulWidget {
  static const routeName = 'announcements-screen';
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Announcement> _totalAnnoouncements = [];

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<Students>(context, listen: false).fetchUserDetails();
    await Provider.of<AnnouncementProvider>(context, listen: false)
        .fetchAnnouncements(
            Provider.of<Students>(context, listen: false).items[0])
        .then((_) {
      _totalAnnoouncements =
          Provider.of<AnnouncementProvider>(context, listen: false).items;
    });
  }

  Widget buildEachAnnouncement(Announcement data) {
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
                      data.uploader.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  Text(
                DateFormat.yMEd().format(data.time) +
                    '\n' +
                    'at ' +
                    DateFormat.Hm().format(data.time),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,
                fontFamily: 'Times new Roman',
                ),
              ),
                // Text(
                //   data.uploader.name,
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // )
              ]),
              SizedBox(
                  height: 10,
              ),
              Text(data.announcement)
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
          onRefresh: ()=>_refreshFeed(context),
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
