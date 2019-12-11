import 'package:flutter/material.dart';
import 'package:flutter_app/Model/QuestionModel.dart';
import 'package:flutter_app/Model/QuestionTypeModel.dart';
import 'package:flutter_app/processdatabase.dart';

class Questions extends StatefulWidget {

  Questions(this.questionType);
  final QuestionTypeModel questionType;

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

  QuestionModel question;
  List<QuestionModel> lQuestions = [];
  List<Widget> bodyTabs = new List();
  List<Widget> lstTabs = [];

  @override

  void initState(){
    super.initState();
    initDatabase().then((v) async{
      this.lQuestions = await getQuestions(v, widget.questionType.zIndex);
      for(QuestionModel question in lQuestions){
        this.question = question;
      }
      setState(() {

      });
    });
  }
  Widget build(BuildContext context) {
    lstTabs.clear();
    if (lQuestions.length == 0) return Container();
    if (lQuestions.length != 0) {
      bodyTabs = (buildListView(lQuestions));
      for (int i = 0; i < lQuestions.length; i++) {
        lstTabs.add(Tab(
          child: Text(
            'Câu ${i + 1}',
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
    }
    return DefaultTabController(
        length: lstTabs.length,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.questionType.zTypeQuestion,
                style: TextStyle(fontSize: 20.0),
              ),
              bottom: PreferredSize(
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.5),
                      indicatorColor: Colors.white,
                      tabs: lstTabs),
                  preferredSize: Size.fromHeight(40.0)),
            ),
            body: TabBarView(children: bodyTabs)));
  }
}
List<Widget> buildListView(List<QuestionModel> list) {
  return list.map((f) => question(f)).toList();
}

Widget question(QuestionModel question) {
  List<String> answers = (question.zAnswer.split(','));
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            question.zQuestion,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        (question.zImageQuestion == null)
            ? Container()
            : Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/imageapp/${question.zImageQuestion}"),
                  fit: BoxFit.contain)),
        ),
        (answers.contains('1'))
            ? answerRight(question.zOption1)
            : answerWrong(question.zOption1),
        (answers.contains('2'))
            ? answerRight(question.zOption2)
            : answerWrong(question.zOption2),
        (question.zOption3 == null)
            ? Container()
            : (answers.contains('3'))
            ? answerRight(question.zOption3)
            : answerWrong(question.zOption3),
        (question.zOption4 == null)
            ? Container()
            : (answers.contains('4'))
            ? answerRight(question.zOption4)
            : answerWrong(question.zOption4),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: (question.zAnswerDesc == null)
              ? Container()
              : Column(
            children: <Widget>[
              Text(
                'Giải thích đáp án',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  question.zAnswerDesc,
                  style: TextStyle(fontSize: 15),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget answerWrong(String option) {
  return Card(
    elevation: 3,
    child: Container(
        padding: EdgeInsets.all(10),
        child: Text(option, style: TextStyle(fontSize: 15))),
  );
}

Widget answerRight(String option) {
  return Card(
    elevation: 3,
    child: Container(
        padding: EdgeInsets.all(10),
        child:
        Text(option, style: TextStyle(fontSize: 15, color: Colors.blue))),
  );
}