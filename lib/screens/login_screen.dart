import 'package:flutter/material.dart';
import '../loginPageAnimations/fade_animation.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../modals/http_exception.dart';

enum AuthMode { TLogin, SLogin }
class Login extends StatelessWidget {
  static const routName = '/login';
  final rno = TextEditingController();
  final password = TextEditingController();
  void valid(BuildContext context) {
    if (rno.text.isEmpty) {
      return;
    }
    final enteredrno = rno.text;
    final enteredPassword = password.text;
    if (enteredrno.isEmpty || enteredPassword.isEmpty) {
      return;
    }
    // Navigator.of(context).pushReplacementNamed(Home.routName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.purple[900],
            Colors.purple[600],
            Colors.purple[400]

            
          ])),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "       Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "C R Reddy College of Engg.",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: AuthCard(),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}



class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SLogin;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    // _heightAnimation.addListener((){setState(() {
    // });});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showDialogue(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.SLogin) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).slogin(
          _authData['email'],
          _authData['password'],
        );
      
       } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).tlogin(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not valid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'could not find user';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'invalid password';
      }
      else if(error.toString().contains('Teacher')){
        errorMessage = 'This is Not a Teacher';
      }
       else if(error.toString().contains('Student')){
        errorMessage = 'This is Not a Student';
      }
      _showDialogue(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you, please try again later';
      _showDialogue(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SLogin) {
      setState(() {
        _authMode = AuthMode.TLogin;
      });
        
      
      
    } else {
      setState(() {
         _authMode = AuthMode.SLogin;
      });
       
    
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: 340,
          // height: _heightAnimation.value.height,
          // constraints: BoxConstraints(
          //     minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child: Text(
                          _authMode == AuthMode.SLogin ? 'STUDENT LOGIN' : 'STAFF LOGIN'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.SLogin ? 'STAFF LOGIN' : 'STUDENT LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                   ClipOval(
                child: Container(
                  height: 90,
                  child: Image.asset("assets/images/logo.jpg")),
              )
                ],
              ),
            ),
          ),
        ));
  }
}
