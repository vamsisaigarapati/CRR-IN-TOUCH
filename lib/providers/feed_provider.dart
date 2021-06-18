import 'dart:convert';
import 'package:flutter_complete_guide/modals/staff_class.dart';
import '../modals/feed_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedProvider with ChangeNotifier {
  List<Feed> _items = [];
  final String authToken;
  final String authUserId;
  FeedProvider(this.authToken, this.authUserId, this._items);
  List<Feed> get items {
    return [..._items];
  }

  Future<void> uloadPost(Feed data) async {
    print('uploaddddd');

    final url = 'https://crr-coe.firebaseio.com/posts.json?auth=$authToken';
    print(data.uploader.id);
    try {
      await http.post(
        url,
        body: json.encode({
          'posted_by_id': data.uploader.id,
          'posted_by': data.uploader.name,
          'department': data.uploader.department,
          'time': data.time.toIso8601String(),
          'photoUrl': data.imageUrl,
          'post_description': data.description
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchNewsFeed() async {
    _items = [];
    print('object');
    final url =
        'https://crr-coe.firebaseio.com/posts.json?auth=$authToken&orderBy="time"&limitToLast=3';
    try {
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      print('zxzxzx');
      extractedData.forEach((feedId, feedData) {
        _items.add(Feed(
            description: feedData['post_description'],
            imageUrl: feedData['photoUrl'],
            uploader: Staff(
                id: feedData['posted_by_id'],
                sid: null,
                name: feedData['posted_by'],
                department: feedData['department']),
            time: DateTime.parse(feedData['time'])));
      });
      // _items=_items.reversed;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
