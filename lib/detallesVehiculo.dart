import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'controller/Usuario.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/widgets.dart';

class DetallesVehiculo extends StatefulWidget {
  final Usuario info;
  DetallesVehiculo({Key? key, required this.info,}) : super(key: key);

  @override
  _DetallesVehiculoState createState() => _DetallesVehiculoState();
}

class _DetallesVehiculoState extends State<DetallesVehiculo> with SingleTickerProviderStateMixin{
  Vehiculo? vehiculoSel;
  late MyLoopAnimation _loopAnimation;

  void initState() {
    super.initState();
    _loopAnimation = MyLoopAnimation(this);
    Controllerconsulta().queryVehiculoSel().then((value) =>
      setState(() {
        vehiculoSel = value;
        print('vehiculo information '+vehiculoSel.toString());
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        foregroundColor: LIGHT,
        title: Text('Detalles'),
        backgroundColor: DARK_BLUE_COLOR,
      ),*/
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/logo_tesa.png",
                height: MediaQuery.sizeOf(context).height * 0.05,
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: DARK_BLUE_COLOR
      ),
      body: _body(),
    );
  }

  Widget _body() {
    //print('vinfo: '+ _arguments!['vinfo'].toString());
    return vehiculoSel == null ? Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width)) :
    SingleChildScrollView(child:
        Column(children: [
        Padding(padding: EdgeInsets.all(10),
    child: Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 3,
      child: Column(
        children: <Widget>[
          SizedBox(height: 6,),
          titulo('Información general'),
          Divider(color: Colors.black, indent: 15, endIndent: 15,),
          //_rowText('ID: ', vehiculoSel!.id.toString()),
          _rowText('Vehiculo: ', vehiculoSel!.nombre.toString()),
          _rowText('Kilometraje: ', vehiculoSel!.kilometraje.toString()),
          _rowText('Marca: ', vehiculoSel!.marca.toString()),
          _rowText('Modelo: ', vehiculoSel!.modelo.toString()),
          //_rowText('Propietario: ', vehiculoSel!.nombre_propietario.toString()),
          _rowText('Placas estatales: ', vehiculoSel!.placas_est.toString()),
          _rowText('Placas federales: ', vehiculoSel!.placas_fed.toString()),
          //_rowText('Número de motor: ', vehiculoSel!.num_motor.toString()),
          //_rowText('Número de serie: ', vehiculoSel!.num_serie.toString()),
          _rowText('Poliza: ', vehiculoSel!.poliza.toString()),
          _rowText('Vigencia: ', vehiculoSel!.vigencia.toString()),
          _rowText('Comentario de poliza: ', vehiculoSel!.com_poliza.toString()),

          SizedBox(height: 5,),
        ],
      ),
    )),
        ]),);
  }

  Widget _rowText(String first, String second) =>
      Padding(
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

  Widget _observaciones(String first, String second) =>
      Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, bottom: 4, top: 6),
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

  Widget titulo(String first) =>
      Padding(
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
}