import 'dart:convert';

QuestionTypeModel questionFromJson(String str) {
  final jsonDataQuestionType = json.decode(str);
  return QuestionTypeModel.fromJson(jsonDataQuestionType);
}

class QuestionTypeModel {
  String zTypeQuestion;
  String zTypeQuestionDesc;
  String zImage;
  int zIndex;

  QuestionTypeModel({this.zTypeQuestion, this.zTypeQuestionDesc, this.zImage, this.zIndex});
  factory QuestionTypeModel.fromJson(Map<String, dynamic> json) {
    return QuestionTypeModel(
      zTypeQuestion: json["ZTYPE_NAME"],
      zTypeQuestionDesc: json["ZDESC"],
      zImage: json["ZIMAGE"],
      zIndex: json["Z_PK"],
    );
  }
}