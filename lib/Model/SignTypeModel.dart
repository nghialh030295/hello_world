import 'dart:convert';

SignTypeModel signFromJson(String str) {
  final jsonDataSignType = json.decode(str);
  return SignTypeModel.fromJson(jsonDataSignType);
}

class SignTypeModel {
  String zTypeSign;

  SignTypeModel({this.zTypeSign});
  factory SignTypeModel.fromJson(Map<String, dynamic> json) {
    return SignTypeModel(
      zTypeSign: json["ZNAME"],
    );
  }
}
