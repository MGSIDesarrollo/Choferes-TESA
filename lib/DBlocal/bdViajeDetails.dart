/*
Developed by: Vanessa Garcia - 2023
 */
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseDetailsTravel {

  SqfliteDatabaseDetailsTravel.internal();

  static final SqfliteDatabaseDetailsTravel instanceado = new SqfliteDatabaseDetailsTravel.internal();

  factory SqfliteDatabaseDetailsTravel() => instanceado;

  static final DTravelTable = 'ViajesDetalles';

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
    String dbPathbd = join(directory.path,'viajedetalles.bd');
    print('path dviaje: '+dbPathbd);
    var open = await openDatabase(dbPathbd,version: 5,
        onCreate: (Database db,int version)async{
          await db.execute('''
        CREATE TABLE $DTravelTable (
          viajesid TEXT, 
          viaje_id TEXT, 
          nombre_ruta TEXT, 
          fecha TEXT,
          hora_prev TEXT,
          vehiculo_id TEXT,
          ruta_id TEXT,
          cliente TEXT,
          comentario TEXT,
          centro TEXT,
          horario_inicio TEXT,
          horario_final TEXT,
          kil_ini TEXT,
          kil_fin TEXT,
          vehiculosid TEXT,
          idcliente TEXT
          )''');
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Actualizada 5");
          }
        }
    );
    print('BASE DE DATOS DETALLES VIAJE LISTA');
    return open;
  }

}