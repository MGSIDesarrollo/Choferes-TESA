/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseRutas {

  SqfliteDatabaseRutas.internal();

  static final SqfliteDatabaseRutas instancer = new SqfliteDatabaseRutas.internal();

  factory SqfliteDatabaseRutas() => instancer;

  static final RutasTable = 'Rutas';

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
    String dbPathbd = join(directory.path,'rutastesa.bd');
    //print('path rutas: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 2,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $RutasTable (
          costorutaid TEXT, 
          estado TEXT, 
          desc_ruta TEXT,
          tipo TEXT, 
          costo TEXT, 
          comison TEXT,
          ruta_id TEXT,
          cliente TEXT,
          tipov TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 2 r");
          }
        }
    );
    print('BASE DE DATOS RUTAS CHECK');
    return open;
  }

}