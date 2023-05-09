/*
Developed by: Vanessa Garcia - 2023
Description: este sincronizador nos ayuda a insertar los cambios de c/gasto en mysql
 */

import 'package:http/http.dart' as htpp;

import '../DBlocal/bdGastosDetails.dart';
import '../conexion/urls.dart';
import '../gastos/controllerGastoDetails.dart';
import 'package:http/http.dart' as http;

class SyncInsertG {

  final conectargd = SqfliteDatabaseDetailsGastos.instanceadogd;
  final tablagd = SqfliteDatabaseDetailsGastos.DGastosTable;


  Future<List<GastoD>> buscarInfoGastos()async{
    final dbClient = await conectargd.db;
    var table = await tablagd;
    List<GastoD> cambiosGastos = [];
    try {
      List<Map<String, dynamic>> maps = await dbClient!.rawQuery('SELECT * FROM $table where gasto_id = "local"');
      for (var item in maps) {
        cambiosGastos.add(GastoD.fromJSON(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return cambiosGastos;
  }

  Future saveToMysqlGastos(List<GastoD> cambiosGastos, String id)async{
    for (var i = 0; i < cambiosGastos.length; i++) {
      Map<String, dynamic> data = {
        'id_user': id.toString(),
        'gastosid': cambiosGastos[i].gastosid.toString(),
        'gasto_id': cambiosGastos[i].gasto_id.toString(),
        'concepto': cambiosGastos[i].concepto.toString(),
        'tipo_pago': cambiosGastos[i].tipo_pago.toString(),
        'proveedor': cambiosGastos[i].proveedor.toString(),
        'litros': cambiosGastos[i].litros.toString(),
        'precio_litro':cambiosGastos[i].precio_litro.toString(),
        'kilometraje': cambiosGastos[i].kilometraje.toString(),
        'comentario': cambiosGastos[i].comentario.toString(),
        'fecha_gasto' : cambiosGastos[i].fecha_gasto.toString(),
        'hora' : cambiosGastos[i].hora.toString(),
        'vehiculo_id': cambiosGastos[i].vehiculo_id.toString()
      };
      //i++;
      final response = await http.post(Uri.parse(PRE_URL + '/sincronizadorGastos.php') ,body: data);
      if (response.statusCode==200) {
        print("Datos insertados gastos");
      }else{
        print(response.statusCode);
      }
    }
  }


}