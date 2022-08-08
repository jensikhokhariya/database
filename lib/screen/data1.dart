import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class EXDB {
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, "QuotesDatabase.sqlite");

    bool ischek = await File(path).exists();

    if (ischek == false){
      ByteData byteData = await rootBundle.load("assets/db/QuotesDatabase.sqlite");
       var data = byteData.buffer.asUint8List();

       await File(path).writeAsBytes(data,flush: true);
    }
    return await openDatabase(path);
  }

  void readData()async{
    var database = await initDb();

    String query = "SELECT * FROM categorytable";
    List<Map<String, dynamic>> l1 = await database.rawQuery(query);

    print(l1);
  }
  void readData1()async {
    var database = await initDb();

    String query = "SELECT * FROM quotestable WHERE catid = 1";
    List<Map<String, dynamic>> l1 = await database.rawQuery(query);

    print(l1);
  }
}