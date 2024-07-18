import 'dart:async';

import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';

class viajesDetails extends StatefulWidget {
  //final Detalles detalles;
  final detalles;
  //String id_user;
  final Usuario info;
  static const routeName = '/viajeDetails';
  viajesDetails({Key? key, this.detalles, required this.info}) : super(key: key);

  @override
  _viajesDetailsPageState createState() => _viajesDetailsPageState();
}

class _viajesDetailsPageState extends State<viajesDetails> {

  TextEditingController? _kmInicial;
  TextEditingController? _kmFinal;
  TextEditingController? _comentarios;
  TextEditingController? _comentariosF;
  TextEditingController? _pasajerosF;
  TextEditingController? _pasajeros;
  Vehiculo? vehiculoSel;

  Timer? timer;

  @override
  void initState(){
    super.initState();
    _kmInicial=TextEditingController();
    _kmFinal=TextEditingController();
    _comentarios=TextEditingController();
    _comentariosF=TextEditingController();
    _pasajerosF=TextEditingController();
    _pasajeros=TextEditingController();
    Controllerconsulta().queryVehiculoSel().then((value) {
      setState(() {
        vehiculoSel = value;
      });
    });
  }

  Widget _body2(){
    return ListView(
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
          child: Card(
            color: Colors.white,
            borderOnForeground: true,
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 6,),
                titulo('Detalles del viaje'),
                Divider(color: Colors.black, indent: 15, endIndent: 15,),
                _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                //_rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
                _rowText('Tipo viaje: ', '${widget.detalles.tipo.toString()}'),
                _rowText('Centro: ', '${widget.detalles.centro.toString()}'),
                _rowText('Fecha y Horario: ', '${widget.detalles.fecha.toString()} - ${widget.detalles.hora_prev.toString()}'),
                _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                SizedBox(height: 20,),
                Builder(
                  builder: (context){
                    if(widget.detalles.horario_inicio.toString() == null || widget.detalles.horario_inicio.toString() == 'null' || widget.detalles.horario_inicio.toString() == ''){
                      return Column(
                          children: <Widget>[
                                  Container(
                                          child: TextField(
                                            //agrega el boton de sig en el tecladoen ligar del done
                                              textInputAction: TextInputAction.next,
                                              decoration:  InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.blueGrey),
                                                ),
                                                labelText: '  Kilometraje inicial',
                                                labelStyle: TextStyle(color: Colors.blueGrey ),
                                              ),
                                              controller: _kmInicial,
                                              keyboardType: TextInputType.number,
                                              maxLength: 50,
                                              maxLines: null,
                                              textAlign: TextAlign.left
                                          ),
                                          width: MediaQuery.of(context).size.width*.70,
                                  ),

                            Container(
                              child: TextField(
                                  decoration:  InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blueGrey),
                                    ),
                                    labelText: '  Comentarios',
                                    labelStyle: TextStyle(color: Colors.blueGrey ),
                                  ),
                                  controller: _comentarios,
                                  keyboardType: TextInputType.text,
                                  maxLength: 500,
                                  maxLines: null,
                                  textAlign: TextAlign.left
                              ),
                              width: MediaQuery.of(context).size.width*.70,
                            ),

                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () async{
                                      // showAlertSelectDialog(context, (){
                                      //Navigator.of(context).pop();
                                      if (_kmInicial!.text != 'null' && _kmInicial!.text != '' ) {
                                        //UPDATE MySQL
                                        update_kIni(widget.info.id.toString(), widget.detalles.viajesid.toString(), _kmInicial!.text, DateTime.now().toString(), _comentarios!.text).then((res){
                                          //print('se registro correctamente :' + DateTime.now().toString());
                                          setState(() {
                                            widget.detalles.horario_inicio= DateTime.now().toString();
                                            widget.detalles.kil_ini= _kmInicial!.text;

                                          });
                                        });
                                        //UPDATE LOCAL
                                        ViajeD viajeD = ViajeD(
                                            viajesid: widget.detalles.viajesid.toString(),
                                            viaje_id:widget.detalles.viaje_id.toString(),
                                            nombre_ruta: widget.detalles.nombre_ruta.toString(),
                                            fecha: widget.detalles.fecha.toString(),
                                            hora_prev: widget.detalles.hora_prev.toString(),
                                            vehiculo_id: widget.detalles.vehiculo_id.toString(),
                                            ruta_id: widget.detalles.ruta_id.toString(),
                                            cliente:widget.detalles.cliente.toString(),
                                            comentario: widget.detalles.comentario.toString(),
                                            centro: widget.detalles.centro.toString(),
                                            horario_inicio: DateTime.now().toString(),
                                            horario_final: widget.detalles.horario_final.toString(),
                                            kil_ini: _kmInicial!.text,
                                            kil_fin: widget.detalles.kil_fin.toString(),
                                            vehiculosid: widget.detalles.vehiculosid,
                                            idcliente: widget.detalles.idcliente,
                                            tipo: widget.detalles.tipo,
                                            trabajadas: widget.detalles.trabajadas,
                                            distancia: widget.detalles.distancia,
                                        );
                                        Controllerconsulta().updateDataTravel(viajeD).then((value) {
                                          showAlertDialog(context, 'Alerta', 'Cambio exitoso', icono: Icon(null));
                                          //print('valor en update ini: '+value.toString());
                                          if(value>0){
                                            setState(() {
                                              widget.detalles.horario_inicio= DateTime.now().toString();
                                              widget.detalles.kil_ini= _kmInicial!.text;
                                            });
                                            //print('se inserto bien la actualizacion');
                                          }
                                        });
                                        showToast(context, 'Viaje iniciado');


                                      }else {
                                        showToast(context, 'El kilometrae inicial es necesario para continuar');
                                        //showAlertDialog(context, 'Atención', 'Solo es posible iniciar el viaje si la hora de inicio no esta vacia');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: DARK_BLUE_COLOR,
                                    ),
                                    child: Text('Iniciar Viaje')
                                ),
                              ],
                            ),
                            SizedBox(height: 20,)
                          ]
                      );
                    }else{
                      if(widget.detalles.horario_final.toString() == 'null' || widget.detalles.horario_final.toString() == '' /*|| widget.detalles.horario_final.toString() == null*/){

                        if(widget.detalles.tipo.toString() == 'Redondo' || widget.detalles.tipo.toString() == 'REDONDO'){
                          //print('tipo redondo: '+ widget.detalles.tipo.toString());
                          return Column(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                                      child: Container(
                                        child: TextField(
                                            textInputAction: TextInputAction.next,
                                            decoration:  InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blueGrey),
                                              ),
                                              // border: OutlineInputBorder(),
                                              labelText: '  Kilometraje final',
                                              labelStyle: TextStyle(color: Colors.blueGrey),
                                            ),
                                            controller: _kmFinal,
                                            keyboardType: TextInputType.number,
                                            maxLength: 50,
                                            maxLines: null,
                                            textAlign: TextAlign.left
                                        ),
                                        width: MediaQuery.of(context).size.width*.70,
                                      ),
                                    )
                                ),
                                Container(
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blueGrey),
                                      ),
                                      labelText: '  Pasajeros entrada',
                                      labelStyle: TextStyle(color: Colors.blueGrey ),
                                    ),
                                    controller: _pasajeros,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    // maxLines: null,
                                    textAlign: TextAlign.left,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  width: MediaQuery.of(context).size.width*.70,
                                ),
                                Container(
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blueGrey),
                                      ),
                                      labelText: '  Pasajeros salida',
                                      labelStyle: TextStyle(color: Colors.blueGrey ),
                                    ),
                                    controller: _pasajerosF,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    // maxLines: null,
                                    textAlign: TextAlign.left,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  width: MediaQuery.of(context).size.width*.70,
                                ),
                                Container(
                                  child: TextField(
                                      decoration:  InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                        labelText: '  Comentarios',
                                        labelStyle: TextStyle(color: Colors.blueGrey ),
                                      ),
                                      controller: _comentariosF,
                                      keyboardType: TextInputType.text,
                                      maxLength: 500,
                                      maxLines: null,
                                      textAlign: TextAlign.left
                                  ),
                                  width: MediaQuery.of(context).size.width*.70,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () async{
                                          if(_pasajerosF!.text == '' || _kmFinal!.text == ''){
                                            showToast(context, 'Complete los camposde kilometraje y pasajeros para poder finalizar su viaje',);
                                          }else {
                                            var parse = int.parse(
                                                _pasajerosF!.text);
                                            if (parse > 40) {
                                              showAlertDialog(
                                                  context, ' Alerta',
                                                  'El número de pasajeros debe ser menor a 40',
                                                  icono: Icon(null));
                                            } else {
                                              if (int.parse(
                                                  vehiculoSel!.kilometraje!) <=
                                                  int.parse(_kmFinal!.text)) {
                                                showAlertDialog(context, 'Advertencia', 'El kilometraje final debe ser ,ayor al inicial');
                                              }else{
                                                update_kFin(
                                                    widget.info.id.toString(),
                                                    widget.detalles.viajesid
                                                        .toString(),
                                                    _kmFinal!.text,
                                                    DateTime.now().toString(),
                                                    _pasajerosF!.text,
                                                    _comentariosF!.text,
                                                    _pasajeros!.text).then((
                                                    res) {
                                                  //print('se registro correctamente :' + DateTime.now().toString());
                                                  setState(() {
                                                    widget.detalles
                                                        .horario_final =
                                                        DateTime.now()
                                                            .toString();
                                                    widget.detalles.kil_fin =
                                                        _kmFinal!.text;
                                                  });
                                                });
                                                //UPDATE LOCAL
                                                ViajeD viajeD = ViajeD(
                                                  viajesid: widget.detalles
                                                      .viajesid,
                                                  viaje_id: widget.detalles
                                                      .viaje_id,
                                                  nombre_ruta: widget.detalles
                                                      .nombre_ruta,
                                                  fecha: widget.detalles.fecha,
                                                  hora_prev: widget.detalles
                                                      .hora_prev,
                                                  vehiculo_id: widget.detalles
                                                      .vehiculo_id,
                                                  ruta_id: widget.detalles
                                                      .ruta_id,
                                                  cliente: widget.detalles
                                                      .cliente,
                                                  comentario: widget.detalles
                                                      .comentario,
                                                  centro: widget.detalles
                                                      .centro,
                                                  horario_inicio: widget
                                                      .detalles.horario_inicio,
                                                  horario_final: DateTime.now()
                                                      .toString(),
                                                  kil_ini: widget.detalles
                                                      .kil_ini,
                                                  kil_fin: _kmFinal!.text,
                                                  vehiculosid: widget.detalles
                                                      .vehiculosid,
                                                  idcliente: widget.detalles
                                                      .idcliente,
                                                  tipo: widget.detalles.tipo,
                                                  trabajadas: widget.detalles
                                                      .trabajadas,
                                                  distancia: widget.detalles
                                                      .distancia,
                                                );
                                                Controllerconsulta()
                                                    .updateDataTravel(viajeD)
                                                    .then((value) {
                                                  if (value > 0) {
                                                    setState(() {
                                                      widget.detalles
                                                          .horario_final =
                                                          DateTime.now()
                                                              .toString();
                                                      widget.detalles.kil_fin =
                                                          _kmFinal!.text;
                                                      Controllerconsulta()
                                                          .upKmVehiculoSel(
                                                          _kmFinal!.text);
                                                    });
                                                    showToast(context,
                                                        'Viaje finalizado');
                                                    //print('se inserto bien la actualizacion');
                                                  }
                                                  _redirect();
                                                });
                                              }
                                            } //else
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: DARK_BLUE_COLOR,
                                        ),
                                        child: Text('Finalizar Viaje', style: TEXT_BUTTON_STYLE,)
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                              ]
                          );
                        }//fin if tipos de viajes
                        else{
                          //print('tipo sencillo' + widget.detalles.tipo.toString());
                          return Column(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                                      child: Container(
                                        child: TextField(
                                            textInputAction: TextInputAction.next,
                                            decoration:  InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blueGrey),
                                              ),
                                              // border: OutlineInputBorder(),
                                              labelText: '  Kilometraje final',
                                              labelStyle: TextStyle(color: Colors.blueGrey),
                                            ),
                                            controller: _kmFinal,
                                            keyboardType: TextInputType.number,
                                            maxLength: 50,
                                            maxLines: null,
                                            textAlign: TextAlign.left
                                        ),
                                        width: MediaQuery.of(context).size.width*.70,
                                      ),
                                    )
                                ),

                                Container(
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blueGrey),
                                      ),
                                      labelText: '  Pasajeros',
                                      labelStyle: TextStyle(color: Colors.blueGrey ),
                                    ),
                                    controller: _pasajerosF,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    // maxLines: null,
                                    textAlign: TextAlign.left,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  width: MediaQuery.of(context).size.width*.70,
                                ),
                                Container(
                                  child: TextField(
                                      decoration:  InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                        labelText: '  Comentarios',
                                        labelStyle: TextStyle(color: Colors.blueGrey ),
                                      ),
                                      controller: _comentariosF,
                                      keyboardType: TextInputType.text,
                                      maxLength: 500,
                                      maxLines: null,
                                      textAlign: TextAlign.left
                                  ),
                                  width: MediaQuery.of(context).size.width*.70,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () async{
                                          if(_pasajerosF!.text == '' || _kmFinal!.text == ''){
                                            showToast(context, 'Complete los camposde kilometraje y pasajeros para poder finalizar su viaje',);
                                          }else {
                                            var parse = int.parse(_pasajerosF!.text);
                                            if (parse > 40) {
                                              showAlertDialog(context, ' Alerta', 'El número de pasajeros debe ser menor a 40', icono: Icon(null));
                                            } else {
                                              if (int.parse(
                                                  vehiculoSel!.kilometraje!) <=
                                                  int.parse(_kmFinal!.text)) {
                                                showAlertDialog(
                                                    context, 'Advertencia',
                                                    'El kilometraje final debe ser ,ayor al inicial');
                                              } else {
                                                update_kFin(
                                                    widget.info.id.toString(),
                                                    widget.detalles.viajesid
                                                        .toString(),
                                                    _kmFinal!.text,
                                                    DateTime.now().toString(),
                                                    _pasajerosF!.text,
                                                    _comentariosF!.text,
                                                    'N/A').then((res) {
                                                  //print('se registro correctamente :' + DateTime.now().toString());
                                                  setState(() {
                                                    widget.detalles
                                                        .horario_final =
                                                        DateTime.now()
                                                            .toString();
                                                    widget.detalles.kil_fin =
                                                        _kmFinal!.text;
                                                  });
                                                });
                                                //UPDATE LOCAL
                                                ViajeD viajeD = ViajeD(
                                                  viajesid: widget.detalles
                                                      .viajesid,
                                                  viaje_id: widget.detalles
                                                      .viaje_id,
                                                  nombre_ruta: widget.detalles
                                                      .nombre_ruta,
                                                  fecha: widget.detalles.fecha,
                                                  hora_prev: widget.detalles
                                                      .hora_prev,
                                                  vehiculo_id: widget.detalles
                                                      .vehiculo_id,
                                                  ruta_id: widget.detalles
                                                      .ruta_id,
                                                  cliente: widget.detalles
                                                      .cliente,
                                                  comentario: widget.detalles
                                                      .comentario,
                                                  centro: widget.detalles
                                                      .centro,
                                                  horario_inicio: widget
                                                      .detalles.horario_inicio,
                                                  horario_final: DateTime.now()
                                                      .toString(),
                                                  kil_ini: widget.detalles
                                                      .kil_ini,
                                                  kil_fin: _kmFinal!.text,
                                                  vehiculosid: widget.detalles
                                                      .vehiculosid,
                                                  idcliente: widget.detalles
                                                      .idcliente,
                                                  tipo: widget.detalles.tipo,
                                                  trabajadas: widget.detalles
                                                      .trabajadas,
                                                  distancia: widget.detalles
                                                      .distancia,
                                                );
                                                Controllerconsulta()
                                                    .updateDataTravel(viajeD)
                                                    .then((value) {
                                                  showAlertDialog(
                                                      context, 'Alerta',
                                                      'Cambio exitoso',
                                                      icono: Icon(null));
                                                  if (value > 0) {
                                                    setState(() {
                                                      print('set state');
                                                      widget.detalles
                                                          .horario_final =
                                                          DateTime.now()
                                                              .toString();
                                                      widget.detalles.kil_fin =
                                                          _kmFinal!.text;
                                                      Controllerconsulta()
                                                          .upKmVehiculoSel(
                                                          _kmFinal!.text);
                                                    });
                                                    showToast(context,
                                                        'Viaje finalizado');
                                                  }
                                                  _redirect();
                                                });
                                              }
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: DARK_BLUE_COLOR,
                                        ),
                                        child: Text('Finalizar Viaje', style: TEXT_BUTTON_STYLE,)
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                              ]
                          );
                        }

                      }else{
                        print(widget.detalles.toString());
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 6,),
                            titulo('Tiempos'),
                            Divider(color: Colors.black, indent: 15, endIndent: 15,),
                              _rowText('Inicio de viaje: ', '${widget.detalles.horario_inicio.toString()}'),
                              _rowText('Fin de viaje: ', '${widget.detalles.horario_final.toString()}'),
                              _rowText('Horas trabajadas: ', '${widget.detalles.trabajadas.toString()}'),
                              _rowText('Distancia recorrida: ', '${widget.detalles.distancia.toString()}'),
                              _rowText('Kilometraje inicial: ', '${widget.detalles.kil_ini.toString()}'),
                              _rowText('Kilometraje final: ', '${widget.detalles.kil_fin.toString()}'),
                            SizedBox(height: 20,),
                          ]);
                      }
                    }
                  },
                )
              ],
            ),
          )
        )
          ]
    );
  }

  _redirect(){
    timer = new Timer(const Duration(milliseconds: 1000), (){
     Navigator.pop(context);
          Navigator.pushNamed(
              context,
              '/home',
              arguments: {
                'datos': widget.info,
                'save': false
              }
          );
    });
  }

  Widget _rowText(String first, String second) => Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4),
      child: Row(
        children: <Widget>[
          Text('$first',
            style: TextStyle(
              fontSize: 15.5,
              color: Colors.black,
              //fontWeight: FontWeight.bold
            ),
          ),

          Expanded(child:
          Text('$second',
            style: TextStyle(
              fontSize: 15.5,
              color: Colors.black,
            ), softWrap: true,
            textAlign: TextAlign.right,
          ),
          ),
        ],
      )
  );

  Widget _observaciones(String first, String second) => Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4, top: 6),
      child: Row(
        children: <Widget>[
          Text('$first',
            style: TextStyle(
              fontSize: 15.5,
              color: Colors.black,
              //fontWeight: FontWeight.bold
            ),
          ),

          Expanded(child:
          Text('$second',
            style: TextStyle(
              fontSize: 15.5,
              color: Colors.black,
            ), softWrap: true,
            textAlign: TextAlign.justify,
          ),
          ),
        ],
      )
  );

  Widget titulo(String first) => Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 2),
      child: Row(
        children: <Widget>[
          Text('$first',
            style: TextStyle(
                fontSize: 19.5,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      )
  );

  @override
  Widget build(BuildContext context) {

    print('detalles del viaje '+widget.detalles.toString());
    return Scaffold(
        appBar: AppBar(
          foregroundColor: LIGHT,
          title: Text('Detalles del viaje'),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: _body2()
    );
  }

}