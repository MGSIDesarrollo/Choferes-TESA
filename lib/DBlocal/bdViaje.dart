/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseViaje {

  SqfliteDatabaseViaje.internal();

  static final SqfliteDatabaseViaje instancei = new SqfliteDatabaseViaje.internal();

  factory SqfliteDatabaseViaje() => instancei;

  static final TaskTable = 'viaje';

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
    String dbPathbd = join(directory.path,'vaneviaje.bd');
    print('path task: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 3,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $TaskTable (
          viajesid TEXT, 
          viaje_id TEXT, 
          fecha TEXT,
          hora_prev TEXT,
          vehiculo_id TEXT,
          ruta_id TEXT,
          accountname TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 3");
          }
        }
    );
    print('BASE DE DATOS  VIAJE LISTA');
    return open;
  }
}