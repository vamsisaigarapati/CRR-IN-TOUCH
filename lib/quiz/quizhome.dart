import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modals/student_class.dart';
import './quizpage.dart';
import '../drawer/collapsing_navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/quiz_provider.dart';
import './splash.dart';

class QuizHomePage extends StatefulWidget {
  static const routName = 'quiz-home';
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  var _isInit = false;
  var _isLoading = false;
  List<Student> details = [];
  Map totalQuizList = {};
  List subjects = [];
  List questions = [];
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
        Provider.of<QuizProvider>(context).fetchQuiz(details[0]).then((_) {
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
              builder: (context) => GetJson(subName, questions),
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
    return _isLoading
        ? QuizSplashScreen()
        : Scaffold(
           
            appBar: AppBar(
              title: Text(
                "Quiz",
                style: TextStyle(
                  fontFamily: "Quando",
                ),
              ),
            ),
            body: totalQuizList.isEmpty
                ? Center(
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    
                      children: <Widget>[
                        Text(
                          'No Quizes yet',
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
