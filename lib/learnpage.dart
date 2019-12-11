import 'package:flutter/material.dart';
import 'package:flutter_app/Model/QuestionTypeModel.dart';
import 'package:flutter_app/processdatabase.dart';
import 'learnquestion.dart';

class LearningPage extends StatefulWidget {
  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List lTypeQuestions = [];
  List<QuestionTypeModel> lModelTypeQuestions;

  @override
  void initState() {
    super.initState();
    initDatabase().then((v) async {
      this.lModelTypeQuestions = await getQuestionType(v);
      for (var type in lModelTypeQuestions) {
        lTypeQuestions.add(type);
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Học lý thuyết'),
        ),
        body: ListView(
          children:
              this.lTypeQuestions.map((f) => questionType(f, context)).toList(),
        ));
  }
}

Widget questionType(QuestionTypeModel question, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Questions(question);
      }));
    },
    child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/icon/${question.zImage}"),
              )),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      question.zTypeQuestion,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      question.zTypeQuestionDesc,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
