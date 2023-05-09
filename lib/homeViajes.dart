import 'dart:convert';

import 'package:choferes/AddViajes.dart';
import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:choferes/viajesDetails.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../funciones/alertas.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';


class HomeViajes extends StatefulWidget {
  //String id;
  final Usuario info;
  static const routeName = '/HomeViajes';
  HomeViajes({Key? key, required this.info}) : super(key: key);

  @override
  _HomeViajesState createState() => _HomeViajesState();
}


class _HomeViajesState extends State<HomeViajes> {

  List? list;
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


  @override
  void initState(){
    super.initState();
    userList();
  }

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
                title: Text('Ruta: ${data[index]['ruta_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Fecha inicio previsto:  ${data[index]['fecha']}\nHora inicio previsto:  ${data[index]['hora_prev']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap:(){
                  //print ('presionaste el viaje numero1:' + data[index]['viajesid']);
                  getviajeDetails(widget.info.id.toString(), data[index]['viajesid']).then((value){
                     print('revs detalles: ' + value.toString());
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
                        info: widget.info
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
                title: Text('Ruta: ${data[index]['ruta_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Fecha inicio previsto:  ${data[index]['fecha']}\nHora inicio previsto:  ${data[index]['hora_prev']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap:(){
                  //print ('presionaste el viaje numero1:' + data[index]['viajesid']);
                  userList2(data[index]['viajesid']);
                  if (list2 == null || list2?[0] == null){
                    showToast(context, 'Cargando datos, espere unos segundos y vuelva a intentarlo.', 2, Colors.blueGrey, 0);
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                        detalles:list2?[0],
                        info: widget.info
                    ))
                    );
                    print(data[index]['viajesid']);
                    print(list2?[0]);
                  }
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
    future: getViajes(widget.info.id.toString()),
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      if(snapshot.hasData) {
        if (snapshot.data.length==0) return emptyResponse;
        // print('snapshot viajes: ' + snapshot.data.length.toString());

        for (var i = 0; i < snapshot.data.length; i++){
          Controllerconsulta().queryCountTravel(snapshot.data[i]['viajesid'].toString()).then((value) {
            if(value>0){
             // print('value travel if: ' + value.toString());
            }else{
              //INSERT table: viaje bd: vaneviaje
              Viaje viaje = Viaje(viajesid: snapshot.data[i]['viajesid'].toString(), viaje_id: snapshot.data[i]['viaje_id'].toString(), fecha: snapshot.data[i]['fecha'].toString(), hora_prev: snapshot.data[i]['hora_prev'].toString(), vehiculo_id: snapshot.data[i]['vehiculo_id'].toString(), ruta_id: snapshot.data[i]['ruta_id'].toString(), accountname: snapshot.data[i]['accountname'].toString());
              Controllerconsulta().addDataTravel(viaje).then((value){
                if(value>0){
                  print("correcta inserción del viaje");

                  getviajeDetails(widget.info.id.toString(), snapshot.data[i]['viajesid'].toString()).then((value){

                    print('detalles del viaje horario: ' +value!.horario_inicio.toString());
                    ViajeD viajeD = ViajeD(
                      viajesid: value.viajesid,
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
          if(list!.length > 0){
            return _bodyOffConnection(list);
          }else{
            return emptyResponse;
          }

        }
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:_tareas(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: inteco,
            onPressed: (){
              //print('boton agregar');
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddViajes(
                  info: widget.info
              )
              )
              );
            },
          ),
    );
  }
}