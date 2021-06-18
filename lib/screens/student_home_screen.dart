import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../modals/feed_class.dart';
import '../providers/feed_provider.dart';
import 'package:intl/intl.dart';

class StudentHome extends StatefulWidget {
  static const routeName = 'student-home';
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  List<Feed> _totalFeed = [];

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<FeedProvider>(context,listen: false).fetchNewsFeed().then((_) {
      _totalFeed = Provider.of<FeedProvider>(context,listen: false).items;
    });
  }

 

  Widget buildEachFeed(Feed data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: ListTile(
              title: Text(data.uploader.name),
              subtitle: Text(data.uploader.department),
              trailing: Text(
                DateFormat.yMEd().format(data.time) +
                    '\n' +
                    'at ' +
                    DateFormat.Hm().format(data.time),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  data.description,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                )),
          ),
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/feed_placeholder.jpg'),
                  image:NetworkImage( data.imageUrl),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
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
                      :  ListView.builder(
                              itemBuilder: (_, i) {
                                return buildEachFeed(_totalFeed[_totalFeed.length-i-1]);
                              },
                              itemCount: _totalFeed.length,
                            ),
                      
  ),
        ));
  }
}
