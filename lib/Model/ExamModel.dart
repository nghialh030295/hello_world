import 'package:flutter_app/Model/QuestionModel.dart';

class ExamModel {
  ExamModel({this.status, this.questions, this.id, this.number});
  String status;
  List<QuestionModel> questions;
  int id;
  int number = 0;

  factory ExamModel.fromJson(Map<String, dynamic> json){
    return ExamModel(
      status: json["status"],
      questions: (json["questions"] as List).map((g) => QuestionModel.fromJson(g)).toList(),
      id: json["id"],
      number: json["number"]
    );
  }

  Map<String, dynamic> toJson(){
    var result = Map<String,dynamic>();
    result["status"] = this.status;
    result["questions"] = this.questions. map((f) => f.toJson()).toList();
    result["id"] = this.id;
    result["number"] = this.number;
    return result;
  }
}