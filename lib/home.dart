import 'dart:convert';

import 'package:choferes/AddViajes.dart';
import 'package:choferes/homeGastos.dart';
import 'package:choferes/homeViajes.dart';
import 'package:choferes/request.dart';
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
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';


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

  /*List? list;
  bool loading = true;
  Future userList()async{
    list = await Controllerconsulta().queryDataTravel();
    setState(() {loading=false;});
    //print(list);
  }

  List? list2;
  bool loading2 = true;

  Future userList2(String id)async{
    list2 = await Controllerconsulta().queryDataDetails(id.toString());
    setState(() {loading2=false;});
    //print(list);
  }
*/

  //proceso para subir y actualizar viajes y gastos en mysql
  Future syncToMysql() async {
    List<dynamic>? eliminados = await getViajesDel(_arguments!['datos'].id.toString()); //trae los IDs de viajes eliminados en el crm
    if (eliminados != null) {
      for (String id in eliminados) {
        Controllerconsulta().delDataTravel(id); //Elimina en la BD local los registros con los IDs encontrados
      }
    }
    await SyncInsertG().buscarInfoGastos().then((gastosList) async {
      //print('gastos:' + gastosList.toString());
      if(gastosList.length > 0){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.blueGrey,
                content: Text("No cierre la aplicacion. Estamos sincronizando los datos...")
            ));

        await SyncInsertG().saveToMysqlGastos(gastosList, _arguments!['datos'].id.toString()).then((_) async {

          for (var i = 0; i < gastosList.length; i++) {
            await Controllerconsulta().deleteDataGastosDetails(gastosList[i].gastosid.toString());
              await Controllerconsulta().deleteDataGastos(gastosList[i].gastosid.toString());
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text("Sincronización de gastos realizada correctamente")
          ));
        });
      }else{
        print("no hay datos de gastos por sincronizar");
      }
    });

    await SyncInsertV().fetchAllInfoViajes().then((viajesList) async {
      print('viajes:   ' + viajesList.toString());
      if(viajesList.length > 0){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.blueGrey,
                content: Text("No cierre la aplicacion. Estamos sincronizando los datos...")
            ));
        await SyncInsertV().saveToMysqlViajes(viajesList, _arguments!['datos'].id.toString()).then((_) async {

          for (var i = 0; i < viajesList.length; i++) {
            await Controllerconsulta().deleteDataDetailsTravel(viajesList[i].viajesid.toString());
            await Controllerconsulta().deleteDataTravel(viajesList[i].viajesid.toString());

            if(viajesList[i].horario_final != ''){
              await Controllerconsulta().deleteDataTravelFIN(viajesList[i].viajesid.toString());
              await Controllerconsulta().deleteDataDetailsTravelFIN(viajesList[i].viajesid.toString());
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text("Sincronización de viajes realizada correctamente")
          ));
        });
      }else{
        print("no hay datos de viajes por sincronizar");
      }
    });
  }

  Future<String?> isInteret()async{
    await Conn.isInternet().then((connection){
      if (connection) {
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
        ),
        );
        print("Conectado a Internet");
      }else{
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
        ),
        );
        print("No tienes conexión a Internet");
      }
    });
  }

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
/*
  Widget _body(data){
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(3),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          borderOnForeground: true,
          elevation: 4,
          child: Container(
            margin: EdgeInsets.only(top: 4.0, left:3.0, bottom: 4.0),
            //children: <Widget>[
            child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text('${data[index]['viaje_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 16.0)),
                subtitle: Text(
                  "Inicio previsto: ${data[index]['fecha']} - ${data[index]['hora_prev']}\nVehiculo: ${data[index]['vehiculo_id']}\nRuta: ${data[index]['ruta_id']}\nCliente: ${data[index]['accountname']}",
                  style: TextStyle(color: Colors.black, fontSize: 13.5),
                ),
                onTap:(){
                  //print ('presionaste el viaje numero1:' + data[index]['viajesid']);
                  getviajeDetails(_arguments!['datos'].id.toString(), data[index]['viajesid']).then((value){
                   // print('revs detalles: ' + value.toString());
                    /*Navigator.pushNamed(
                        context,
                        '/viajeDetails',
                        arguments: {
                          'vinfo':value,
                          'id_user': _arguments!['datos'].id.toString()
                        }
                    );*/

                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                        detalles:value,
                        id_user: _arguments!['datos'].id.toString()
                    )
                    )
                    );
                    print(value);
                  });
                }
            ),
            // ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _bodyOffConnection(data){
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(3),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          borderOnForeground: true,
          elevation: 4,
          child: Container(
            margin: EdgeInsets.only(top: 4.0, left:3.0, bottom: 4.0),
            //children: <Widget>[
            child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text('${data[index]['viaje_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 16.0)),
                subtitle: Text(
                  "Inicio previsto: ${data[index]['fecha']} - ${data[index]['hora_prev']}\nVehiculo: ${data[index]['vehiculo_id']}\nRuta: ${data[index]['ruta_id']}\nCliente: ${data[index]['accountname']}",
                  style: TextStyle(color: Colors.black, fontSize: 13.5),
                ),
                onTap:(){
                  //print ('presionaste el viaje numero1:' + data[index]['viajesid']);
                  userList2(data[index]['viajesid']);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                        detalles:list2?[0],
                        id_user: _arguments!['datos'].id.toString()
                    )
                    )
                    );
                  print(data[index]['viajesid']);
                  print(list2?[0]);
                }
            ),
            // ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _tareas()=>FutureBuilder(
    future: getViajes(_arguments!['datos'].id.toString()),
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      if(snapshot.hasData) {
        if (snapshot.data.length==0) return emptyResponse;
       // print('snapshot viajes: ' + snapshot.data.length.toString());

        for (var i = 0; i < snapshot.data.length; i++){
          Controllerconsulta().queryCountTravel(snapshot.data[i]['viajesid'].toString()).then((value) {
            if(value>0){
              print('value travel if: ' + value.toString());
            }else{
              //INSERT table: viaje bd: vaneviaje
              Viaje viaje = Viaje(viajesid: snapshot.data[i]['viajesid'].toString(), viaje_id: snapshot.data[i]['viaje_id'].toString(), fecha: snapshot.data[i]['fecha'].toString(), hora_prev: snapshot.data[i]['hora_prev'].toString(), vehiculo_id: snapshot.data[i]['vehiculo_id'].toString(), ruta_id: snapshot.data[i]['ruta_id'].toString(), accountname: snapshot.data[i]['accountname'].toString());
              Controllerconsulta().addDataTravel(viaje).then((value){
                if(value>0){
                  print("correcta inserción del viaje");

                  getviajeDetails(_arguments!['datos'].id.toString(), snapshot.data[i]['viajesid'].toString()).then((value){

                    //print('detalles del viaje: ' +value!.viajesid.toString());
                    ViajeD viajeD = ViajeD(
                      viajesid: value!.viajesid,
                      viaje_id: value.viaje_id,
                      nombre_ruta: value.nombre_ruta,
                      fecha: value.fecha,
                      hora_prev: value.hora_prev,
                      vehiculo_id: value.vehiculo_id,
                      ruta_id: value.ruta_id,
                      cliente: value.cliente,
                      comentario: value.comentario,
                      centro: value.centro,
                      horario_inicio: value.horario_inicio,
                      horario_final: value.horario_final,
                      kil_ini: value.kil_ini,
                      kil_fin: value.kil_fin,
                      vehiculosid: value.vehiculosid,
                      idcliente: value.idcliente,
                    );

                    Controllerconsulta().addDataDetails(viajeD).then((value){

                      if (value>0) {
                        print('valor en el insert: ' + value.toString());
                        print("correcta inserción de detalles");
                      }else{
                        print("fallo insercion detalles");
                      }
                    });

                  });
                }else{
                  print('fallo la insercion del viaje');
                }//else
              });
            }//else
          });
        }
          return _body(snapshot.data);
      }else {
       // return progressWidget;

        if (loading && loading2) {
          return Center(child: progressWidget);
        } else {
          return _bodyOffConnection(list);
        }
      }
    },
  );
*/

  @override
  Widget build(BuildContext context) {

    _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _save = _arguments!['save'];
    if (!_save!) {
      _firebaseMessaging.getToken().then((res) {
        var key = utf8.encode(_arguments!['datos'].telefono);
        var bytes = utf8.encode(_arguments!['datos'].nombres);

        var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
        var digest = hmacSha256.convert(bytes);
         print('token' + res.toString());
        saveSessionFunct(digest.toString());
        saveTokenReq(
            res!,
            digest.toString(),
            _arguments!['datos'].id.toString()
        );
        _save = true;
      });
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:
         PreferredSize(
              preferredSize: Size.fromHeight(98.0),
              child: AppBar(
                title: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/logo_tesa.png",
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                    /*Container(
                      child: Text("TESA"),
                    ),*/
                  ],
                ),
                backgroundColor: DARK_BLUE_COLOR,
                  actions: [
                    IconButton(icon: Icon(Icons.refresh_sharp), onPressed: (){
                     // print('refresh');
                     Navigator.pushNamedAndRemoveUntil(
                         context,
                         '/home',
                             (Route<dynamic> route) => false,
                         arguments: {
                           'datos': _arguments!['datos'],
                           'save': false
                         }
                     );
                     setState(() {
                       HomeViajes(info: _arguments!['datos']);
                     });
                   }),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'VIAJES',),
                    Tab(text: 'GASTOS',),
                  ],
                  indicator: MaterialIndicator(
                    height: 5,
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    horizontalPadding: 50,
                    tabPosition: TabPosition.bottom,
                    color: inteco,
                  ),
                ),
            )
          ),
          body:
          TabBarView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: 999,
                 // child: _tareas(),
                child: HomeViajes(info: _arguments!['datos']),

              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: 999,
                child: HomeGastos(info: _arguments!['datos']),
              ),
            ],
          ),

          /*floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: inteco,
            onPressed: (){
              print('boton agregar');
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddViajes(
                id: _arguments!['datos'].id.toString()
              )
              )
              );
            },
          ),*/
        )
    );
  }
}