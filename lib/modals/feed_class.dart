import 'package:flutter/cupertino.dart';
import '../modals/staff_class.dart';


class Feed {
  final String description;
  final String imageUrl;
  final Staff uploader;
  final DateTime time;
  Feed({
  @required this.description,
  @required this.imageUrl,
  @required this.uploader,
  @required this.time
   } );
}
