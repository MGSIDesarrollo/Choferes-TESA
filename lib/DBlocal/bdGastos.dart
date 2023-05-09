/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseGastos {

  SqfliteDatabaseGastos.internal();

  static final SqfliteDatabaseGastos instanceg = new SqfliteDatabaseGastos.internal();

  factory SqfliteDatabaseGastos() => instanceg;

  static final GastosTable = 'gastos';

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
    String dbPathbd = join(directory.path,'vanegastos.bd');
    print('path gastos: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 1,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $GastosTable (
          gastosid TEXT, 
          gasto_id TEXT, 
          concepto TEXT,
          costo TEXT,
          proveedor TEXT,
          litros TEXT,
          fecha_gasto TEXT,
          vehiculo_id TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 1");
          }
        }
    );
    print('BASE DE DATOS GASTOS LISTA');
    return open;
  }
}