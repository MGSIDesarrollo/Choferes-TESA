/*
Developed by: Vanessa Garcia - 2022
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabase {

  SqfliteDatabase.internal();
  static final SqfliteDatabase instance = new SqfliteDatabase.internal();
  factory SqfliteDatabase() => instance;

  static final UserTable = 'Users';

  static Database? _db;


  Future<Database?> get db async {
    if (_db !=null) {
      return _db;
    }
    _db = await initBD();
    return _db;
  }


  Future<Database> initBD()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path,'tesabasedatos.db');
    var openDb = await openDatabase(dbPath,version: 2,
        onCreate: (Database db,int version)async{
          await db.execute("""
        CREATE TABLE $UserTable (
          contactid INTEGER, 
          lastname TEXT, 
          mobile TEXT
          )""");
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 2.0");
          }
        }
    );
    print('BASE DE DATOS CHECK');
    return openDb;
  }


}