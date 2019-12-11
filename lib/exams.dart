import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/Model/QuestionModel.dart';
import 'package:flutter_app/processdatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/ExamModel.dart';
import 'exampage.dart';

class ListExamPage extends StatefulWidget {
  @override
  _ListExamPageState createState() => _ListExamPageState();
}

class _ListExamPageState extends State<ListExamPage> {
  List<ExamModel> testData = List<ExamModel>();
  List<Widget> exams = [];

  @override
  void initState() {
    super.initState();
    initExams().then((v) {
      setState(() {
        testData = v;
      });
    });
  }

  Future<List<ExamModel>> initExams() async {
    final prefs = await SharedPreferences.getInstance();
//    await prefs.setString("testData", null);
    String dataTest = prefs.getString('testData');
//    print('dataTest');
//    print(dataTest);

    var result = List<ExamModel>();
    if (dataTest == null) {
      for (var i = 0; i < 20; i++) {
        var questions = await randomTestData();
        var examModel = new ExamModel(
            id: i + 1, number: 0, questions: questions, status: "Làm bài");
        result.add(examModel);
      }
      var dataJson = result.map((f) => f.toJson()).toList();
      prefs.setString("testData", json.encode(dataJson as List<Map>));
    } else {
      result = (json.decode(dataTest) as List)
          .map((f) => ExamModel.fromJson(f))
          .toList();
    }
    return result;
  }

  Future<List<QuestionModel>> randomTestData() async {
    List<QuestionModel> listModelQuestion = [];
    List<QuestionModel> listModelQuestion431 = [];
    List<QuestionModel> listModelQuestion432 = [];
    List<QuestionModel> listModelQuestion433 = [];
    List<QuestionModel> listModelQuestion44 = [];
    List<QuestionModel> listModelQuestion45 = [];
    List<QuestionModel> listModelQuestion4647 = [];
    List<QuestionModel> listModelQuestion48 = [];
    List<QuestionModel> listModelQuestion49 = [];
    List<QuestionModel> listQuestionExam = List<QuestionModel>();

    await initDatabase().then((v) async {
      listModelQuestion = await getAllQuestions(v);
    });
    if (listModelQuestion.length != 0) {
      for (int i = 0; i < 21; i++) {
        listModelQuestion431.add(listModelQuestion[i]);
      }
      QuestionModel question431 =
          listModelQuestion431[Random().nextInt(listModelQuestion431.length)];
      listQuestionExam.add(question431);

      for (int i = 21; i < 131; i++) {
        listModelQuestion432.add(listModelQuestion[i]);
      }
      for (int i = 1; i <= 7; i++) {
        QuestionModel question432 =
            listModelQuestion432[Random().nextInt(listModelQuestion432.length)];
        listQuestionExam.add(question432);
      }

      for (int i = 131; i < 145; i++) {
        listModelQuestion433.add(listModelQuestion[i]);
      }
      QuestionModel question433 =
          listModelQuestion433[Random().nextInt(listModelQuestion433.length)];
      listQuestionExam.add(question433);

      for (int i = 145; i < 175; i++) {
        listModelQuestion44.add(listModelQuestion[i]);
      }
      QuestionModel question44 =
          listModelQuestion44[Random().nextInt(listModelQuestion44.length)];
      listQuestionExam.add(question44);

      for (int i = 175; i < 200; i++) {
        listModelQuestion45.add(listModelQuestion[i]);
      }
      QuestionModel question45 =
          listModelQuestion45[Random().nextInt(listModelQuestion45.length)];
      listQuestionExam.add(question45);

      for (int i = 200; i < 255; i++) {
        listModelQuestion4647.add(listModelQuestion[i]);
      }
      QuestionModel question4647 =
          listModelQuestion4647[Random().nextInt(listModelQuestion4647.length)];
      listQuestionExam.add(question4647);

      for (int i = 255; i < 355; i++) {
        listModelQuestion48.add(listModelQuestion[i]);
      }
      for (int i = 1; i <= 9; i++) {
        QuestionModel question48 =
            listModelQuestion48[Random().nextInt(listModelQuestion48.length)];
        listQuestionExam.add(question48);
      }

      for (int i = 355; i < 450; i++) {
        listModelQuestion49.add(listModelQuestion[i]);
      }
      for (int i = 1; i <= 9; i++) {
        QuestionModel question49 =
            listModelQuestion49[Random().nextInt(listModelQuestion49.length)];
        listQuestionExam.add(question49);
      }
    }
    return listQuestionExam;
  }

  @override
  Widget build(BuildContext context) {
    if (testData.length == 0) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }
    /*exams.clear();
    for (int i = 0; i < testData.length; i++){
      var test =  testData[i];
      exams.add(testOption(testData[i]));
    }*/
    print("setState");
    return Scaffold(
      appBar: AppBar(
        title: Text('Thi sát hạch'),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: testData.map((f) => testOption(f)).toList()),
    );
  }

  Widget testOption(ExamModel test) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ExamPage(test);
        })).then((v) async {
          if (v is ExamModel) {
            var ad = v;
//            print(ad.toJson());

            testData[ad.id - 1] = ad;
//            print(testData[ad.id - 1].toJson());
            final prefs = await SharedPreferences.getInstance();

            prefs.setString("testData",
                json.encode(testData.map((a) => a.toJson()).toList()));
            setState(() {});
          }
        });
      },
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Đề số ${test.id}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${test.status}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${test.number}/30 Câu',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
