import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Model/ExamModel.dart';
import 'package:flutter_app/Model/QuestionModel.dart';
import 'count-down.dart';

class ExamPage extends StatefulWidget {
  ExamPage(this.test);
  final ExamModel test;
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<QuestionModel> lQuestionExam = [];
  List<Widget> lstTabs = [];
  List<Widget> lstQues = [];
  TabController _controller;
  Map<int, List<String>> _map = new Map();
  Map<int, List<String>> allAnswer = new Map();
  int countTrue = 0;
  String testResult;
  CountDown countDown;

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Kết thúc'),
            content: Text('Bạn muốn kết thúc bài thi?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Tiếp tục'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Kết thúc'),
                onPressed: () {
                  var result = Map();
                  allAnswer.forEach((k, v) {
                    if (listEquals2<String>(_map[k], v)) {
                      result[k] = true;
                    } else {
                      result[k] = false;
                    }
                  });
                  result.forEach((k, v) {
                    if (v == true) {
                      countTrue++;
                    }
                  });
                  print(countTrue);
                  print(result);

                  Navigator.of(context).pop(result);
                  _showResult(widget.test);
                },
              )
            ],
          );
        });
  }

  void _showDialog1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Kết thúc'),
            content: Text('Xin lỗi! \nThời gian của bài thi đã hết!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Kết thúc'),
                onPressed: () {
                  var result = Map();
                  allAnswer.forEach((k, v) {
                    if (listEquals2<String>(_map[k], v)) {
                      result[k] = true;
                    } else {
                      result[k] = false;
                    }
                  });
                  result.forEach((k, v) {
                    if (v == true) {
                      countTrue++;
                    }
                  });
                  print(countTrue);
                  print(result);

                  Navigator.of(context).pop(result);
                  _showResult(widget.test);
                },
              )
            ],
          );
        });
  }

  void _showResult(ExamModel data) {
    if (countTrue < 28) {
      testResult = 'Trượt';
    } else {
      testResult = 'Đỗ';
    }
    data.status = testResult;
    data.number = countTrue;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Đề số ${widget.test.id.toString()}',
            ),
            content: (countTrue < 28)
                ? Text('Rất tiêc! \nBạn đã trượt bài thi!')
                : Text('Chúc mừng! \nBạn đã đỗ bài thi!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Tiếp tục'),
                onPressed: () {
                  print('Tiếp tục');
                  Navigator.of(context).pop('1');
                  Navigator.of(context).pop(data);
                },
              ),
            ],
          );
        });
  }

  StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    countDown = CountDown(_showDialog1, Duration(seconds: 1200),
        refresh: Duration(milliseconds: 500));
    lQuestionExam = widget.test.questions;
    for (var ques in lQuestionExam) {
      allAnswer[ques.zIndex] = [ques.zAnswer];
    }
    print(allAnswer);
    print(allAnswer.length);
    for (var i = 0; i < lQuestionExam.length; i++) {
      lstTabs.add(tab(i));
      lstQues = (buildListView(lQuestionExam, _controller, _map));
    }
    _streamSubscription = countDown.stream.listen((v) {
      if(!mounted) return;
      if (countDown.isPaused) {
        _showDialog();
      } else
        setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool listEquals2<T>(List<T> a, List<T> b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (!a.contains(b[index])) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: lstTabs.length,
      child: Scaffold(
          appBar: AppBar(
            title: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Đề số ${widget.test.id.toString()}',
                  ),
                  if (countDown.remainingTime != null)
                    Text(
                      '${countDown.remainingTime.inMinutes} : ${(countDown.remainingTime.inSeconds % 60)}',
                    ),
                  FlatButton(
                    onPressed: () {
                      _showDialog();
                    },
                    child: Text(
                      'Kết Thúc',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            leading: new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _showDialog,
            ),
            bottom: PreferredSize(
                child: TabBar(
                  controller: _controller,
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorColor: Colors.white,
                  tabs: lstTabs,
                ),
                preferredSize: Size.fromHeight(40.0)),
          ),
          body: TabBarView(
            children: lstQues,
            controller: _controller,
          )),
    );
  }

  Widget tab(i) {
    return Tab(
      child: Text(
        'Câu ${i + 1}',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

List<Widget> buildListView(List<QuestionModel> list, TabController controller,
    Map<int, List<String>> map) {
  return list.map((f) => CheckQuestion(f, map)).toList();
}

class CheckQuestion extends StatefulWidget {
  CheckQuestion(this.question, this.answers);
  final QuestionModel question;
  final Map<int, List<String>> answers;
  @override
  _CheckQuestionState createState() => _CheckQuestionState();
}

class _CheckQuestionState extends State<CheckQuestion> {
  var selectedText = List<String>();
  var b = false;
  var answer = List<String>();
  String getValueByNumber(String value) {
    if ('1' == value) return widget.question.zOption1;
    if ('2' == value) return widget.question.zOption2;
    if ('3' == value) return widget.question.zOption3;
    if ('4' == value) return widget.question.zOption4;
    return "";
  }

  @override
  void initState() {
    super.initState();

    if (widget.answers.containsKey(widget.question.zIndex)) {
      setState(() {
        answer = widget.answers[widget.question.zIndex];
        selectedText = answer.map((x) => getValueByNumber(x)).toList();
      });
    }
  }

  void onChange(bool b, String value) {
    setState(() {
      if (b) {
        selectedText.add(value);
      } else {
        selectedText.remove(value);
      }
      widget.answers[widget.question.zIndex] = answer;
//      print(widget.answers);
//      print(widget.answers.length);
    });
  }

  @override
  void dispose() {
    widget.answers[widget.question.zIndex] = answer;
//    print(widget.answers);
//    print(widget.answers.length);
    //print("dispose:");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                widget.question?.zQuestion ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (widget.question.zImageQuestion == null)
              ? Container()
              : Container(
                  child: Image.asset(
                      "assets/imageapp/${widget.question.zImageQuestion}"),
                ),
          Card(
            child: CheckboxListTile(
              onChanged: (b) {
                onChange(b, widget.question?.zOption1);
                (b) ? answer.add('1') : answer.remove('1');
              },
              value: selectedText.contains(widget.question?.zOption1),
              selected: selectedText.contains(widget.question?.zOption1),
              title: Text(widget.question?.zOption1),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Card(
            child: CheckboxListTile(
              onChanged: (b) {
                onChange(b, widget.question?.zOption2);
                (b) ? answer.add('2') : answer.remove('2');
              },
              value: selectedText.contains(widget.question?.zOption2),
              selected: selectedText.contains(widget.question?.zOption2),
              title: Text(widget.question?.zOption2),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          (widget.question?.zOption3 == null)
              ? Container()
              : Card(
                  child: CheckboxListTile(
                    onChanged: (b) {
                      onChange(b, widget.question?.zOption3);
                      (b) ? answer.add('3') : answer.remove('3');
                    },
                    value: selectedText.contains(widget.question?.zOption3),
                    selected: selectedText.contains(widget.question?.zOption3),
                    title: Text(widget.question?.zOption3),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
          (widget.question?.zOption4 == null)
              ? Container()
              : Card(
                  child: CheckboxListTile(
                    onChanged: (b) {
                      onChange(b, widget.question?.zOption4);
                      (b) ? answer.add('4') : answer.remove('4');
                    },
                    value: selectedText.contains(widget.question?.zOption4),
                    selected: selectedText.contains(widget.question?.zOption4),
                    title: Text(widget.question?.zOption4),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
        ],
      ),
    );
  }
}
