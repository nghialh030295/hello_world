import 'dart:convert';

SignModel signFromJson(String str) {
  final jsonDataSign = json.decode(str);
  return SignModel.fromJson(jsonDataSign);
}

class SignModel {
  String zImageSign;
  String zNameSign;
  String zDescSign;
  SignModel({this.zImageSign, this.zNameSign, this.zDescSign});
  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      zImageSign: json["ZIMAGE"],
      zNameSign: json["ZNAME"],
      zDescSign: json["ZDESC"],
    );
  }
}
