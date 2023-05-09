import 'dart:convert';
import 'dart:io';
import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'conexion/urls.dart';
import 'controller/Usuario.dart';

//login request
Future<Usuario?> loginReq(String usr, String pass) async {

  var url = PRE_URL + '/login.php';

  var response = await http.post(Uri.parse(url), body:{
    'user': usr,
    'pass': pass
  });

  if(response.statusCode != 200){
    return null;
  }

  var data;

  try{
    data = jsonDecode(response.body);

  }catch(e){
    print(e.toString());
    return null;
  }

  if(data['status']==200 && data['data']!=null){
    return Usuario.fromJSON(data['data']);
    //return data['data'];
  }

  return null;
}

///Login with persistence
Future<Usuario?> loadSessionReq( String hash ) async {

  var url = PRE_URL + '/load-session.php';
  var response = await http.post(Uri.parse(url), body: {
    'hash-key': hash,
  });

  if (response.statusCode!=200) {
    return null;
  }
  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  if(data['status']==200 && data['data']!=null){
    return Usuario.fromJSON(data['data']);
  }

  return null;
}

/// Save token and hash.
Future<bool?> saveTokenReq( String fcmToken, String hash, String id ) async {
  var url = PRE_URL + '/hash-token-save.php';

  var response = await http.post(Uri.parse(url), body: {
    'token': fcmToken,
    'hash': hash,
    'id': id
  });

  if (response.statusCode!=200) {
    return null;
  }
  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  return data['status']==200;

}


Future<List<dynamic>?> getViajes(String id) async {

  var url = PRE_URL + '/getViajes.php';

  var response = await http.post(Uri.parse(url), body:{
    'id': id
  });
  if(response.statusCode!=200){
    return null;
  }

  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  if(data['status']==200){
    return data['data'];
  }
  return null;
}

Future<ViajeD?> getviajeDetails(String id, String id_viaje) async {

  var url = PRE_URL + '/getViajesDetails.php';

  var response = await http.post(Uri.parse(url), body: {
    'id': id,
    'id_viaje': id_viaje.toString(),
  });

  if(response.statusCode!=200){
    return null;
  }

  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  if(data['status']==200){
    return ViajeD.fromJSON(data['data']);
  }
  return null;
}

Future<dynamic> update_kIni(String id, String id_viaje, String km_inicial, String fecha_hora, String comentarios) async{
  var url = PRE_URL+'/update_kini.php';
  var response = await http.post(Uri.parse(url), body: {
    "id": id,
    "id_viaje": id_viaje,
    "km_inicial": km_inicial,
    "fecha_hora": fecha_hora,
    "comentarios":comentarios
  });

  if(response==null) {
    return null;
  }
  var data;
  try{
    data = jsonDecode(response.body);
  }catch(e){
    return null;
  }

  return data['data'];
}

Future<dynamic> update_kFin(String id, String id_viaje, String km_fin, String fecha_hora,String pasajeros, String comentarios) async{
  var url = PRE_URL+'/update_kfin.php';
  var response = await http.post(Uri.parse(url), body: {
    "id": id,
    "id_viaje": id_viaje,
    "km_fin": km_fin,
    "fecha_hora": fecha_hora,
    "pasajeros":pasajeros,
    "comentarios":comentarios
  });

  if(response==null) {
    return null;
  }
  var data;
  try{
    data = jsonDecode(response.body);
  }catch(e){
    return null;
  }

  return data['data'];
}

//function to get the vehiculos
Future<List<dynamic>?> getAutos() async {

  var url = PRE_URL + '/vehiculos.php';

  var response = await http.post(Uri.parse(url));
  var data = jsonDecode(response.body);

  if(response==null) {
    return null;
  }

  //if(data['status'] == 200){
  return data['data'];
 // }

  //return null;
}

//function to get the clientes
Future<List<dynamic>?> getClientes() async {

  var url = PRE_URL + '/clientes.php';

  var response = await http.post(Uri.parse(url));
  var data = jsonDecode(response.body);

  if(response==null) {
    return null;
  }

  //if(data['status'] == 200){
  return data['data'];
  // }

  //return null;
}

//function to get the vehiculos
Future<List<dynamic>?> getRutas(String id, String tipov) async {

  var url = PRE_URL + '/rutas.php';

  var response = await http.post(Uri.parse(url),body: {
    'id_cliente': id,
    'tipov': tipov
  });
  var data = jsonDecode(response.body);

  if(response==null) {
    return null;
  }

  //if(data['status'] == 200){
  return data['data'];
  // }

  //return null;
}

//function to get the rutas off conection
Future<List<dynamic>?> getRutasoff() async {

  var url = PRE_URL + '/rutasOC.php';

  var response = await http.post(Uri.parse(url));
  var data = jsonDecode(response.body);

  if(response==null) {
    return null;
  }

  //if(data['status'] == 200){
  return data['data'];
  // }

  //return null;
}

//function to get the proveedores
Future<List<dynamic>?> getProveedores() async {

  var url = PRE_URL + '/proveedores.php';

  var response = await http.post(Uri.parse(url));
  var data = jsonDecode(response.body);

  if(response==null) {
    return null;
  }

  //if(data['status'] == 200){
  return data['data'];
  // }

  //return null;
}

//function para resgistrar las visitas
Future<ViajeD?> guardarViajes(String id, String id_cliente, String id_ruta, String id_vehiculo, String observacion, String fecha_hora, String km_ini)async{

  var url = PRE_URL + '/guardarViaje.php';

  var response = await http.post(Uri.parse(url), body:{
    'id_user': id,
    'id_cliente': id_cliente,
    'id_ruta': id_ruta,
    'id_vehiculo': id_vehiculo,
    'observaciones': observacion,
    'km_ini': km_ini,
    'fecha_hora': fecha_hora
  });

  if(response.statusCode != 200){
    return null;
  }

  var data;

  try{
    data = jsonDecode(response.body);
  }catch(e){
    print('error: '+e.toString());
    return null;
  }

  if(data['status'] == 200){
    return ViajeD.fromJSON(data['data']);
  }

  return null;
}

Future<List<dynamic>?> getGastos(String id) async {

  var url = PRE_URL + '/getGastos.php';

  var response = await http.post(Uri.parse(url), body:{
    'id': id
  });
  if(response.statusCode!=200){
    return null;
  }

  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  if(data['status']==200){
    return data['data'];
  }
  return null;
}

Future<GastoD?> getGastoDetails(String id, String idgasto) async {

  var url = PRE_URL + '/getGastosDetails.php';

  var response = await http.post(Uri.parse(url), body: {
    'id': id,
    'idgasto': idgasto.toString(),
  });

  if(response.statusCode!=200){
    return null;
  }

  var data;

  try {
    data = jsonDecode(response.body);
  } catch (e) {
    return null;
  }

  if(data['status']==200){
    return GastoD.fromJSON(data['data']);
  }
  return null;
}

//function para resgistrar las visitas
Future<GastoD?> guardarGastos(String id, String proveedor, String precio_litro, String kilometraje, String observacion, String fecha_hora, String litros, String id_vehiculo, String pago, String concepto)async{

  var url = PRE_URL + '/guardarGastos.php';

  var response = await http.post(Uri.parse(url), body:{
    'id_user': id,
    'concepto': concepto,
    'pago': pago,
    'id_vehiculo': id_vehiculo,
    'observaciones': observacion,
    'litros': litros,
    'kilometraje': kilometraje,
    'precio_litro': precio_litro,
    'proveedor': proveedor,
    'fecha_hora': fecha_hora,

  });

  if(response.statusCode != 200){
    return null;
  }

  var data;

  try{
    data = jsonDecode(response.body);
  }catch(e){
    print('error: '+e.toString());
    return null;
  }

  if(data['status'] == 200){
    return GastoD.fromJSON(data['data']);
  }

  return null;
}