import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';

class gastosDetails extends StatefulWidget {
  //final Detalles detalles;
  final detalles;
  String id_user;
  static const routeName = '/gastosDetails';
  gastosDetails({Key? key, this.detalles, required this.id_user}) : super(key: key);

  @override
  _gastosDetailsPageState createState() => _gastosDetailsPageState();
}

class _gastosDetailsPageState extends State<gastosDetails> {

  @override
  void initState(){
    super.initState();
  }

  Widget _body(){
    //print('vinfo: '+ _arguments!['vinfo'].toString());
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
                  titulo('Información general'),
                  Divider(color: Colors.black, indent: 15, endIndent: 15,),
                  _rowText('ID: ', '${widget.detalles.gasto_id.toString()}'),
                  _rowText('Vehiculo: ', '${widget.detalles.vehiculo_id.toString()}'),
                  _rowText('Proveedor: ', '${widget.detalles.proveedor.toString()}'),
                  _rowText('Concepto: ', '${widget.detalles.concepto.toString()}'),
                  _rowText('Fecha de carga:', '${widget.detalles.fecha_gasto.toString()}'),
                  _rowText('Hora de carga:', '${widget.detalles.hora.toString()}'),
                  _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                  SizedBox(height: 15,),
                  titulo('Información detallada'),
                  Divider(color: Colors.black, indent: 15, endIndent: 15,),
                  _rowText('Pago: ', '${widget.detalles.tipo_pago.toString()}'),
                  _rowText('Costo: ', '\$${widget.detalles.costo.toString()}'),
                  _rowText('Precio por litro: ', '${widget.detalles.precio_litro.toString()}'),
                  _rowText('Litros: ', '${widget.detalles.litros.toString()}'),
                  _rowText('Rendimiento: ', '${widget.detalles.rendimiento.toString()}'),
                  _rowText('Recorrido:', '${widget.detalles.recorrido.toString()}'),
                  _rowText('Precio por kilometro:', '\$${widget.detalles.pxk.toString()}'),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ],
      );
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
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 6),
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
          title: Text(widget.detalles.gasto_id.toString()),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: _body()
    );
  }

}