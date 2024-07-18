import 'dart:convert';

import 'package:choferes/AddViajes.dart';
import 'package:choferes/funciones/alertas.dart';
import 'package:choferes/homeGastos.dart';
import 'package:choferes/homeViajes.dart';
import 'package:choferes/reglamento.dart';
import 'package:choferes/request.dart';
import 'package:choferes/selectVehiculo.dart';
import 'package:choferes/sincronizador/syncGastos.dart';
import 'package:choferes/sincronizador/syncViajes.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'detallesVehiculo.dart';
import 'estadisticas.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';
import 'funciones/widgets.dart';
import 'homeHistorial.dart';
import 'lectorQR.dart';

class Home extends StatefulWidget {

  static const routeName = '/Home';
  Home({Key? key,}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool? _save;
  Map? _arguments;

  @override
  void initState(){
    super.initState();

    isInteret();
    Conn.isInternet().then((connection){
      if(connection){
        syncToMysql();
      }
    });
   // userList();
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return
      Scaffold(
        appBar: AppBar(
         foregroundColor: LIGHT,
         title: Center(
           child: Image.asset(
             "assets/images/logo_tesa.png",
             height: MediaQuery.sizeOf(context).height * 0.05,
             fit: BoxFit.cover,
           ),
         ),
         backgroundColor: DARK_BLUE_COLOR,
        ),
        body:
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    menuItem('Viajes', Icons.directions_bus, context, HomeViajes(info: _arguments!['datos'],), DARK_BLUE_GHOST_COLOR),
                    menuItem('Gastos', Icons.attach_money, context, HomeGastos(info: _arguments!['datos'],), Colors.redAccent),
                  ],),Row(children: [
                    menuItem('Viajes Completados', Icons.history_toggle_off, context, HomeHistorial(info: _arguments!['datos'],), Colors.green),
                    menuItem('Estadísticas', Icons.ssid_chart, context, Estadisticas(info: _arguments!['datos'],), Colors.amber[200]!),
                  ],),Row(children: [
                    menuItem('Chequeo de qr', Icons.qr_code_2, context, QRScannerPage(), Colors.teal),
                    menuItem('Cambiar vehículo', Icons.drive_eta_sharp, context, SelectVehiculo(info: _arguments!['datos'], mostrarAppBar: false,), Colors.grey),
                  ],),Row(children: [
                    menuItem('Reglamento', Icons.newspaper, context, ReglamentoOperadores(), Colors.grey),
                    menuItem('Detalles de vehiculo', Icons.info, context, DetallesVehiculo(info: _arguments!['datos'],), Colors.grey),
                    //Expanded(child: Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 0), child: Container(height: MediaQuery.sizeOf(context).height/4, child: Text(''),))),
                  ],),
                  SizedBox(height: 10,),
                ],),
            ),
          ),
      );
  }

  //proceso para subir y actualizar viajes y gastos en mysql
  Future syncToMysql() async {
    print('synctomy');
    List<dynamic>? eliminados = await getViajesDel(_arguments!['datos'].id.toString()); //trae los IDs de viajes eliminados en el crm
    if (eliminados != null) {
      for (String id in eliminados) {
        Controllerconsulta().delDataTravel(id); //Elimina en la BD local los registros con los IDs encontrados
      }
    }
    print('antes gastos');
    await SyncInsertG().buscarInfoGastos().then((gastosList) async {
      print('Sincronizacion gastos '+gastosList.toString());
      if(gastosList.length > 0){
        await showToast(context, 'No cierre la aplicacion. Estamos sincronizando los datos...', background: Colors.blueGrey);
        await SyncInsertG().saveToMysqlGastos(gastosList, _arguments!['datos'].id.toString()).then((_) async {
          await showToast(context, 'Sincronización de gastos realizada correctamente', background: Colors.blueGrey);
        });
      }else{
        print("no hay datos de gastos por sincronizar");
      }
    });

    await SyncInsertV().fetchAllInfoViajes().then((viajesList) async {
      if(viajesList.length > 0){
        await showToast(context, 'No cierre la aplicacion. Estamos sincronizando los datos...', background: Colors.blueGrey);
        await SyncInsertV().saveToMysqlViajes(viajesList, _arguments!['datos'].id.toString()).then((_) async {

          for (var i = 0; i < viajesList.length; i++) {
            /*await Controllerconsulta().deleteDataDetailsTravel(viajesList[i].viajesid.toString());
            await Controllerconsulta().deleteDataTravel(viajesList[i].viajesid.toString());

            if(viajesList[i].horario_final != ''){
              await Controllerconsulta().deleteDataTravelFIN(viajesList[i].viajesid.toString());
              await Controllerconsulta().deleteDataDetailsTravelFIN(viajesList[i].viajesid.toString());
            }*/
          }
          await showToast(context, 'Sincronización de viajes realizada correctamente', background: Colors.blueGrey);
        });
      }else{
        print("no hay datos de viajes por sincronizar");
      }
    });
  }

  Future<String?> isInteret()async{
    await Conn.isInternet().then((connection){
      if (connection) {
        //showToast(context, 'Sincronización de gastos realizada correctamente', background: Colors.blueGrey);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              children: <Widget>[
                Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                Text("       Conectado a Internet")
              ]
          ),
        ));
      }else{
        //showToast(context, 'Sincronización de gastos realizada correctamente', background: Colors.blueGrey);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              children: <Widget>[
                /*Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                ),*/
                Text("En este momento no tienes conexión a Internet")
              ]
          ),
        ));
      }
    });
  }
}