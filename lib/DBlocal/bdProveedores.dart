/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseproveedores {

  SqfliteDatabaseproveedores.internal();

  static final SqfliteDatabaseproveedores instancep = new SqfliteDatabaseproveedores.internal();

  factory SqfliteDatabaseproveedores() => instancep;

  static final ProveedoresTable = 'proveedores';

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
    String dbPathbd = join(directory.path,'proveevane.bd');
    print('path task: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 1,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $ProveedoresTable (
          targetvalues TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 1");
          }
        }
    );
    print('BASE DE DATOS PROVEEDORES LISTA');
    return open;
  }
}