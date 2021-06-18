import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modals/student_class.dart';
import './key.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/quiz_provider.dart';


class KeyHomePage extends StatefulWidget {
  static const routName = 'quiz-key';
  @override
  _KeyHomePageState createState() => _KeyHomePageState();
}

class _KeyHomePageState extends State<KeyHomePage> {
  var _isInit = false;
  var _isLoading = false;
  List<Student> details = [];
  Map totalQuizList = {};
  List subjects = [];
  List questions = [];
  @override
  void didChangeDependencies() {
    print('djjdjdjdjd');
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<Students>(context).fetchUserDetails().then((_) {
        print('ppppp');
        details = Provider.of<Students>(context).items;
        Provider.of<QuizProvider>(context).fetchQuizForKey(details[0]).then((_) {
          print('jjjjj');
          totalQuizList = Provider.of<QuizProvider>(context).items;

          totalQuizList.forEach((sub, ques) {
            print(ques.length);
            print(ques);

            subjects.add(sub);
            questions.add(ques);
          });
          setState(
            () {
              _isLoading = false;
            },
          );
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  Widget customcard(String subName, List questions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: Container(
        height: 100,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => KeyCarousel(subName: subName,myData: questions),
            ));
          },
          child: Material(
            color: Colors.amber,
            elevation: 10.0,
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Center(
                      child: Text(
                        subName,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: "Quando",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return  Scaffold(
            drawer: CollapsingNavigationDrawer(),
            appBar: AppBar(
              title: Text(
                "Quiz Keys",
                style: TextStyle(
                  fontFamily: "Quando",
                ),
              ),
            ),
            body:_isLoading?Center(child: CircularProgressIndicator(),): totalQuizList.isEmpty
                ? Center(
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    
                      children: <Widget>[
                        Text(
                          'No Keys yet',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            height: 300,
                            child: Image.asset(
                              'assets/images/waiting.png',
                              fit: BoxFit.cover,
                            ))
                      ],
                    ),
                )
                : ListView.builder(
                    itemCount: totalQuizList.length,
                    itemBuilder: (_, i) {
                      return customcard(subjects[i], questions[i]);
                    },
                    // children: <Widget>[
                    //   customcard("Python"),
                    // ],
                  ),
          );
  }
}
