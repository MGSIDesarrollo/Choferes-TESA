import 'dart:convert';

import 'package:choferes/DBlocal/consultas.dart';
import 'package:choferes/DBlocal/database.dart';
import 'package:http/http.dart' as htpp;

import '../DBlocal/database.dart';
import '../conexion/urls.dart';
import '../viajes/controllerDetailsV.dart';
import 'package:http/http.dart' as http;

class SyncInsertV{

  final conexion = DatabaseHelper.instance;
  final tabla = 'ViajesDetalles';


  Future<List<ViajeD>> fetchAllInfoViajes()async{
    final _db = await conexion.db;
    List<ViajeD> viajesList = [];
    try {
      final maps = await _db.query('ViajesDetalles');
      for (var item in maps) {
        //print('item count '+ViajeD.fromJSON(item).toString());
        var element = ViajeD.fromJSON(item);
        print(element);
        viajesList.add(element);
      }
    } catch (e) {
      print(e.toString());
    }
    print(viajesList.toString());
    return viajesList;
  }

  Future saveToMysqlViajes(List<ViajeD> cambiosList, id)async{
    for (var i = 0; i < cambiosList.length; i++) {
      try {
        var data = cambiosList[i].toJSON();
        data['id_user'] = id;
        String localid = cambiosList[i].viajesid ?? '';
        final response = await http.post(Uri.parse(PRE_URL + '/sincronizadorViajes.php'), body: data);
        if (response.statusCode == 200) {
          data = jsonDecode(response.body);
          if (response.body[1] != 'eliminar') {
            Controllerconsulta().updateTravelIDs(
                data['data']['viajesid'].toString(),
                data['data']['viaje_id'].toString(), localid);
            print("Datos insertados viajes nuevo " +
                data.toString());
          }
        } else {
          print('en error');
          print(response.statusCode);
        }
      }catch (e){print('error en viaje '+cambiosList[i].toString());
      }
    }
  }
}