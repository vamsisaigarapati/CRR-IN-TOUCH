import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './resultpage.dart';


class GetJson extends StatelessWidget {
  // accept the langname as a parameter
List questions;
  final String subName;
  GetJson(this.subName,this.questions);
  
  
  // a function
  // sets the asset to a particular JSON file
  // and opens the JSON
  // setasset() {
  //   if (langname == "Python") {
  //     assettoload = "assets/python.json";
  //   } else if (langname == "Java") {
  //     assettoload = "assets/java.json";
  //   } else if (langname == "Javascript") {
  //     assettoload = "assets/js.json";
  //   } else if (langname == "C++") {
  //     assettoload = "assets/cpp.json";
  //   } else {
  //     assettoload = "assets/linux.json";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return QuizPage(mydata: questions,subName: subName,);
    // this function is called before the build so that
    // the string assettoload is avialable to the DefaultAssetBuilder
       // and now we return the FutureBuilder to load and decode JSON
    // return FutureBuilder(
    //   future:
    //       Provider.of<QuizProvider>(context).fetchQuiz(details[0]),
    //   builder: (context, snapshot) {
       
    //      mydata =  Provider.of<QuizProvider>(context).items;
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Scaffold(
    //         body: Center(
    //           child: Text(
    //             "Loading",
    //           ),
    //         ),
    //       );
    //     } else {
    //       print(mydata);
    //       print("szd");
    //        return QuizPage(mydata: mydata);
    //     }
    //   },
    // );
  }
}

class QuizPage extends StatefulWidget {
 final List mydata;
 final String subName;

  QuizPage({Key key, @required this.mydata, @required this.subName}) : super(key: key);
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var _isInit=false;

  Color colortoshow = Colors.amberAccent;
  Color right = Colors.amber;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 0;
  // extra varibale to iterate
  // int j = 1;
  int timer = 30;
  String showtimer = "30";

  Map<String, Color> btncolor = {
    "optA": Colors.purple,
    "optB": Colors.purple,
    "optB": Colors.purple,
    "optB": Colors.purple,
  };

  bool canceltimer = false;

  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  // import 'dart:math';

  //   var random_array;
  //   var distinctIds = [];
  //   var rand = new Random();
  //     for (int i = 0; ;) {
  //     distinctIds.add(rand.nextInt(10));
  //       random_array = distinctIds.toSet().toList();
  //       if(random_array.length < 10){
  //         continue;
  //       }else{
  //         break;
  //       }
  //     }
  //   print(random_array);

  // ----- END OF CODE
  

  // overriding the initstate function to start timer as this screen is created
  // @override
  // void initState() {
  //   starttimer();
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if(!_isInit){
      starttimer();
      _isInit=true;
    }
    super.didChangeDependencies();
  }

  

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (i < widget.mydata.length-1) {
        
        i+=1;
      } else {
        
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResultPage(marks: marks,noOfquestions: widget.mydata.length,subjectName: widget.subName),
        ));
      }
      btncolor["optA"] = Colors.purple;
      btncolor["optB"] = Colors.purple;
      btncolor["optC"] = Colors.purple;
      btncolor["optD"] = Colors.purple;
    });
    starttimer();
  }

  void checkanswer(String k) {
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    String opt='option '+k[3];

    if (widget.mydata[i]['correct_option'] == opt) {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
      marks = marks + 1;
      // changing the color variable to be green
      colortoshow = right;
    } else {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow = right;
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
    });

    // changed timer duration to 1 second
    Timer(Duration(seconds: 1), nextquestion);
  }

  Widget choicebutton(String k) {
    return Visibility(
      visible: true,
          child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: MaterialButton(
          
          onPressed: () => checkanswer(k),
          child: Text(
            widget.mydata[i][k],
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Alike",
              fontSize: 16.0,
            ),
            maxLines: 2,
          ),
          color: btncolor[k],
          splashColor: Colors.amberAccent,
          highlightColor: Colors.indigo[700],
          minWidth: 200.0,
          height: 45.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Quiz",
                  ),
                  content: Text("You Can't Go Back At This Stage."),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                      ),
                    )
                  ],
                ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.mydata[i]['question'],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choicebutton('optA'),
                    choicebutton('optB'),
                    choicebutton('optC'),
                    choicebutton('optD'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
