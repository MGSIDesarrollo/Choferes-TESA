
import 'package:choferes/DBlocal/bdCliente.dart';
import 'package:choferes/DBlocal/bdGastos.dart';
import 'package:choferes/DBlocal/bdGastosDetails.dart';
import 'package:choferes/DBlocal/bdProveedores.dart';
import 'package:choferes/DBlocal/dbAutos.dart';
import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/gastos/controllerGastos.dart';
import 'package:choferes/viajes/controllerClientes.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerProveedores.dart';
import 'package:choferes/viajes/controllerRutas.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:sqflite/sqflite.dart';

import '../controller/Usuario.dart';
import '../viajes/controllerViajes.dart';
import 'bdLogin.dart';
import 'bdRutas.dart';
import 'bdViaje.dart';
import 'bdViajeDetails.dart';

class Controllerconsulta {

  final conn = SqfliteDatabase.instance;
  final connection = SqfliteDatabaseViaje.instancei;
  final tablita = SqfliteDatabaseViaje.TaskTable;
  final conexion = SqfliteDatabaseDetailsTravel.instanceado;
  final tabla = SqfliteDatabaseDetailsTravel.DTravelTable;
  final conectar = SqfliteDatabaseAutos.instancev;
  final table = SqfliteDatabaseAutos.AutosTable;
  final conectarnos = SqfliteDatabaseClientes.instancec;
  final tableta = SqfliteDatabaseClientes.ClientesTable;
  final conectarr = SqfliteDatabaseRutas.instancer;
  final tab = SqfliteDatabaseRutas.RutasTable;
  final conectarg = SqfliteDatabaseGastos.instanceg;
  final tablag = SqfliteDatabaseGastos.GastosTable;
  final conectargd = SqfliteDatabaseDetailsGastos.instanceadogd;
  final tablagd = SqfliteDatabaseDetailsGastos.DGastosTable;
  final conectarp = SqfliteDatabaseproveedores.instancep;
  final tablap = SqfliteDatabaseproveedores.ProveedoresTable;

  /////////////////////////////////// LOGIN //////////////////////////////////////

  //llenar la taba de users al logearse con conexion
  Future<int> addDataLogin(Usuario usuario) async {
    var dbclient = await conn.db;
    int result = 0;
    try {
      result = await dbclient!.insert(
          SqfliteDatabase.UserTable, usuario.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //traernos los datos del usuario sin conexion
  Future <List<Usuario>?> queryDataLogin() async {
    var dbclient = await conn.db;

    try {
      final queryResult = await dbclient!.query(SqfliteDatabase.UserTable, limit: 1);
      return queryResult.isNotEmpty ? queryResult.map((e) => Usuario.fromJSON(e)).toList() : null;
    } catch (error) {
      print(error.toString());
    }
  }

  /////////////////////////////////// VIAJE ///////////////////////////////////

  //llenar la taba de viajes para verlos sin conexion
  Future<int> addDataTravel(Viaje viaje) async {
    var dbclient = await connection.db;
    int result =0;
    try {
      result = await dbclient!.insert(
          SqfliteDatabaseViaje.TaskTable, viaje.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe un viaje
  Future <int> queryCountTravel(String id) async {
    var dbclient = await connection.db;
    var table = await tablita;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $table where viajesid = $id'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de las tareas
  Future queryDataTravel() async {
    var dbclient = await connection.db;
    List viajeList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseViaje.TaskTable, orderBy: 'viajesid DESC');
      for (var item in maps) {
        viajeList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return viajeList;
  }

  //traernos los detalles de los viajes
  Future<int> queryDataTravelID() async {
    var dbclient = await connection.db;
    var table = await tablita;

    int travelList = 0;
    // try {
     travelList = Sqflite.firstIntValue(await dbclient!.rawQuery("SELECT viajesid FROM $table order by viajesid DESC"))!;
    //return travelList.isNotEmpty ? travelList.map((e) => Viaje.fromJSON(e)).toList() : null;

     return travelList;
  }

  Future<int> deleteDataTravel(String id) async {
    var dbclient = await connection.db;
    int result =0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseViaje.TaskTable,
          where: 'viajesid=? and viaje_id=?', whereArgs: [id, 'local']);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> deleteDataTravelFIN(String id) async {
    var dbclient = await connection.db;
    int result =0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseViaje.TaskTable,
          where: 'viajesid=?', whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  /////////////////////////////// DETALLES VIAJES //////////////////////////////

  //llenar la tabla de detalles de viajes para verlos sin conexion
  Future<int> addDataDetails(ViajeD detalles) async {
    var dbclient = await conexion.db;
    int result = 0;
    try {
      result = await dbclient!.insert(
          SqfliteDatabaseDetailsTravel.DTravelTable, detalles.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //traernos los detalles de los viajes
  Future<List<ViajeD>?> queryDataDetails(id) async {
    var dbclient = await conexion.db;
    var table = await tabla;

   // List travelList = [];
   // try {
    final travelList = await dbclient!.rawQuery("SELECT * FROM $table where viajesid = $id");
    return travelList.isNotEmpty ? travelList.map((e) => ViajeD.fromJSON(e)).toList() : null;
    /*for (var item in maps) {
        travelList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }*/
   // return travelList;
  }

  //Actualizar los status de las tareas
  Future<int> updateDataTravel(ViajeD detalles) async {
    var dbclient = await conexion.db;
    int result = 0;
    try {
      result = await dbclient!.update(
          SqfliteDatabaseDetailsTravel.DTravelTable, detalles.toJSON(),
          where: 'viajesid=?', whereArgs: [detalles.viajesid]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> deleteDataDetailsTravel(String id) async {
    var dbclient = await conexion.db;
    int result =0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseDetailsTravel.DTravelTable,
          where: 'viajesid=? and viaje_id=?', whereArgs: [id, 'local']);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> deleteDataDetailsTravelFIN(String id) async {
    var dbclient = await conexion.db;
    int result =0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseDetailsTravel.DTravelTable,
          where: 'viajesid=?', whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  /////////////////////////////////// AUTOS ////////////////////////////////////
  //llenar la tabla de detalles de vehiculos para traerlos sin conexion
  Future<int> addDataVehiculos(Vehiculo vehiculo) async {
    var dbvehiculo = await conectar.db;
    int result = 0;
    try {
      result = await dbvehiculo!.insert(
          SqfliteDatabaseAutos.AutosTable, vehiculo.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe un vehiculo
  Future <int> queryCountVehiculos(String id) async {
    var dbclient = await conectar.db;
    var tabl = await table;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $tabl where vehiculosid = $id'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de las tareas
  Future queryDataVehiculos() async {
    var dbclient = await conectar.db;
    List autosList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseAutos.AutosTable, orderBy: 'vehiculosid DESC');
      for (var item in maps) {
        autosList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return autosList;
  }

  //////////////////////////////////CLIENTES////////////////////////////////////
  //llenar la tabla de clientes para traerlos sin conexion
  Future<int> addDataClientes(Clientes clientes) async {
    var dbcliente = await conectarnos.db;
    int result = 0;
    try {
      result = await dbcliente!.insert(
          SqfliteDatabaseClientes.ClientesTable, clientes.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe un cliente
  Future <int> queryCountClientes(String id) async {
    var dbclient = await conectarnos.db;
    var tabletita = await tableta;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $tabletita where accountid = $id'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de los clientes
  Future queryDataClientes() async {
    var dbclient = await conectarnos.db;
    List cientesList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseClientes.ClientesTable);
      for (var item in maps) {
        cientesList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return cientesList;
  }

  ///////////////////////////////////RUTAS//////////////////////////////////////
//llenar la tabla de rutas para traerlos sin conexion
  Future<int> addDataRutas(Rutas rutas) async {
    var dbcliente = await conectarr.db;
    int result = 0;
    try {
      result = await dbcliente!.insert(
          SqfliteDatabaseRutas.RutasTable, rutas.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe una rutas
  Future <int> queryCountRutas(String id) async {
    var dbclient = await conectarr.db;
    var tabletita = await tab;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $tabletita where costorutaid = $id'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de las rutas
  Future queryDataRutas() async {
    var dbclient = await conectarr.db;
    List rutasList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseRutas.RutasTable, orderBy: 'costorutaid DESC');
      for (var item in maps) {
        rutasList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return rutasList;
  }
///////////////////////////////////GASTOS///////////////////////////////////////
  //llenar la tabla de gastos para verlos sin conexion
  Future<int> addDataGastos(Gastos gastos) async {
    var dbclient = await conectarg.db;
    int result =0;
    try {
      result = await dbclient!.insert(
          SqfliteDatabaseGastos.GastosTable, gastos.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe un gastos
  Future <int> queryCountGastos(String id) async {
    var dbclient = await conectarg.db;
    var table = await tablag;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $table where gastosid = $id'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de los gastos
  Future queryDataGastos() async {
    var dbclient = await conectarg.db;
    List gastosList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseGastos.GastosTable, orderBy: 'gastosid DESC');
      for (var item in maps) {
        gastosList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return gastosList;
  }

  //traernos los detalles de los gastos
  Future<int> queryDataGastosID() async {
    var dbclient = await conectarg.db;
    var table = await tablag;

    int gastosList = 0;
    // try {
    gastosList = Sqflite.firstIntValue(await dbclient!.rawQuery("SELECT gastosid FROM $table order by gastosid DESC"))!;
    //return travelList.isNotEmpty ? travelList.map((e) => Viaje.fromJSON(e)).toList() : null;

    return gastosList;
  }

  Future<int> deleteDataGastos(String id) async {
    var dbclient = await conectarg.db;
    int result =0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseGastos.GastosTable,
          where: 'gastosid=?', whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  /////////////////////////////// DETALLES GASTOS //////////////////////////////

  //llenar la tabla de detalles de viajes para verlos sin conexion
  Future<int> addDataGastosDetails(GastoD gastosd) async {
    var dbclient = await conectargd.db;
    int result = 0;
    try {
      result = await dbclient!.insert(
          SqfliteDatabaseDetailsGastos.DGastosTable, gastosd.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //traernos los detalles de los viajes
  Future<List<GastoD>?> queryDataGastosDetails(id) async {
    var dbclient = await conectargd.db;
    var table = await tablagd;

    // List travelList = [];
    // try {
    final travelList = await dbclient!.rawQuery("SELECT * FROM $table where gastosid = $id");
    return travelList.isNotEmpty ? travelList.map((e) => GastoD.fromJSON(e)).toList() : null;
    /*for (var item in maps) {
        travelList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }*/
    // return travelList;
  }

  Future<int> deleteDataGastosDetails(String id) async {
    var dbclient = await conectargd.db;
    int result = 0;
    try {
      result = await dbclient!.delete(SqfliteDatabaseDetailsGastos.DGastosTable,
          where: 'gastosid=?', whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //////////////////////////////// PROVEEDORES /////////////////////////////////
  //llenar la tabla de detalles de proveedores para traerlos sin conexion
  Future<int> addDataProveedores(Proveedores proveedores) async {
    var dbproveedores = await conectarp.db;
    int result = 0;
    try {
      result = await dbproveedores!.insert(
          SqfliteDatabaseproveedores.ProveedoresTable, proveedores.toJSON());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  //consultar si ya existe un proveedores
  Future <int> queryCountProveedores() async {
    var dbclient = await conectarp.db;
    var tabl = await tablap;
    int result = 0;
    try {
      result = Sqflite.firstIntValue(await dbclient!.rawQuery('SELECT COUNT(*) FROM $tabl'))!;
    } catch (error) {
      print(error.toString());
    }
    return result;
  }

  //traernos los datos de las proveedores
  Future queryDataProveedores() async {
    var dbclient = await conectarp.db;
    List proveeList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient!.query(
          SqfliteDatabaseproveedores.ProveedoresTable);
      for (var item in maps) {
        proveeList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return proveeList;
  }



}