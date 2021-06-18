import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './providers/feed_provider.dart';
import 'package:flutter_complete_guide/providers/quiz_entry_provider.dart';
import './screens/attendance_for_student.dart';
import './providers/student_provider.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/login_screen.dart';
import './screens/splash_screen.dart';
import './screens/student_profile_screen.dart';
import './screens/student_entry_screen.dart';
import './screens/staff_home.dart';
import './screens/student_home_screen.dart';
import './screens/quiz_entry_screen.dart';
import './screens/question_entry_screen.dart';
import './providers/question_entry_provider.dart';
import './providers/quiz_provider.dart';
import './quiz/quizhome.dart';
import './providers/result_provider.dart';
import './screens/year_for_result.dart';
import './screens/fetch_attendance_screen.dart';
import './screens/subjects_key_overview.dart';
import './providers/attendance.dart';
import './screens/attendance_details_entry_scree.dart';
import './screens/feed_upload.dart';
import './screens/making_announcement.dart';
import './providers/announcement_provider.dart';
import './screens/display_announcements.dart';
import './screens/quiz-notifications.dart';
import './screens/attendance_options.dart';
import './screens/tabs_screen_students.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState() {
    print('haiii');
    _messaging.getToken().then((token) {
      print(token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Students>(
          builder: (ctx, auth, previousItems) => Students(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, QuizEntry>(
          builder: (ctx, auth, previousItems) => QuizEntry(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, QuestionEntry>(
          builder: (ctx, auth, previousItems) => QuestionEntry(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, QuizProvider>(
          builder: (ctx, auth, previousItems) => QuizProvider(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, FeedProvider>(
          builder: (ctx, auth, previousItems) => FeedProvider(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ResultProvider>(
          builder: (ctx, auth, previousItems) => ResultProvider(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Attendance>(
          builder: (ctx, auth, previousItems) => Attendance(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AnnouncementProvider>(
          builder: (ctx, auth, previousItems) => AnnouncementProvider(
            auth.token,
            auth.userId,
            previousItems == null ? [] : previousItems.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CRR COE',
          theme: ThemeData(
            primaryColor: Colors.purple[600],
            accentColor: Colors.amberAccent,
            errorColor: Colors.red,
            // canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                )),
          ),
          home: auth.isAuth
              ? auth.isTeacher ? StaffHome() : Home()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : Login(),
                ),
          routes: {
            StudentEntryScreen.routeName: (ctx) => StudentEntryScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            QuizDetailsEntryScreen.routeName: (ctx) => QuizDetailsEntryScreen(),
            QuestionEntryScreen.routeName: (ctx) => QuestionEntryScreen(),
            YearForResult.routName: (ctx) => YearForResult(),
            Home.routeName: (ctx) => Home(),
            QuizHomePage.routName: (ctx) => QuizHomePage(),
            StaffHome.routeName: (ctx) => StaffHome(),
            KeyHomePage.routName: (ctx) => KeyHomePage(),
            AttendanceDetailsEntryScreen.routeName: (ctx) =>
                AttendanceDetailsEntryScreen(),
            FetchAttendanceDetailsEntryScreen.routeName: (ctx) =>
                FetchAttendanceDetailsEntryScreen(),
            AttendanceForStudent.routeName: (ctx) => AttendanceForStudent(),
            FeedUploadScreen.routeName: (ctx) => FeedUploadScreen(),
            
            MakeAnAnnouncementScreen.routeName: (ctx) =>
                MakeAnAnnouncementScreen(),
            AnnouncementsScreen.routeName: (ctx) => AnnouncementsScreen(),
           QuizesAnnouncementsScreen.routeName:(ctx)=>QuizesAnnouncementsScreen(),
           AttendanceOptions.routName:(ctx)=>AttendanceOptions(),
           StudentHome.routeName:(ctx)=>StudentHome(),
          },
        ),
      ),
    );
  }
}
