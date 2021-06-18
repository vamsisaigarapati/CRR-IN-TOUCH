import 'dart:io';
import 'package:flutter/material.dart';
import '../providers/feed_provider.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../modals/feed_class.dart';

class FeedUploadScreen extends StatefulWidget {
  static const routeName = 'feed-upload';

  @override
  _FeedUploadScreenState createState() => _FeedUploadScreenState();
}

class _FeedUploadScreenState extends State<FeedUploadScreen> {
  final _descriptionController = TextEditingController();
  var _feed = Feed(
    time: null,
    imageUrl: "",
    description: '',
    uploader: null,
  );
  bool _takenImage = false;
  File sampleImage;
  bool _isLoading = false;
  Future<void> uploadData() async {
    if (!_takenImage || _descriptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title:
              Text(!_takenImage ? 'Upload an image' : 'enter some description'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Students>(context).fetchStaffDetails().then((_) {
        print('hey1');
        final StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('post' + DateTime.now().millisecondsSinceEpoch.toString());

        final StorageUploadTask task = firebaseStorageRef.putFile(
          sampleImage,
        );
        print('hey2');
        task.onComplete.then((val) {
          val.ref.getDownloadURL().then((v) {
         print(v);
         print('eeem');
            _feed = Feed(
              time: DateTime.now(),
                description: _descriptionController.text,
                imageUrl: v,
                uploader: Provider.of<Students>(context).staffItems[0]);
            Provider.of<FeedProvider>(context).uloadPost(_feed);
          });
        }).then((_) {
          showDialog(
            
            context: context,
            builder: (ctx) => WillPopScope(
              onWillPop: (){
                return  ;
              },
                          child: AlertDialog(
                title: Text('Post Uploaded'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/staff-home');
                    },
                  )
                ],
              ),
            ),
          );
        });
      });
    }
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
      _takenImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Make a Post'),
          
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: sampleImage == null
                                ? Center(
                                    child: Text('Select an image',
                                        textAlign: TextAlign.center))
                                : FittedBox(
                                    child: Image.file(
                                      sampleImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: RaisedButton(
                            child: Text(
                              'Select an Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: getImage,
                          )),
                        ],
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 3,
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      elevation: 7.0,
                      child: Text('Upload'),
                      textColor: Colors.white,
                      color: Colors.purple[600],
                      onPressed: () {
                        uploadData();
                      },
                    ),
                  ],
                ),
              )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  // Widget enableUpload() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         Image.file(sampleImage, height: 300.0, width: 300.0),

  //       ],
  //     ),
  //   );
  // }
}
