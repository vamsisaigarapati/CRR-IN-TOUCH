import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/feed_class.dart';
import '../providers/feed_provider.dart';
import 'package:intl/intl.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import './feed_upload.dart';
import './making_announcement.dart';

class StaffHome extends StatefulWidget {
  static const routeName = '/staff-home';
  @override
  _StaffHomeState createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  List<Feed> _totalFeed = [];

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<FeedProvider>(context,listen: false).fetchNewsFeed().then((_) {
      print("hellllo Namasthe");
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
    return Scaffold(
       drawer: CollapsingNavigationDrawer(),
        appBar: AppBar(
          title: Text('Feed'),
        ),
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
        ),
             floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '+',
                  onPressed: () {
                    Navigator.of(context).pushNamed(MakeAnAnnouncementScreen.routeName);
                  },
                  child: Icon(Icons.add_alert),
                ),
                FloatingActionButton(
                  heroTag: '++',
                  onPressed: () {
                    Navigator.of(context).pushNamed(FeedUploadScreen.routeName);
                  },
                  child: Icon(Icons.add),
                )
              ],
            ),
          )
        );
  }
}
