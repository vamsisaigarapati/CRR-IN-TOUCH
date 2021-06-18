import 'package:flutter/material.dart';
import '../modals/question.dart';
import '../modals/quiz.dart';
import 'package:provider/provider.dart';
import '../providers/question_entry_provider.dart';
class QuestionEntryScreen extends StatefulWidget {
  static const routeName = 'question-entry-screen';
  @override
  _QuestionEntryScreenState createState() => _QuestionEntryScreenState();
}

class _QuestionEntryScreenState extends State<QuestionEntryScreen> {
  final _optAFocusNode = FocusNode();
  final _optBFocusNode = FocusNode();

  final _optCFocusNode = FocusNode();
  final _optDFFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
var _isLoading=false;
  @override
  void dispose() {
    _optAFocusNode.dispose();
    _optBFocusNode.dispose();
    _optCFocusNode.dispose();
    _optDFFocusNode.dispose();
    super.dispose();
  }
Future<void>_submitList(QuizClass details) async{
  setState(() {
      _isLoading = true;
    });

    if (listOfQuestions != null) {
      try {
        print("hello");
        await Provider.of<QuestionEntry>(context, listen: false)
            .addListOfQuestions(details,listOfQuestions);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
     showDialog(
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: (){return;},
              child: AlertDialog(
          title: Text('Quiz is set'),
          content: Text('Done'),
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
}
  var _noOfQuestions = 1;
  var optionDropValue = "option A";
  var i = 0;
  var _newQuestion = Question(
      question: "", optA: "", optB: "", optC: "", optD: "", correctOpt: "");
  var _initialValue = "";
 final List<Question> listOfQuestions=[];
  @override
  Widget build(BuildContext context) {
    final details = ModalRoute.of(context).settings.arguments as QuizClass;

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Question'),
        actions: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(child: Text(_noOfQuestions.toString())),
                  )),
            ),
          )
        ],
      ),
      body:_isLoading?Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initialValue,
                decoration: InputDecoration(labelText: 'Question'),
                textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_optAFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _newQuestion = Question(
                    question: value,
                    optA: _newQuestion.optA,
                    optB: _newQuestion.optB,
                    optC: _newQuestion.optC,
                    optD: _newQuestion.optD,
                    correctOpt: _newQuestion.correctOpt,
                  );
                },
              ),
              TextFormField(
                initialValue: _initialValue,
                decoration: InputDecoration(labelText: 'Option A'),
                textInputAction: TextInputAction.next,
                focusNode: _optAFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_optBFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Option A.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _newQuestion = Question(
                    question: _newQuestion.question,
                    optA: value,
                    optB: _newQuestion.optB,
                    optC: _newQuestion.optC,
                    optD: _newQuestion.optD,
                    correctOpt: _newQuestion.correctOpt,
                  );
                },
              ),
              TextFormField(
                initialValue: _initialValue,
                decoration: InputDecoration(labelText: 'Option B'),
                textInputAction: TextInputAction.next,
                focusNode: _optBFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_optCFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a OPtionB.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _newQuestion = Question(
                    question: _newQuestion.question,
                    optA: _newQuestion.optA,
                    optB: value,
                    optC: _newQuestion.optC,
                    optD: _newQuestion.optD,
                    correctOpt: _newQuestion.correctOpt,
                  );
                },
              ),
              TextFormField(
                initialValue: _initialValue,
                decoration: InputDecoration(labelText: 'Option C'),
                textInputAction: TextInputAction.next,
                focusNode: _optCFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_optDFFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a OptionC.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _newQuestion = Question(
                    question: _newQuestion.question,
                    optA: _newQuestion.optA,
                    optB: _newQuestion.optB,
                    optC: value,
                    optD: _newQuestion.optD,
                    correctOpt: _newQuestion.correctOpt,
                  );
                },
              ),
              TextFormField(
                initialValue: _initialValue,
                decoration: InputDecoration(labelText: 'Option D'),
                textInputAction: TextInputAction.next,
                focusNode: _optDFFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a OPtionB.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _newQuestion = Question(
                    question: _newQuestion.question,
                    optA: _newQuestion.optA,
                    optB: _newQuestion.optB,
                    optC: _newQuestion.optC,
                    optD: value,
                    correctOpt: _newQuestion.correctOpt,
                  );
                },
              ),
              Row(
                
                children: <Widget>[
                  Text('Correct option'),
                  SizedBox(width: 130),
                  DropdownButton<String>(
                    value: optionDropValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _newQuestion = Question(
                          question: _newQuestion.question,
                          optA: _newQuestion.optA,
                          optB: _newQuestion.optB,
                          optC: _newQuestion.optC,
                          optD: _newQuestion.optD,
                          correctOpt: newValue,
                        );
                        i = 1;
                        optionDropValue = newValue;
                      });
                    },
                    items: <String>[
                      'option A',
                      'option B',
                      'option C',
                      'option D'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text(_noOfQuestions == details.noOfQuestions
                    ? 'Submit'
                    : 'Next'),
                onPressed: () {
                  final isValid = _form.currentState.validate();
                  if (!isValid) {
                    return;
                  }
                  _form.currentState.save();
                  if (_newQuestion != null) {
                    print(_newQuestion.question);
                    listOfQuestions.add(_newQuestion);
                    _newQuestion = Question(
                        question: "",
                        optA: "",
                        optB: "",
                        optC: "",
                        optD: "",
                        correctOpt: "");
                    if (_noOfQuestions == details.noOfQuestions) {
                      _submitList(details).then((_){});
                    }
                    setState(() {
                      _form.currentState.reset();
                      _noOfQuestions += 1;
                    });
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
