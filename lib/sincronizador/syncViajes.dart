/*
Developed by: Vanessa Garcia - 2023
Description: este sincronizador nos ayuda a insertar los cambios de c/viaje en mysql
 */

import 'package:http/http.dart' as htpp;

import '../DBlocal/bdViajeDetails.dart';
import '../conexion/urls.dart';
import '../viajes/controllerDetailsV.dart';
import 'package:http/http.dart' as http;

class SyncInsertV{

  final conexion = SqfliteDatabaseDetailsTravel.instanceado;
  final tabla = SqfliteDatabaseDetailsTravel.DTravelTable;


  Future<List<ViajeD>> fetchAllInfoViajes()async{
    final dbClient = await conexion.db;
    List<ViajeD> viajesList = [];
    try {
      final maps = await dbClient!.query(SqfliteDatabaseDetailsTravel.DTravelTable);
      for (var item in maps) {
        viajesList.add(ViajeD.fromJSON(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return viajesList;
  }

  Future saveToMysqlViajes(List<ViajeD> cambiosList, String id)async{
    for (var i = 0; i < cambiosList.length; i++) {
      Map<String, dynamic> data = {
        'id_user': id.toString(),
        'viajesid': cambiosList[i].viajesid.toString(),
        'viaje_id': cambiosList[i].viaje_id.toString(),
        'fecha': cambiosList[i].fecha.toString(),
        'ruta_id': cambiosList[i].ruta_id.toString(),
        'comentario': cambiosList[i].comentario.toString(),
        'horario_inicio' : cambiosList[i].horario_inicio.toString(),
        'horario_final': cambiosList[i].horario_final.toString(),
        'kil_ini': cambiosList[i].kil_ini.toString(),
        'kil_fin': cambiosList[i].kil_fin.toString(),
        'vehiculosid' : cambiosList[i].vehiculosid.toString(),
        'idcliente': cambiosList[i].idcliente.toString(),
      };
      //i++;
      final response = await http.post(Uri.parse(PRE_URL + '/sincronizadorViajes.php') ,body: data);
      if (response.statusCode==200) {
        print("Datos insertados viajes nuevo");
      }else{
        print(response.statusCode);
      }
    }
  }
}