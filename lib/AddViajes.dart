import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/funciones/alertas.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerClientes.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerRutas.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:choferes/viajesDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/cupertino.dart';
import 'package:search_choices/search_choices.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/sesiones.dart';
import 'funciones/widgets.dart';

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

class _AddViajesState extends State<AddViajes> with SingleTickerProviderStateMixin{

  TextEditingController _comentarios = TextEditingController();
  TextEditingController _kmInicial = TextEditingController();
  String? valueDropdownClientes;
  String? valueDropdownRutas;
  String? autos;
  String? clientes;
  String? clientes_nombre;
  String? ruta_nombre;
  String? vehiculos_nombre;
  String? vehiculos_tipo;
  String? rutas;
  String? tipoViaje;
  Vehiculo? vehiculoSel;
  bool showType = false, loading = true;
  late MyLoopAnimation _loopAnimation;

  final _formKey = GlobalKey<FormState>();
  var listaRutas = [];
  var listaRutasOffC = [];
  var listaClientes = [];
  var listaAutos = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  void initState(){
    super.initState();
    _loopAnimation = MyLoopAnimation(this);
    Controllerconsulta().queryVehiculoSel().then((value) => setState((){vehiculoSel = value;
      print('Vehiculosss ' +vehiculoSel.toString());
    _kmInicial.text = value!.kilometraje == '' ? '0' : value.kilometraje.toString(); }) );
    Conn.isInternet().then((connection){
      if(connection){
        vehiculos();
        accounts();
        print('Vehiculo '+vehiculoSel.toString());
        rutai(widget.info.id.toString(), vehiculoSel?.codigo_tipo ?? '',);
        //rutaoff(widget.info.id.toString(), vehiculoSel?.codigo_tipo ?? '',);
      }else{
        vehiculosOffConnection();
        clientesOffConnection();
        rutasOffConnection();
      }
    });
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
          crmid: element['crmid'],
          id: element['id'],
          nombre: element['nombre'],
          id_propietario: element['id_propietario'],
          nombre_propietario: element['nombre_propietario'],
          codigo_tipo: element['codigo_tipo'],
          tipo: element['tipo'],
          marca: element['marca'],
          modelo: element['modelo'],
          num_motor: element['num_motor'],
          poliza: element['poliza'],
          com_poliza: element['com_poliza'],
          vigencia: element['vigencia'],
          placas_est: element['placas_est'],
          num_serie: element['num_serie'],
          placas_fed: element['placas_fed'],
          kilometraje: element['kilometraje'],
        );

        Controllerconsulta().queryCountVehiculos(element['vehiculosid'].toString()).then((value) {
          if (value>0) {
            //print('value autos: ' + value.toString());
          } else {
            //INSERT EN LA TABLA DE AUTOS
            Controllerconsulta().addDataVehiculos(vehiculoo).then((value) {
              if (value > 0) {

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
    if (ruta!.isEmpty){
      Navigator.pop(context);
      showAlertDialog(context, 'Alerta', 'Este vehiculo no tiene ninguna ruta asignada.');
    }
    setState(() {
      listaRutas = ruta!;
      loading = false;
    });
  }

  void rutai(String id, String veh)async {
    var ruta = await getRutas(id, veh);
    if (ruta!.isEmpty){
      Navigator.pop(context);
      showAlertDialog(context, 'Alerta', 'Este vehiculo no tiene ninguna ruta asignada.');
    }
    setState(() {
      listaRutas = ruta;
      loading = false;
    });


    listaRutas.forEach((element) {

      Rutas rutass = Rutas(
        costorutaid: element["costorutaid"],
        estado: element["estado"],
        desc_ruta: element["desc_ruta"],
        tipo: element["tipo"],
        costo: element["costo"],
        comison: element["comison"],
        ruta_id: element['ruta_id'],
        cliente: element['accountname'],
        tipov: element['tipov'],
      ); print('rutas a bd' + rutass.toString());

      Controllerconsulta().queryCountRutas(element['costorutaid'].toString()).then((value) {
        if (value>0) {
          //print('value rutas: ' + value.toString());
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

    listaAutos.forEach((element) => vehiculos.add(element['id'].toString() + ' - ' + element['nombre'].toString()));
    listaAutos.forEach((element) => idsv.add(element['crmid']));

    listaRutas.forEach((element) => ruta.add(element['desc_ruta']+' - '+element['tipo']));
    listaRutas.forEach((element) { idsr.add(element['costorutaid']); idsc.add(element['account_id']);});
    print(listaRutas.toString());

    return  Center(
        child: Container(
          width: MediaQuery.of(context).size.width*.99,
            child: Form(
              key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Card(
                        color: ULTRA_LIGHT_BLUE_GHOST_COLOR,
                        //borderOnForeground: false,
                        elevation: 7,
                        child: Column(
                        children: <Widget>[
                          SizedBox(height: 15,),

                          Container(
                            padding: EdgeInsets.only(left: 21, right: 21, bottom: 1.0),
                              child: Container(
                            child: SearchChoices.single(
                              // onClear: ()=>this.activoT= '',
                              clearIcon: Icon(Icons.clear, color: DARK_BLUE_COLOR),
                              icon: Icon(Icons.search, color: DARK_BLUE_COLOR,),
                              onClear: (){
                                setState(() {
                                  rutas = '';
                                  valueDropdownRutas = '';
                                  valueDropdownClientes = '';
                                  showType = false;
                                });
                              },
                              fieldDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(width: 2, color: DARK_BLUE_GHOST_COLOR),
                              ),
                              hint: Text('  Seleccionar Ruta', style: TextStyle(color: DARK_BLUE_COLOR)),
                              items: ruta.map<DropdownMenuItem<String>>((val){
                                return DropdownMenuItem<String>(
                                    value: val,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*.75,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Ajusta los valores según sea necesario
                                        child: Text(val, softWrap: true, textAlign: TextAlign.left,
                                        ),
                                      ),
                                    )
                                );
                              }).toList(),
                              value: rutas,
                              onChanged: (newValue3){
                                setState(() {
                                  for(int i = 0; i < idsr.length; i++){
                                    if(listaRutas[i]['desc_ruta']+' - '+listaRutas[i]['tipo']== newValue3){
                                      setState(() {
                                        valueDropdownRutas = idsr[i].toString();
                                        valueDropdownClientes = idsc[i].toString();
                                        rutas = newValue3;
                                        tipoViaje = listaRutas[i]['tipo'];
                                        ruta_nombre = listaRutas[i]['desc_ruta'];
                                        showType = true;
                                        print(ruta_nombre);
                                      });
                                    }
                                  }
                                });
                              },
                              isExpanded: true,
                            ),
                          ),),
                          if(showType)
                            Text('Viaje '+ (tipoViaje ?? 'N/A'), style: TEXT_MEDIUM_BOLD, textAlign: TextAlign.left,),
                          SizedBox(height: 12),
                          Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 21, right: 21, bottom: 1.0),
                                child: Container(
                                  child: TextField(
                                      decoration:  InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:  BorderSide(color: DARK_BLUE_GHOST_COLOR, width: 2),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:  BorderSide(color: DARK_BLUE_GHOST_COLOR, width: 2),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          border: OutlineInputBorder(),
                                          labelText: 'Comentarios',
                                          labelStyle: TextStyle(color: DARK_BLUE_COLOR ),
                                          focusColor: DARK_BLUE_COLOR

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
                                          borderSide:  BorderSide(color: DARK_BLUE_GHOST_COLOR, width: 2),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:  BorderSide(color: DARK_BLUE_GHOST_COLOR, width: 2),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        border: OutlineInputBorder(),
                                        labelText: 'Kilometraje inicial',
                                        labelStyle: TextStyle(color: DARK_BLUE_COLOR ),
                                        focusColor: DARK_BLUE_COLOR

                                      ),
                                      controller: _kmInicial,
                                      keyboardType: TextInputType.number,
                                      maxLength: 100,
                                      maxLines: null,
                                      textAlign: TextAlign.left,

                                  ),
                                  width: MediaQuery.of(context).size.width*.85,
                                ),
                          ),
                          Container(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DARK_BLUE_COLOR,
                              ),
                              child: Text('Guardar e iniciar', style: TextStyle(color: LIGHT), textAlign : TextAlign.center),
                              onPressed: ()async{

                                if(_kmInicial.text != '' ) {
                                  if (_formKey.currentState!.validate()) {
                                    showToast(context, 'Espere...');
                                    Controllerconsulta().queryDataTravelID().then((value) {
                                      var idviajep = value + 1;

                                      final hora = DateTime.now().toString().substring(11, 19);
                                      String today = DateTime.now().toString().substring(0, 10);
                                      print('Guardado con la hora '+hora.toString());
                                      Viaje viaje = Viaje(
                                          viajesid: idviajep.toString(),
                                          viaje_id: 'local',
                                          fecha: today,
                                          hora_prev: hora,
                                          vehiculo_id: vehiculos_nombre.toString(),
                                          ruta_id: ruta_nombre.toString(),
                                          accountname: clientes_nombre.toString());

                                      Controllerconsulta().addDataTravel(viaje).then((value) {
                                        if (value > 0) {
                                          ViajeD travelDetails = ViajeD(
                                              viajesid: idviajep.toString(),
                                              viaje_id: 'local',
                                              nombre_ruta: ruta_nombre.toString(),
                                              fecha: today,
                                              hora_prev: hora,
                                              vehiculo_id: vehiculoSel?.nombre.toString(),
                                              ruta_id: valueDropdownRutas!.toString(),
                                              cliente: clientes_nombre.toString(),
                                              comentario: _comentarios.text,
                                              centro: '',
                                              horario_inicio: hora,
                                              horario_final: '',
                                              kil_ini: _kmInicial.text,
                                              kil_fin: '',
                                              vehiculosid: vehiculoSel?.crmid.toString(),
                                              idcliente: valueDropdownClientes!.toString(),
                                              tipo: tipoViaje.toString()
                                          );

                                          Controllerconsulta().addDataDetails(travelDetails).then((value) {
                                            //print('Resultado '+value.toString());
                                            if (value > 0) {
                                              showToast(context, 'Viaje creado e iniciado');
                                              //print("correcta inserción de detalles n");
                                              Navigator.pushNamedAndRemoveUntil(context,
                                                '/home',
                                                    (Route<dynamic> route) => false,
                                                arguments: {'datos': widget.info,
                                                  'save': false,},
                                              );
                                            } else {
                                              showToast(context, 'Ocurrió un error');
                                              //print("fallo insercion detalles n");
                                            }
                                          });
                                        } else {
                                          showToast(context, 'Ocurrió un error');
                                          // print('fallo la insercion del viaje n');
                                        }
                                      });
                                    });
                                  }
                                }else{
                                  showToast(context, 'El kilometraje inicial es necesario para continuar',);
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
          foregroundColor: LIGHT,
          title: Text('Agregar viaje', style: TextStyle(fontFamily: 'PTSerif')),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: loading ? Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width)) : ListView(
            children: <Widget>[
              _addViajes(),
            ])
    );
  }


}

