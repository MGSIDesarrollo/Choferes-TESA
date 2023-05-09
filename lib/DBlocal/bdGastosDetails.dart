/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseDetailsGastos {

  SqfliteDatabaseDetailsGastos.internal();

  static final SqfliteDatabaseDetailsGastos instanceadogd = new SqfliteDatabaseDetailsGastos.internal();

  factory SqfliteDatabaseDetailsGastos() => instanceadogd;

  static final DGastosTable = 'GastosDetalles';

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
    String dbPathbd = join(directory.path,'gastodetalles.bd');
    print('path dgasto: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 1,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $DGastosTable (
          gastosid TEXT, 
          gasto_id TEXT, 
          concepto TEXT, 
          tipo_pago TEXT,
          costo TEXT,
          proveedor TEXT,
          litros TEXT,
          precio_litro TEXT,
          kilometraje TEXT,
          comentario TEXT,
          fecha_gasto TEXT,
          km_ini TEXT,
          rendimiento TEXT,
          recorrido TEXT,
          hora TEXT,
          pxk TEXT,
          vehiculo_id TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 1");
          }
        }
    );
    print('BASE DE DATOS DETALLES GASTOS LISTA');
    return open;
  }

}