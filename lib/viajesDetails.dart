import 'dart:async';

import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/funciones/ExpReg.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:search_choices/search_choices.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';

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
  //String? _pasajeros;
 // String? _pasajerosF;
  TextEditingController? _comentarios;
  TextEditingController? _comentariosF;
  TextEditingController? _pasajerosF;


  Timer? timer;

  @override
  void initState(){
    print(widget.detalles);
    super.initState();
    _kmInicial = TextEditingController();
    _kmFinal = TextEditingController();;
    _comentarios = TextEditingController();
    _comentariosF = TextEditingController();
    _pasajerosF= TextEditingController();

    _kmFinal!.text = '';
    _pasajerosF!.text = '';

    //_pasajeros=TextEditingController();
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
                _rowText('ID: ', '${widget.detalles.viaje_id.toString()}'),
                _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                _rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
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
                                     // print('kmini: ' + _kmInicial!.text);
                                      // showAlertSelectDialog(context, (){
                                      //Navigator.of(context).pop();
                                      if (_kmInicial!.text != null || _kmInicial!.text != 'null' || _kmInicial!.text != '' || _kmInicial!.text != 0 || _kmInicial!.text != '0') {
                                        //UPDATE MySQL
                                        update_kIni(widget.info.id.toString(), widget.detalles.viajesid.toString(), _kmInicial!.text, DateTime.now().toString(), _comentarios!.text).then((res){

                                          print('se registro correctamente :' + DateTime.now().toString());
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
                                            kil_fin: widget.detalles.kil_fin.toString()
                                        );
                                        Controllerconsulta().updateDataTravel(viajeD).then((value) {
                                          showSimpleDialog(context, 'Alerta', 'Cambio exitoso');
                                          print('valor en update ini: '+value.toString());
                                          if(value>0){
                                            setState(() {
                                              widget.detalles.horario_inicio= DateTime.now().toString();
                                              widget.detalles.kil_ini= _kmInicial!.text;
                                            });
                                            print('se inserto bien la actualizacion');
                                          }
                                        });

                                      }else {
                                        showAlertDialog(context, 'Atención', 'Solo es posible iniciar el viaje si la hora de inicio no esta vacia');
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
                      if(widget.detalles.horario_final.toString() == null || widget.detalles.horario_final.toString() == 'null' || widget.detalles.horario_final.toString() == ''){
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
                              /*
                              Container(
                                width: MediaQuery.of(context).size.width*.70,
                                child: SearchChoices.single(
                                  underline: Container(
                                    height: 1.0,
                                    decoration: const BoxDecoration(
                                        border:
                                        Border(bottom: BorderSide(color: Colors.blueGrey, width: 1.0))),
                                  ),
                                  hint: Text('Pasajeros', style: TextStyle(color: Colors.blueGrey ),),
                                  items: <String>['0', '1', '2', '3', '4', '5','6', '7', '8', '9', '10','11', '12', '13', '14', '15','16', '17', '18', '19', '20','21', '22', '23', '24', '25','26', '27', '28', '29','30','31', '32', '33', '34', '35','36', '37', '38', '39','40'].map<DropdownMenuItem<String>>((val){
                                    return DropdownMenuItem<String>(
                                        value: val,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width*.45,
                                          child: Text(
                                            val,
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                          ),
                                        )
                                    );
                                  }).toList(),
                                  value: _pasajerosF,
                                  onChanged: (newValue){
                                    setState(() {
                                      _pasajerosF = newValue.toString();
                                    });
                                  },
                                  isExpanded: true,
                                ),
                                height: 79,
                              ),
                              */

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
                                        print('presionao');
                                        var kmf = int.parse(_kmFinal!.text != '' ? _kmFinal!.text : '0');
                                        var parse = int.parse(_pasajerosF!.text != '' ? _pasajerosF!.text : '0');

                                        if(kmf == 0 || _pasajerosF!.text != '' ){
                                          print('mayor a 40');
                                          showSimpleDialog(context, ' Alerta', 'Los campos de kilometraje y pasajeros no pueden quedar incompletos');
                                        }
                                        else if(parse > 40){
                                          print('mayor a 40');
                                          showSimpleDialog(context, ' Alerta', 'El número de pasajeros debe ser menor a 40');

                                        }else{
                                          print('menor a 40');
                                          //showSimpleDialog(context, 'Alerta', 'menor');
                                          //_redirect();
                                        //}//else


                                        //Navigator.of(context).pop();
                                        //UPDATE MySQL
                                        update_kFin(widget.info.id.toString(), widget.detalles.viajesid.toString(), _kmFinal!.text, DateTime.now().toString(), _pasajerosF!.text, _comentariosF!.text).then((res){
                                          print('se registro correctamente :' + DateTime.now().toString());
                                          setState(() {
                                            widget.detalles.horario_final= DateTime.now().toString();
                                            widget.detalles.kil_fin= _kmFinal!.text;
                                          });
                                        });
                                        //UPDATE LOCAL
                                        ViajeD viajeD = ViajeD(
                                            viajesid: widget.detalles.viajesid,
                                            viaje_id:widget.detalles.viaje_id,
                                            nombre_ruta: widget.detalles.nombre_ruta,
                                            fecha: widget.detalles.fecha,
                                            hora_prev: widget.detalles.hora_prev,
                                            vehiculo_id: widget.detalles.vehiculo_id,
                                            ruta_id: widget.detalles.ruta_id,
                                            cliente:widget.detalles.cliente,
                                            comentario: widget.detalles.comentario,
                                            centro: widget.detalles.centro,
                                            horario_inicio: widget.detalles.horario_inicio,
                                            horario_final: DateTime.now().toString(),
                                            kil_ini: widget.detalles.kil_ini,
                                            kil_fin: _kmFinal!.text,
                                            vehiculosid: widget.detalles.vehiculosid,
                                            idcliente: widget.detalles.idcliente
                                        );
                                        Controllerconsulta().updateDataTravel(viajeD).then((value) {
                                          showSimpleDialog(context, 'Alerta', 'Cambio exitoso');
                                          _redirect();
                                          print('valor en update'+value.toString());
                                          if(value>0){
                                            setState(() {
                                              widget.detalles.horario_final= DateTime.now().toString();
                                              widget.detalles.kil_fin= _kmFinal!.text;
                                            });
                                            print('se inserto bien la actualizacion');
                                          }
                                        });
                                        print('presionaste el finalizar viaje: ' + _kmFinal!.text);

                                        }//else
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DARK_BLUE_COLOR,
                                      ),
                                      child: Text('Finalizar Viaje')
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                        ]
                        );
                      }else{
                        return  ListView(
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
                                    _rowText('ID: ', '${widget.detalles.viaje_id.toString()}'),
                                    _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                                    _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                                    _rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
                                    _rowText('Centro: ', '${widget.detalles.centro.toString()}'),
                                    _rowText('Fecha y Horario: ', '${widget.detalles.fecha.toString()} - ${widget.detalles.hora_prev.toString()}'),
                                    _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                          ],
                        );
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
/*
  Widget _body(){
    //print('vinfo: '+ _arguments!['vinfo'].toString());
    if(widget.detalles.horario_inicio.toString() == null || widget.detalles.horario_inicio.toString() == 'null' || widget.detalles.horario_inicio.toString() == ''){
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
                  _rowText('ID: ', '${widget.detalles.viaje_id.toString()}'),
                  _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                  _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                  _rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
                  _rowText('Centro: ', '${widget.detalles.centro.toString()}'),
                  _rowText('Fecha y Horario: ', '${widget.detalles.fecha.toString()} - ${widget.detalles.hora_prev.toString()}'),
                  _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          SizedBox(height: 12,),
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                        child: Container(
                          child: TextField(
                              decoration:  InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Kilometraje inicial',
                                labelStyle: TextStyle(color: Colors.blueGrey ),
                              ),
                              controller: _kmInicial,
                              keyboardType: TextInputType.number,
                              maxLength: 100,
                              maxLines: null,
                              textAlign: TextAlign.left
                          ),
                          width: MediaQuery.of(context).size.width*.90,
                        ),
                      )
                  ),
          SizedBox(height: 12,),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                child: Container(
                  child: TextField(
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Número de pasajeros',
                        labelStyle: TextStyle(color: Colors.blueGrey ),
                      ),
                      controller: _pasajeros,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      maxLines: null,
                      textAlign: TextAlign.left
                  ),
                  width: MediaQuery.of(context).size.width*.90,
                ),
              )
          ),
          SizedBox(height: 12,),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
                  ElevatedButton(
                    onPressed: () async{
                     // showAlertSelectDialog(context, (){
                        //Navigator.of(context).pop();
                        if (widget.detalles.horario_inicio.toString() == null || widget.detalles.horario_inicio.toString() == 'null' || widget.detalles.horario_inicio.toString() == '') {
                          //UPDATE MySQL
                          update_kIni(widget.info.id.toString(), widget.detalles.viajesid.toString(), _kmInicial!.text, DateTime.now().toString()).then((res){

                            print('se registro correctamente :' + DateTime.now().toString());
                            setState(() {
                              widget.detalles.horario_inicio= DateTime.now().toString();
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
                              kil_fin: widget.detalles.kil_fin.toString()
                          );
                          Controllerconsulta().updateDataTravel(viajeD).then((value) {
                            showMessageDialog(context, 'Alerta', 'Cambio exitoso');
                            print('valor en update ini: '+value.toString());
                            if(value>0){
                              setState(() {
                                widget.detalles.horario_inicio= DateTime.now().toString();
                              });
                              print('se inserto bien la actualizacion');
                            }
                          });

                        }else {
                          showAlertDialog(context, 'Atención', 'Solo es posible iniciar el viaje si la hora de inicio no se ha llenado');
                        }
                     // print('presionaste el iniciar viaje: ' + _kmInicial!.text);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: DARK_BLUE_COLOR,
                    ),
                    child: Text('Iniciar Viaje')
                    ),
            ],
          )
        ],
      );
    }else{
      if(widget.detalles.horario_final.toString() == null || widget.detalles.horario_final.toString() == 'null' || widget.detalles.horario_final.toString() == ''){
        return  ListView(
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
                    _rowText('ID: ', '${widget.detalles.viaje_id.toString()}'),
                    _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                    _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                    _rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
                    _rowText('Centro: ', '${widget.detalles.centro.toString()}'),
                    _rowText('Fecha y Horario: ', '${widget.detalles.fecha.toString()} - ${widget.detalles.hora_prev.toString()}'),
                    _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12,),
            Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                  child: Container(
                    child: TextField(
                        decoration:  InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Kilometraje final',
                          labelStyle: TextStyle(color: Colors.blueGrey ),
                        ),
                        controller: _kmFinal,
                        keyboardType: TextInputType.number,
                        maxLength: 100,
                        maxLines: null,
                        textAlign: TextAlign.left
                    ),
                    width: MediaQuery.of(context).size.width*.90,
                  ),
                )
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async{
                      // showAlertSelectDialog(context, (){
                      //Navigator.of(context).pop();
                      //UPDATE MySQL
                      update_kFin(widget.info.id.toString(), widget.detalles.viajesid.toString(), _kmFinal!.text, DateTime.now().toString()).then((res){
                        print('se registro correctamente :' + DateTime.now().toString());

                        setState(() {
                          widget.detalles.horario_final= DateTime.now().toString();
                        });
                      });

                      //UPDATE LOCAL
                      ViajeD viajeD = ViajeD(
                          viajesid: widget.detalles.viajesid,
                          viaje_id:widget.detalles.viaje_id,
                          nombre_ruta: widget.detalles.nombre_ruta,
                          fecha: widget.detalles.fecha,
                          hora_prev: widget.detalles.hora_prev,
                          vehiculo_id: widget.detalles.vehiculo_id,
                          ruta_id: widget.detalles.ruta_id,
                          cliente:widget.detalles.cliente,
                          comentario: widget.detalles.comentario,
                          centro: widget.detalles.centro,
                          horario_inicio: widget.detalles.horario_inicio,
                          horario_final: DateTime.now().toString(),
                          kil_ini: widget.detalles.kil_ini,
                          kil_fin: _kmFinal!.text,
                          vehiculosid: widget.detalles.vehiculosid,
                          idcliente: widget.detalles.idcliente
                      );
                      Controllerconsulta().updateDataTravel(viajeD).then((value) {
                        showMessageDialog(context, 'Alerta', 'Cambio exitoso');
                       /* Fluttertoast.showToast(
                            msg: "Viaje finalizado con éxito",
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.white,
                            backgroundColor: Colors.black
                        );*/
                        _redirect();
                        print('valor en update'+value.toString());
                        if(value>0){
                          setState(() {
                            widget.detalles.horario_final= DateTime.now().toString();
                          });
                          print('se inserto bien la actualizacion');
                        }
                      });
                      print('presionaste el finalizar viaje: ' + _kmFinal!.text);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: DARK_BLUE_COLOR,
                    ),
                    child: Text('Finalizar Viaje')
                ),
              ],
            )
          ],
        );
      }else{
        return  ListView(
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
                    _rowText('ID: ', '${widget.detalles.viaje_id.toString()}'),
                    _rowText('Ruta: ', '${widget.detalles.nombre_ruta.toString()}'),
                    _rowText('Vehículo: ', '${widget.detalles.vehiculo_id.toString()}'),
                    _rowText('Cliente: ', '${widget.detalles.cliente.toString()}'),
                    _rowText('Centro: ', '${widget.detalles.centro.toString()}'),
                    _rowText('Fecha y Horario: ', '${widget.detalles.fecha.toString()} - ${widget.detalles.hora_prev.toString()}'),
                    _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12,),
          ],
        );
      }
    }

  }
*/
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

/*
  Widget _bodyOffConnection(){
    //print('vinfo: '+ _arguments!['vinfo'].toString());
    if(widget.detalles!['horario_inicio'] == null || widget.detalles!['horario_inicio'] == 'null' || widget.detalles!['horario_inicio'] == ''){
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
                  _rowText('ID: ', '${widget.detalles!['viaje_id']}'),
                  _rowText('Ruta: ', '${widget.detalles!['nombre_ruta']}'),
                  _rowText('Vehículo: ', '${widget.detalles!['vehiculo_id']}'),
                  _rowText('Cliente: ', '${widget.detalles!['cliente']}'),
                  _rowText('Centro: ', '${widget.detalles!['centro']}'),
                  _rowText('Fecha y Horario: ', '${widget.detalles!['fecha']} - ${widget.detalles!['hora_prev']}'),
                  _observaciones('Comentarios:   ', widget.detalles!['comentario']),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          SizedBox(height: 12,),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                child: Container(
                  child: TextField(
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Kilometraje inicial',
                        labelStyle: TextStyle(color: Colors.blueGrey ),
                      ),
                      controller: _kmInicial,
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      maxLines: null,
                      textAlign: TextAlign.left
                  ),
                  width: MediaQuery.of(context).size.width*.90,
                ),
              )
          ),
          SizedBox(height: 12,),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                child: Container(
                  child: TextField(
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Número de pasajeros',
                        labelStyle: TextStyle(color: Colors.blueGrey ),
                      ),
                      controller: _pasajeros,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      maxLines: null,
                      textAlign: TextAlign.left
                  ),
                  width: MediaQuery.of(context).size.width*.90,
                ),
              )
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    // showAlertSelectDialog(context, (){
                    //Navigator.of(context).pop();
                    if (widget.detalles!['horario_inicio'].toString() == null || widget.detalles!['horario_inicio'].toString() == 'null' || widget.detalles!['horario_inicio'].toString() == '') {

                      //UPDATE LOCAL
                      ViajeD viajeD = ViajeD(
                          viajesid: widget.detalles!['viajesid'].toString(),
                          viaje_id:widget.detalles!['viaje_id'].toString(),
                          nombre_ruta: widget.detalles!['nombre_ruta'].toString(),
                          fecha: widget.detalles!['fecha'].toString(),
                          hora_prev: widget.detalles!['hora_prev'].toString(),
                          vehiculo_id: widget.detalles!['vehiculo_id'].toString(),
                          ruta_id: widget.detalles!['ruta_id'].toString(),
                          cliente:widget.detalles!['cliente'].toString(),
                          comentario: widget.detalles!['comentario'].toString(),
                          centro: widget.detalles!['centro'].toString(),
                          horario_inicio: DateTime.now().toString(),
                          horario_final: widget.detalles!['horario_final'].toString(),
                          kil_ini: _kmInicial!.text,
                          kil_fin: widget.detalles!['kil_fin'].toString(),
                          vehiculosid: widget.detalles!['vehiculosid'],
                          idcliente: widget.detalles!['idcliente']
                      );
                      Controllerconsulta().updateDataTravel(viajeD).then((value) {
                        showMessageDialog(context, 'Alerta', 'Cambio exitoso');
                        print('valor en update ini: '+value.toString());
                        if(value>0){
                          /* setState(() {
                                _args['tarea']['status']= 'Llegada a levantar cuerpo';
                              });*/
                          print('se inserto bien la actualizacion');
                        }
                      });
                      /*  //Insercion de cambios
                          Conn.isInternet().then((conexion) {
                            Actualizaciones actualizaciones = Actualizaciones(id_tarea: _args['tarea']['id'].toString(), id_usuario: _args['usr'].toString(), fecha_act: DateTime.now().toString(), status_viejo: _args['tarea']['status'].toString(), status_nuevo: 'Llegada a levantar cuerpo', estado: '0');
                            Controllerconsulta().addDataAct(actualizaciones);
                          });

                          Controllerconsulta().queryDataAct().then((ejecucion) {
                            print('ejecucion: ' + ejecucion.toString());
                          });*/
                    }else {
                      showAlertDialog(context, 'Atención', 'Solo es posible iniciar el viaje si la hora de inicio no se ha llenado');
                    }
                    // }, '¿Desea guardar los cambios?');

                    // print('presionaste el iniciar viaje: ' + _kmInicial!.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: DARK_BLUE_COLOR,
                  ),
                  child: Text('Iniciar Viaje')
              ),
            ],
          )
        ],
      );
    }else{
      return  ListView(
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
                  _rowText('ID: ', '${widget.detalles!['viaje_id']}'),
                  _rowText('Ruta: ', '${widget.detalles!['nombre_ruta']}'),
                  _rowText('Vehículo: ', '${widget.detalles!['vehiculo_id']}'),
                  _rowText('Cliente: ', '${widget.detalles!['cliente']}'),
                  _rowText('Centro: ', '${widget.detalles!['centro']}'),
                  _rowText('Fecha y Horario: ', '${widget.detalles!['fecha']} - ${widget.detalles!['hora_prev']}'),
                  _observaciones('Comentarios:   ', widget.detalles!['comentario']),
                ],
              ),
            ),
          ),
          SizedBox(height: 12,),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 1.0),
                child: Container(
                  child: TextField(
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: Color(0xFF7E7D7D), width: 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Kilometraje final',
                        labelStyle: TextStyle(color: Colors.blueGrey ),
                      ),
                      controller: _kmFinal,
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      maxLines: null,
                      textAlign: TextAlign.left
                  ),
                  width: MediaQuery.of(context).size.width*.90,
                ),
              )
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async{
                    // showAlertSelectDialog(context, (){
                    //Navigator.of(context).pop();

                    //UPDATE LOCAL
                    ViajeD viajeD = ViajeD(
                        viajesid: widget.detalles!['viajesid'].toString(),
                        viaje_id:widget.detalles!['viaje_id'].toString(),
                        nombre_ruta: widget.detalles!['nombre_ruta'].toString(),
                        fecha: widget.detalles!['fecha'].toString(),
                        hora_prev: widget.detalles!['hora_prev'].toString(),
                        vehiculo_id: widget.detalles!['vehiculo_id'].toString(),
                        ruta_id: widget.detalles!['ruta_id'].toString(),
                        cliente:widget.detalles!['cliente'].toString(),
                        comentario: widget.detalles!['comentario'].toString(),
                        centro: widget.detalles!['centro'].toString(),
                        horario_inicio: widget.detalles!['horario_inicio'],
                        horario_final: DateTime.now().toString(),
                        kil_ini: widget.detalles!['kil_ini'],
                        kil_fin: _kmFinal!.text,
                        vehiculosid: widget.detalles!['vehiculosid'],
                        idcliente: widget.detalles!['idcliente']
                    );
                    Controllerconsulta().updateDataTravel(viajeD).then((value) {
                      showMessageDialog(context, 'Alerta', 'Cambio exitoso');
                      print('valor en update'+value.toString());
                      if(value>0){
                        /* setState(() {
                                _args['tarea']['status']= 'Llegada a levantar cuerpo';
                              });*/
                        print('se inserto bien la actualizacion');
                      }
                    });
                    /*  //Insercion de cambios
                          Conn.isInternet().then((conexion) {
                            Actualizaciones actualizaciones = Actualizaciones(id_tarea: _args['tarea']['id'].toString(), id_usuario: _args['usr'].toString(), fecha_act: DateTime.now().toString(), status_viejo: _args['tarea']['status'].toString(), status_nuevo: 'Llegada a levantar cuerpo', estado: '0');
                            Controllerconsulta().addDataAct(actualizaciones);
                          });

                          Controllerconsulta().queryDataAct().then((ejecucion) {
                            print('ejecucion: ' + ejecucion.toString());
                          });*/
                    // }, '¿Desea guardar los cambios?');

                    print('presionaste el iniciar viaje: ' + _kmInicial!.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: DARK_BLUE_COLOR,
                  ),
                  child: Text('Finalizar Viaje')
              ),
            ],
          )
        ],
      );
    }
  }
*/
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

/*
  Widget prueba(){
    //Conn.isInternet().then((connection){
    var connectivityResult = (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        return _body();
      }else{
      return _bodyOffConnection();
    }
  //  });
    //return Center(child: progressWidget);
  }
*/

  @override
  Widget build(BuildContext context) {
    //_arguments = ModalRoute.of(context)!.settings.arguments as Map;
   // print('id: ' + _arguments!['id_user'].toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.detalles.viaje_id.toString()),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: _body2()
    );
  }

}