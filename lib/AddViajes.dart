
import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerClientes.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerRutas.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:choferes/viajesDetails.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:search_choices/search_choices.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';

class AddViajes extends StatefulWidget {
  // final Visita vinfo;
  //String id;
  final Usuario info;
  //String fecha;

  static const routeName = '/addviajes';
  AddViajes({Key? key, required this.info,}) : super(key: key);

  @override
  _AddViajesState createState() => _AddViajesState();
}

class _AddViajesState extends State<AddViajes> {

  TextEditingController? _comentarios;
  TextEditingController? _kmInicial;
  String? valueDropdownAutos;
  String? valueDropdownClientes;
  String? valueDropdownRutas;
  String? autos;
  String? clientes;
  String? clientes_nombre;
  String? ruta_nombre;
  String? vehiculos_nombre;
  String? vehiculos_tipo;
  String? rutas;
  //TextEditingController dateController2=TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var listaRutas = [];
  var listaRutasOffC = [];
  var listaClientes = [];
  var listaAutos = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  void initState(){
    super.initState();
    Conn.isInternet().then((connection){
      if(connection){
        vehiculos();
        accounts();
       // rutai();
        rutaoff();
      }else{
         vehiculosOffConnection();
         clientesOffConnection();
         rutasOffConnection();
      }
    });
    _kmInicial=TextEditingController();
    autos = '';
    clientes = '';
    clientes_nombre = '';
    ruta_nombre = '';
    vehiculos_nombre = '';
    vehiculos_tipo = '';
    rutas = '';
    _comentarios=TextEditingController();
  }

  void vehiculosOffConnection()async{
    var vehiculos = await Controllerconsulta().queryDataVehiculos();
    setState(() {
      listaAutos = vehiculos!;
    });
    //print('data: ' + data);
  }

  void vehiculos()async{
    var vehiculos = await getAutos();
    setState(() {
      listaAutos = vehiculos!;
    });

      listaAutos.forEach((element) {
        Vehiculo vehiculoo = Vehiculo(
          id_vehiculo: element['id_vehiculo'],
          vehiculo: element['vehiculo'],
          tipovehiculo: element['tipovehiculo'],
          num_serie: element['num_serie'],
          vehiculosid: element['vehiculosid'],
        );

        Controllerconsulta().queryCountVehiculos(element['vehiculosid'].toString()).then((value) {
          if (value>0) {
            print('value autos: ' + value.toString());
          } else {
            //INSERT EN LA TABLA DE AUTOS
            Controllerconsulta().addDataVehiculos(vehiculoo).then((value) {
              if (value > 0) {
                print('valor en el insert autos: ' + value.toString());
                print("correcta inserción de vehiculos");
              } else {
                print("fallo insercion vehiculos");
              }
            });
          }
        });//query count
      }); //foreach
  }

  void accounts()async{
    var cuentas = await getClientes();
    setState(() {
      listaClientes = cuentas!;
    });

    listaClientes.forEach((element) {
      Clientes clientess = Clientes(
        accountid: element["accountid"],
        account_no: element["account_no"],
        accountname: element["accountname"],
      );

      Controllerconsulta().queryCountClientes(element['accountid'].toString()).then((value) {
        if (value>0) {
          //print('value clientes: ' + value.toString());
        } else {
          //INSERT EN LA TABLA DE CLIENTES
          Controllerconsulta().addDataClientes(clientess).then((value) {
            if (value > 0) {
             // print('valor en el insert clientes: ' + value.toString());
              print("correcta inserción de clientes");
            } else {
              print("fallo insercion clientes");
            }
          });
        }
      });//query count
    });
  }

  void clientesOffConnection()async{
    var clientes = await Controllerconsulta().queryDataClientes();
    setState(() {
      listaClientes = clientes!;
    });
  }

  void rutasOffConnection()async{
    var ruta = await Controllerconsulta().queryDataRutas();
    setState(() {
      listaRutas = ruta!;
    });
  }

  void rutai(String id, String tipov)async {
    var ruta = await getRutas(id, tipov);
    setState(() {
      listaRutas = ruta!;
    });
  }

  void rutaoff()async{
    var ruta = await getRutasoff();
    setState(() {
      listaRutasOffC = ruta!;
    });

    listaRutasOffC.forEach((element) {
      Rutas rutass = Rutas(
          costorutaid: element["costorutaid"],
          estado: element["estado"],
          desc_ruta: element["desc_ruta"],
          tipo: element["tipo"],
          costo: element["costo"],
          comison: element["comison"],
          ruta_id: element['ruta_id'],
          cliente: element['cliente'],
          tipov: element['tipov'],
      );

      Controllerconsulta().queryCountRutas(element['costorutaid'].toString()).then((value) {
        if (value>0) {
          print('value rutas: ' + value.toString());
        } else {
          //INSERT EN LA TABLA DE CLIENTES
          Controllerconsulta().addDataRutas(rutass).then((value) {
            if (value > 0) {
             // print('valor en el insert rutas: ' + value.toString());
              print("correcta inserción de rutas");
            } else {
              print("fallo insercion rutas");
            }
          });
        }
      });//query count
    });
  }

  Widget titulo() => Padding(
      padding: const EdgeInsets.only(left: 15.0, ),
      child: Row(
        children: <Widget>[
          Text('',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      )
  );

  Widget _addViajes() {
    var vehiculos = [];
    var cuentas = [];
    var ruta = [];
    var idsr = [];
    var idsv = [];
    var idsc = [];


    listaAutos.forEach((element) => vehiculos.add(element['id_vehiculo']+' - '+element['vehiculo']));
    listaAutos.forEach((element) => idsv.add(element['vehiculosid']));
    //print(listaAutos);

    listaClientes.forEach((element) => cuentas.add(element['accountname']));
    listaClientes.forEach((element) => idsc.add(element['accountid']));

    listaRutas.forEach((element) => ruta.add(element['ruta_id']+' - '+element['desc_ruta']));
    listaRutas.forEach((element) => idsr.add(element['costorutaid']));

    return  Center(
        child: Container(
          width: MediaQuery.of(context).size.width*.99,
            child: Form(
              key: _formKey,
                child: Column(
                  children: <Widget>[
                    Card(
                        color: Colors.white,
                        borderOnForeground: false,
                        elevation: 7,
                        child: Column(
                        children: <Widget>[
                         // SizedBox(height: 15,),
                          titulo(),
                          Container(
                            padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(color: Colors.grey)
                            ),
                            width: MediaQuery.of(context).size.width*.85,
                            child: SearchChoices.single(
                              // onClear: ()=>this.activoT= '',
                              onClear: (){
                                autos = '';
                                valueDropdownAutos = '';
                              },
                              underline: SizedBox(),
                              hint: Text('Vehiculo'),
                              items: vehiculos.map<DropdownMenuItem<String>>((val){
                                return DropdownMenuItem<String>(
                                    value: val,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*.75,
                                      child: Text(
                                        val,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                );
                              }).toList(),
                              value: autos,
                              onChanged: (newValue){
                                setState(() {
                                  for(int i = 0; i < idsv.length; i++){
                                    if(listaAutos[i]['id_vehiculo']+' - '+listaAutos[i]['vehiculo']== newValue){
                                      valueDropdownAutos = idsv[i].toString();
                                      autos = newValue;
                                      vehiculos_nombre = listaAutos[i]['vehiculo'];
                                      vehiculos_tipo = listaAutos[i]['tipo'];
                                      //print(vehiculos_nombre);
                                      rutai(valueDropdownClientes!, vehiculos_tipo!);
                                      //rutasOffConnection(valueDropdownClientes!, vehiculos_tipo!);
                                    }
                                  }
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(color: Colors.grey)
                            ),
                            width: MediaQuery.of(context).size.width*.85,
                            child: SearchChoices.single(
                              // onClear: ()=>this.activoT= '',
                              onClear: (){
                                clientes = '';
                                valueDropdownClientes = '';
                              },
                              underline: SizedBox(),
                              hint: Text('Cliente'),
                              items: cuentas.map<DropdownMenuItem<String>>((val){
                                return DropdownMenuItem<String>(
                                    value: val,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*.75,
                                      child: Text(
                                        val,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                );
                              }).toList(),
                              value: clientes,
                              onChanged: (newValue2){
                                setState(() {
                                  for(int i = 0; i < idsc.length; i++){
                                    if(listaClientes[i]['accountname']== newValue2){
                                      valueDropdownClientes = idsc[i].toString();
                                      clientes = newValue2;
                                      clientes_nombre = listaClientes[i]['accountname'];
                                     // print(clientes_nombre);
                                      rutai(valueDropdownClientes!, vehiculos_tipo!);
                                     // rutasOffConnection(valueDropdownClientes!, vehiculos_tipo!);
                                    }
                                  }
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(color: Colors.grey)
                            ),
                            width: MediaQuery.of(context).size.width*.85,
                            child: SearchChoices.single(
                              // onClear: ()=>this.activoT= '',
                              onClear: (){
                                rutas = '';
                                valueDropdownRutas = '';
                              },
                              underline: SizedBox(),
                              hint: Text('Ruta'),
                              items: ruta.map<DropdownMenuItem<String>>((val){
                                return DropdownMenuItem<String>(
                                    value: val,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*.75,
                                      child: Text(
                                        val,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                );
                              }).toList(),
                              value: rutas,
                              onChanged: (newValue3){
                                setState(() {
                                  for(int i = 0; i < idsr.length; i++){
                                    if(listaRutas[i]['ruta_id']+' - '+listaRutas[i]['desc_ruta']== newValue3){
                                      valueDropdownRutas = idsr[i].toString();
                                      rutas = newValue3;
                                      ruta_nombre = listaRutas[i]['desc_ruta'];
                                      print(ruta_nombre);
                                    }
                                  }
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 21, right: 21, bottom: 1.0),
                                child: Container(
                                  child: TextField(
                                      decoration:  InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:  BorderSide(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        border: OutlineInputBorder(),
                                        labelText: 'Comentarios',
                                        labelStyle: TextStyle(color: Colors.grey ),
                                      ),
                                      controller: _comentarios,
                                      keyboardType: TextInputType.text,
                                      maxLength: 500,
                                      maxLines: null,
                                      textAlign: TextAlign.left
                                  ),
                                  width: MediaQuery.of(context).size.width*.85,
                                ),
                              )
                          ),
                          Container(

                                child: Container(
                                  child: TextField(
                                      decoration:  InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:  BorderSide(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        border: OutlineInputBorder(),
                                        labelText: 'Kilometraje inicial',
                                        labelStyle: TextStyle(color: Colors.grey ),
                                      ),
                                      controller: _kmInicial,
                                      keyboardType: TextInputType.number,
                                      maxLength: 100,
                                      maxLines: null,
                                      textAlign: TextAlign.left
                                  ),
                                  width: MediaQuery.of(context).size.width*.85,
                                ),
                          ),
                          Container(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Guardar e iniciar', style: TextStyle(color: Colors.white), textAlign : TextAlign.center),
                              onPressed: ()async{

                                //print(idviajep);

                                /*print('vehiculo: ' + vehiculos_nombre.toString());
                                print('ruta: ' + ruta_nombre.toString());
                                print('cliente: ' + clientes_nombre.toString());
                                print('id_user: '+widget.id.toString() +', cliente: '+ valueDropdownClientes!.toString() + ', ruta: ' +  valueDropdownRutas!.toString() + ', vehiculo: ' +valueDropdownAutos!.toString() + ', comentarios: ' + _comentarios!.text + ', Kilometraje_ini: ' + _kmInicial!.text + ', fecha: ' + DateTime.now().toString());
                                */

                                if(_formKey.currentState!.validate()){

                                  Conn.isInternet().then((connection){
                                    if (connection) {
                                      guardarViajes(widget.info.id.toString(), valueDropdownClientes!.toString(), valueDropdownRutas!.toString(), valueDropdownAutos!.toString(), _comentarios!.text, DateTime.now().toString(), _kmInicial!.text).then((value){
                                        print('valueViaje: '+value.toString());

                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/home',
                                                (Route<dynamic> route) => false,
                                            arguments: {
                                              'datos': widget.info,
                                              'save': false
                                            }
                                        );
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                                            detalles: value,
                                            info: widget.info
                                        )
                                        )
                                        );
                                      });
                                    }else{

                                     Controllerconsulta().queryDataTravelID().then((value){
                                       var idviajep = value+1;

                                      final splitted = DateTime.now().toString().split(' ');

                                      Viaje viaje = Viaje(viajesid: idviajep.toString(), viaje_id: 'local', fecha: splitted[0], hora_prev: splitted[1], vehiculo_id: vehiculos_nombre.toString(), ruta_id: ruta_nombre.toString(), accountname: clientes_nombre.toString());

                                      Controllerconsulta().addDataTravel(viaje).then((value){
                                          if(value>0){
                                          print("correcta inserción del viaje n");

                                          //print('detalles del viaje: ' +value!.viajesid.toString());
                                          ViajeD viajeD = ViajeD(
                                            viajesid: idviajep.toString(),
                                            viaje_id: 'local',
                                            nombre_ruta: ruta_nombre.toString(),
                                            fecha: splitted[0],
                                            hora_prev: splitted[1],
                                            vehiculo_id: vehiculos_nombre.toString(),
                                            ruta_id: valueDropdownRutas!.toString(),
                                            cliente: clientes_nombre.toString(),
                                            comentario: _comentarios!.text,
                                            centro: '',
                                            horario_inicio: splitted[1],
                                            horario_final: '',
                                            kil_ini: _kmInicial!.text,
                                            kil_fin: '',
                                            vehiculosid: valueDropdownAutos!.toString(),
                                            idcliente: valueDropdownClientes!.toString(),
                                          );

                                          Controllerconsulta().addDataDetails(viajeD).then((value){
                                            if (value>0) {
                                              print("correcta inserción de detalles n");

                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/home',
                                                      (Route<dynamic> route) => false,
                                                  arguments: {
                                                    'datos': widget.info,
                                                    'save': false
                                                  }
                                              );
                                            }else{
                                              print("fallo insercion detalles n");
                                            }
                                          });

                                          }else {
                                            print('fallo la insercion del viaje n');
                                          }
                                      });
                                     });
                                    }
                                  });
                                    print('id_user: '+widget.info.id.toString() +', cliente: '+ valueDropdownClientes!.toString() + ', ruta: ' +  valueDropdownRutas!.toString() + ', vehiculo: ' +valueDropdownAutos!.toString() + ', comentarios: ' + _comentarios!.text + ', Kilometraje_ini: ' + _kmInicial!.text + ', fecha: ' + DateTime.now().toString());
                                 // });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 30,),
                          ]
                        )
                    )
                  ]
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Agregar viaje'),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: ListView(
            children: <Widget>[
              _addViajes(),
            ])
    );
  }


}

