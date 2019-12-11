import 'package:flutter/material.dart';
import 'package:flutter_app/learnpage.dart';
import 'package:flutter_app/signpage.dart';

import 'exams.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> options = [];
  Color colorOption = Colors.lightBlue;
  double sizeOption = 40;
  @override
  Widget build(BuildContext context) {
    options.clear();
    options.add(
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LearningPage();
          }));
        },
        child: optionObject(OptionObject(
            iconOption: Icons.book,
            size: sizeOption,
            color: colorOption,
            textDescription: "Học lý thuyết")),
      ),
    );
    options.add(
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ListExamPage();
          }));
        },
        child: optionObject(OptionObject(
            iconOption: Icons.border_color,
            size: sizeOption,
            color: colorOption,
            textDescription: "Thi theo bộ đề")),
      ),
    );
    options.add(
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SignPage();
          }));
        },
        child: optionObject(OptionObject(
            iconOption: Icons.remove_circle,
            size: sizeOption,
            color: colorOption,
            textDescription: "Biển báo giao thông")),
      ),
    );
//    options.add(
//      GestureDetector(
///*        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return CountDownTime();
//          }));
//        },*/
//        child: optionObject(OptionObject(
//            iconOption: Icons.shuffle,
//            size: sizeOption,
//            color: colorOption,
//            textDescription: "Đề thi ngẫu nhiên")),
//      ),
//    );
//    options.add(
//      GestureDetector(
///*        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SignPage();
//          }));
//        },*/
//        child: optionObject(OptionObject(
//            iconOption: Icons.priority_high,
//            size: sizeOption,
//            color: colorOption,
//            textDescription: "Mẹo thi kết quả cao")),
//      ),
//    );
//    options.add(
//      GestureDetector(
///*        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SignPage();
//          }));
//        },*/
//        child: optionObject(OptionObject(
//            iconOption: Icons.search,
//            size: sizeOption,
//            color: Colors.blue,
//            textDescription: "Tra cứu luật nhanh")),
//      ),
//    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ôn thi GPLX B2',
        ),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Image.asset('assets/imageapp/438.webp'),
              ),
            ],
          ),
          GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              physics: ScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: options),
          // ...... other list children.
        ],
      ),
    );
  }
}

class OptionObject {
  OptionObject({this.iconOption, this.textDescription, this.color, this.size});
  IconData iconOption;
  String textDescription;
  Color color;
  double size;
}

Widget optionObject(OptionObject option) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Center(
            child: new Icon(
              option.iconOption,
              color: option.color,
              size: option.size,
            ),
//            child: option.iconOption
          ),
        ),
        Container(
          child: Center(
            child: Text(
              option.textDescription,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
