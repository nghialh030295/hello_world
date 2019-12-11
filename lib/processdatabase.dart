import 'dart:io' as io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/QuestionModel.dart';
import 'Model/QuestionTypeModel.dart';
import 'Model/SignModel.dart';
import 'Model/SignTypeModel.dart';

Future<Database> initDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  print(documentsDirectory);
//  var path = await getDatabasesPath();
  var dbPath = documentsDirectory.path + '/' + 'data.sqlite';
  print(dbPath);

  if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound){
    // Load database from asset and copy
    ByteData data = await rootBundle.load("assets/databases/data.sqlite");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await new File(dbPath).writeAsBytes(bytes);
  }

//  if (io.File(await dbPath).exists() != true) {
//    ByteData data = await rootBundle.load("assets/databases/data.sqlite");
//    print(data.lengthInBytes);
//    writeToFile(data, dbPath);
//  }
  final database = await openDatabase(dbPath);
  var initialized = true;
  print('database is already');
  return database;
}

void writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  new io.File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  print('tuan cho dien');
}

Future<List<QuestionModel>> getQuestions(
    Database database, int typeQuestion) async {
//  if (!initialized) await this._initialize();
  var lQuestions = new List<QuestionModel>();
  List questions = await database
      .rawQuery("SELECT * FROM ZQUESTION WHERE ZQUESTIONTYPE = $typeQuestion");
  for (var question in questions) {
    lQuestions.add(QuestionModel.fromJson(question));
  }
  return(lQuestions);
}
Future<List<QuestionTypeModel>> getQuestionType(Database database) async {
  var lTypeQuestions = new List<QuestionTypeModel>();
  List typeQuestions = await database.rawQuery("SELECT * FROM ZQUESTIONTYPE");
  for (var questionType in typeQuestions) {
    lTypeQuestions.add(QuestionTypeModel.fromJson(questionType));
  }
  return (lTypeQuestions);
}

Future<List<QuestionModel>> getAllQuestions(Database database) async{
  var lQuestions = new List<QuestionModel>();
  List questions = await database.rawQuery("SELECT * FROM ZQUESTION");
  for(var question in questions) {
    //print(question);
    lQuestions.add(QuestionModel.fromJson(question));
  }
  return (lQuestions);
}

Future<List<SignTypeModel>> getListSignType(
    Database departuresDatabase) async {
  var signsType = new List<SignTypeModel>();
  List signTypes =
  await departuresDatabase.rawQuery('SELECT ZNAME FROM ZSIGNCATEGORY');
  for (var signType in signTypes) {
    signsType.add(SignTypeModel.fromJson(signType));
  }
  return (signsType);
}

Future<List<SignModel>> getListSign(
    Database departuresDatabase, int typeSign) async {
  var lSign = new List<SignModel>();
  List signs = await departuresDatabase
      .rawQuery('SELECT * FROM ZSIGN WHERE ZSIGNCATEGORY = $typeSign');
  for (var sign in signs) {
    lSign.add(SignModel.fromJson(sign));
  }
  return (lSign);
}