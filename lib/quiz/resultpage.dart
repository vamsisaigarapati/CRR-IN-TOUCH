import 'package:flutter/material.dart';
import '../screens/tabs_screen_students.dart';
import '../providers/student_provider.dart';
import 'package:provider/provider.dart';
import '../providers/result_provider.dart';
class ResultPage extends StatefulWidget {
  int marks;
  int noOfquestions;
  String subjectName;
  ResultPage({Key key , @required this.marks,@required this.noOfquestions,@required this.subjectName}) : super(key : key);
  @override
  _ResultPageState createState() => _ResultPageState(marks,noOfquestions);
}

class _ResultPageState extends State<ResultPage> {
  var _isInit = false;
  var _isLoading = false;
  List details=[];
@override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<Students>(context).fetchUserDetails().then((_) {
        details = Provider.of<Students>(context).items;
        
         setState(
        () {
          _isLoading = false;
        },
      );

      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }
  List<String> images = [
    "assets/images/success.png",
    "assets/images/good.png",
    "assets/images/bad.png",
  ];

  String message;
  String image;

  @override
  void initState(){
    if(marks < 20){
      image = images[2];
      message = "You Should Try Hard..\n" + "You Scored $marks/$noOfquestions";
    }else if(marks < 35){
      image = images[1];
      message = "You Can Do Better..\n" + "You Scored $marks/$noOfquestions";
    }else{
      image = images[0];
      message = "You Did Very Well..\n" + "You Scored $marks/$noOfquestions";
    }
    super.initState();
  }

  int marks;
  int noOfquestions;
  _ResultPageState(this.marks,this.noOfquestions);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Result",
        ),
      ),
      body:_isLoading?Center(child: CircularProgressIndicator(),): Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(
                              image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Center(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Quando",
                        ),
                      ),
                    )
                    ),
                  ],
                ),
              ),
            ),            
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
                    setState(() {
                      _isLoading=true;
                    });
                    Provider.of<ResultProvider>(context).updateResult(details[0], widget.subjectName, marks).then((_){
                       setState(() {
                      _isLoading=false;
                    });
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
                    }
                    
                    );
                   
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  borderSide: BorderSide(width: 3.0, color: Colors.indigo),
                  splashColor: Colors.indigoAccent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}