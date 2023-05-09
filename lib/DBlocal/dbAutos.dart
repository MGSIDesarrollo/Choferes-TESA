/*
Developed by: Vanessa Garcia - 2022
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseAutos {

  SqfliteDatabaseAutos.internal();

  static final SqfliteDatabaseAutos instancev = new SqfliteDatabaseAutos.internal();

  factory SqfliteDatabaseAutos() => instancev;

  static final AutosTable = 'autos';

  static Database? _dbd;


  Future<Database?> get db async {
    if (_dbd != null) {
      return _dbd;
    }
    _dbd = await initBD();
    return _dbd;
  }

  Future<Database> initBD()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPathbd = join(directory.path,'vautos.bd');
    print('path task: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 2,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $AutosTable (
          id_vehiculo TEXT, 
          vehiculo TEXT, 
          tipovehiculo TEXT,
          num_serie TEXT,
          vehiculosid TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 2");
          }
        }
    );
    print('BASE DE DATOS AUTOS LISTA');
    return open;
  }
}