import 'package:http/http.dart' as htpp;

import '../DBlocal/consultas.dart';
import '../DBlocal/database.dart';
import '../conexion/urls.dart';
import '../gastos/controllerGastoDetails.dart';
import 'package:http/http.dart' as http;

class SyncInsertG {

  final conectargd = DatabaseHelper.instance;

  Future<List<GastoD>> buscarInfoGastos()async{
    print('infogastos');
    final _db = await conectargd.db;
    var table = 'GastosDetalles';
    List<GastoD> cambiosGastos = [];
    try {
      String consulta = 'SELECT * FROM $table where gasto_id = "local"';
      //print("Realizando la consulta: $consulta"); // Imprime la consulta antes de ejecutarla.
      List<Map<String, dynamic>> maps = await _db.rawQuery(consulta);
      //List<Map<String, dynamic>> maps = await _db.rawQuery('SELECT * FROM $table where gasto_id = "local"');
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
        'vehiculo_id': cambiosGastos[i].vehiculo_id.toString(),
        'folio': cambiosGastos[i].folio.toString(),
      };
      final response = await http.post(Uri.parse(PRE_URL + '/sincronizadorGastos.php') ,body: data);
      if (response.statusCode==200) {
        await Controllerconsulta().deleteDataGastosDetails(cambiosGastos[i].gastosid.toString());
        await Controllerconsulta().deleteDataGastos(cambiosGastos[i].gastosid.toString());
      }else{
        print('Error en la insercion '+ response.statusCode.toString() + ' '+response.body.toString());
      }
    }
  }
}