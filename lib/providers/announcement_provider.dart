import 'dart:convert';
import 'package:flutter_complete_guide/modals/staff_class.dart';

import '../modals/student_class.dart';

import '../modals/announcement.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnnouncementProvider with ChangeNotifier {
  List<Announcement> _items = [];
  final String authToken;
  final String authUserId;
  AnnouncementProvider(this.authToken, this.authUserId, this._items);
  List<Announcement> get items {
    return [..._items];
  }

  Future<void> makeAnAnnouncement(Announcement data) async {
    final announcemntsTable =
        'announcements' + data.uploader.department +data.toStudentYear.toString()+ data.toStudentSection;
    final url =
        'https://crr-coe.firebaseio.com/announcements/$announcemntsTable.json?auth=$authToken';
    print(data.uploader.id);
    try {
      await http.post(
        url,
        body: json.encode({
          'posted_by_id': data.uploader.id,
          'posted_by': data.uploader.name,
          'department': data.uploader.department,
          'year': data.toStudentYear,
          'section': data.toStudentSection,
          'time': data.time.toIso8601String(),
          'announcement_description': data.announcement
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAnnouncements(Student data) async {
    final announcemntsTable = 'announcements' + data.department +data.year.toString()+ data.section;
    _items = [];
    print('object');

    final url =
        'https://crr-coe.firebaseio.com/announcements/$announcemntsTable.json?auth=$authToken&orderBy="time"&limitToLast=3';
    try {
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      print('zxzxzx');
      extractedData.forEach((announceId, announceData) {
        _items.add(Announcement(
            announcement: announceData['announcement_description'],
            toStudentYear: announceData['year'],
            toStudentSection: announceData['section'],
            uploader:Staff(id: null, sid: null, name: announceData['posted_by'], department: null),
            time: DateTime.parse(announceData['time'])));
      });
      
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
