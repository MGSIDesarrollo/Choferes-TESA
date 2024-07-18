  import 'dart:convert';
  import 'package:choferes/request.dart';
  import 'package:choferes/viajes/controllerVehiculos.dart';
  import 'package:flutter/material.dart';
  import 'package:search_choices/search_choices.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:crypto/crypto.dart';

  import 'DBlocal/consultas.dart';
  import 'conexion/conn.dart';
  import 'controller/Usuario.dart';
  import 'funciones/alertas.dart';
  import 'funciones/colores.dart';
  import 'funciones/sesiones.dart';

  class SelectVehiculo extends StatefulWidget {
    final Usuario info;
    final bool mostrarAppBar;
    SelectVehiculo({Key? key, required this.info, required this.mostrarAppBar}) : super(key: key);

    @override
    _SelectVehiculoState createState() => _SelectVehiculoState();
  }

  class _SelectVehiculoState extends State<SelectVehiculo> {

    String? valueDropdownAutos;
    String? autoSel;
    String? vehiculos_nombre;
    String kmInicial = '0';
    Vehiculo? vehiculoSel;
    TextEditingController kilometraje = TextEditingController();
    bool showButton = false, mostrarAppBar = false, showKm = false;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    var listaAutos = [];

    void initState() {
      super.initState();
      print('Datos de sesion: '+widget.info.toString());
      Conn.isInternet().then((connection) {
        if (connection) {
          print('Hay conexion ');
          vehiculos();
        } else {
          vehiculosOffConnection();
        }
      });
      Controllerconsulta().queryVehiculoSel().then((value) {
        setState(() {
          vehiculoSel = value;
          print('Vehiculo en bd '+value.toString());
          if (value != null) {
            kilometraje.text = value.kilometraje == '' ? '0' : value.kilometraje!;
            autoSel = value.id.toString()+' - '+value.nombre.toString();
            kmInicial = value.kilometraje == null ? '0' : (value.kilometraje == '' ? '0' : value.kilometraje!);
            vehiculos_nombre = autoSel;
          }else{
            kilometraje.text = '0';
          }
        });
      });
    }

    void vehiculosOffConnection()async{
      var vehiculos = await Controllerconsulta().queryDataVehiculos();
      setState(() {
        listaAutos = vehiculos!;
      });
    }

    void vehiculos() async{
      getAutos().then((vehiculos) {
        setState(() {
          listaAutos = vehiculos!;
        });
        listaAutos.forEach((element) {
          Vehiculo vehiculoo = Vehiculo(
            crmid: element['crmid'] ?? '',
            id: element['id'] ?? '',
            nombre: element['nombre'] ?? '',
            id_propietario: element['id_propietario'] ?? '',
            nombre_propietario: element['nombre_propietario'] ?? '',
            codigo_tipo: element['codigo_tipo'] ?? '',
            tipo: element['tipo'] ?? '',
            marca: element['marca'] ?? '',
            modelo: element['modelo'] ?? '',
            num_motor: element['num_motor'] ?? '',
            poliza: element['poliza'] ?? '',
            com_poliza: element['com_poliza'] ?? '',
            vigencia: element['vigencia'] ?? '',
            placas_est: element['placas_est'] ?? '',
            num_serie: element['num_serie'] ?? '',
            placas_fed: element['placas_fed'] ?? '',
            kilometraje: element['kilometraje'] ?? '',
          );

          Controllerconsulta().queryCountVehiculos(element['crmid'].toString()).then((value) {
            if (value>0) {
              //print('value autoSel: ' + value.toString());
            } else {
              //INSERT EN LA TABLA DE AUTOS
              Controllerconsulta().addDataVehiculos(vehiculoo).then((value) {
                if (value > 0) {
                  print("correcta inserción de vehiculos");
                } else {
                  print("fallo insercion vehiculos");
                }
              });
            }
          });//query count
        });
      });
    }

    Widget selectVehiculo() {
      var vehiculos = [];
      var idsv = [];
      listaAutos.forEach((element){
        if(element['crmid'].toString() != vehiculoSel?.crmid.toString()) {
          vehiculos.add(element['nombre'].toString());
        }
      });
      listaAutos.forEach((element) => idsv.add(element['crmid']));
      return Card(
        color: Colors.white,
        borderOnForeground: false,
        elevation: 7,
        child: Column(children: [
          SizedBox(height: 10,),
          Center(child: Text('Vehículo actual: ',textAlign: TextAlign.center, style: TEXT_LARGE_LABEL_STYLE,)),
          Container(child: Text(vehiculoSel != null ? vehiculoSel!.nombre.toString() : 'No hay un vehiculo seleccionado', style: TEXT_LARGE),),
          SizedBox(height: 15,),
          //if (vehiculoSel != null || kmInicial == '0')
          Column(children: [
            if (showKm)
            Container(
              padding: const EdgeInsets.only(
                  top: 1.0, bottom: 5.0),

              width: MediaQuery.of(context).size.width * .85,
              child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1),
                      borderRadius: BorderRadius
                          .circular(8.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Kilometraje',
                    labelStyle: TextStyle(
                        color: Colors.blueGrey),
                  ),
                  controller: kilometraje,
                  onChanged: (val){
                    if (autoSel != '' && autoSel != null){
                      setState(() {
                        //showButton = true;
                        kilometraje.text = val;
                      });
                    }else{
                      setState(() {
                        showButton = false;
                      });
                    }
                  },
                  keyboardType: TextInputType
                      .number,
                  maxLength: 100,
                  maxLines: null,
                  textAlign: TextAlign.left
              ),
            ),
          ],),
          Center(child: Text('Seleccionar vehículo: ',textAlign: TextAlign.center, style: TEXT_LABEL_STYLE,)),
          Container(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius
                    .circular(8.0)),
                border: Border.all(color: Colors.grey)
            ),
            width: MediaQuery.of(context).size.width * .85,
            child: SearchChoices.single(
              // onClear: ()=>this.activoT= '',
              onClear: () {
                showKm = false;
                autoSel = '';
                valueDropdownAutos = '';
                showButton = false;
              },
              underline: SizedBox(),
              hint: Text('Vehiculo'),
              items: vehiculos.map<DropdownMenuItem<String>>((val) {
                return DropdownMenuItem<String>(
                    value: val,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: Text(
                        val,
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    )
                );
              }).toList(),
              value: autoSel,
              onChanged: (newValue) {
                setState(() {
                  for (int i = 0; i < idsv.length; i++) {
                    if (listaAutos[i]['nombre'] == newValue) {
                      valueDropdownAutos = idsv[i].toString();
                      autoSel = newValue;
                      vehiculos_nombre = listaAutos[i]['nombre'];
                      showButton = true;
                      kilometraje.text = listaAutos[i]['kilometraje'] ?? '0';
                      kmInicial = listaAutos[i]['kilometraje'] ?? '0';
                      showKm = true;
                    }
                  }
                });
              },
              isExpanded: true,
            ),
          ),
          SizedBox(height: 10,),
          if (showButton)
            ElevatedButton(
              onPressed: ()  {
                Conn.isInternet().then((connection) {
                  if (connection) {
                    showAlertSelectDialog(context, '¿Seguro que desea seleccionar el vehículo ' + vehiculos_nombre.toString() + '?').then((value) {
                      if (value == true) {
                        if (kmInicial != kilometraje.text) {
                          showAlertSelectDialog(context, '¿Seguro que desea cambiar el kilometraje del vehiculo?').then((confKm) {
                            setVehiculo(idsv, change: true);
                          });
                        }else{
                          setVehiculo(idsv);
                        }
                      }
                    });
                  } else {
                    showAlertDialog(context, 'Sin conexión', 'Necesita conexión para actualizar su vehiculo');
                  }
                });
              }, style: DARK_BUTTON_STYLE,
              child: Text('Guardar', style: TEXT_BUTTON_STYLE),),
          if (showButton) SizedBox(height: 10,),

        ]),
      );
    }

    setVehiculo(List idsv, {change = false}) async {
      print('setVehiculo');
      for (int i = 0; i < idsv.length; i++) {
        if (valueDropdownAutos == idsv[i].toString()) {
          print('Datos '+valueDropdownAutos.toString()+' '+widget.info.toString());
          Vehiculo vehiculo = Vehiculo.fromJSON(listaAutos[i]);
          if (change) {
            upKilometraje(kilometraje.text, vehiculo.crmid!);
          }
          showAlertDialog(context, 'Exito!', 'Vehículo actualizado correctamente.', icono: Icon(null));
          Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
                Controllerconsulta().addVehiculoSel(vehiculo, widget.info.id.toString()).then((value){
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false,
                      arguments: {'datos': widget.info, 'save': true } );
            });
          });
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      _firebaseMessaging.getToken().then((res) {
        var key = utf8.encode(widget.info.telefono!);
        var bytes = utf8.encode(widget.info.nombres!);

        var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
        var digest = hmacSha256.convert(bytes);
        print('token' + res.toString());
        saveSessionFunct(digest.toString());
        saveTokenReq(
            res!,
            digest.toString(),
            widget.info.id.toString()
        );
      });
      return Scaffold(
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
        body: SingleChildScrollView(child:
          Column(children: [
            Padding(padding: EdgeInsets.all(10),
              child: selectVehiculo(),),
          ]),
        ),
      );
    }
  }


