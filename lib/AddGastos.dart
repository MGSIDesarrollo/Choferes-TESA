import 'package:choferes/funciones/alertas.dart';
import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/gastos/controllerGastos.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerClientes.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerProveedores.dart';
import 'package:choferes/viajes/controllerRutas.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:toast/toast.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'controller/Usuario.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';
import 'gastosDetails.dart';

class AddGastos extends StatefulWidget {
  //String id;
  final Usuario info;

  static const routeName = '/addgastos';
  AddGastos({Key? key, required this.info,}) : super(key: key);

  @override
  _AddGastosState createState() => _AddGastosState();
}

class _AddGastosState extends State<AddGastos> {

  TextEditingController? _costo;
  TextEditingController? _litros;
  TextEditingController? _folio;
  TextEditingController? _comentarios;
  TextEditingController? _kilometraje;
  String? valueDropdownAutos;
  String? autos;
  String? vehiculos_nombre;
  String? valueDropdownPago;
  String? valueDropdownConcepto;
  String? valueDropdownProveedor;
  String? proveedor;
  Vehiculo? vehiculoSel;

  //TextEditingController dateController2=TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //var listaAutos = [];
  var listaProveedores = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  void initState(){
    super.initState();
    Controllerconsulta().queryVehiculoSel().then((value) => setState((){
      vehiculoSel = value;
    valueDropdownAutos = vehiculoSel!.crmid.toString();}) );
    Conn.isInternet().then((connection){
      if(connection){
        //vehiculos();
        proveedores();
      }else{
        vehiculosOffConnection();
        proveedoresOffConnection();
      }
    });

    _kilometraje=TextEditingController();
    autos = '';
    vehiculos_nombre = '';
    _comentarios=TextEditingController();
    _costo=TextEditingController();
    _litros=TextEditingController();
    _folio=TextEditingController();

  }

  void vehiculosOffConnection()async{
    var vehiculos = await Controllerconsulta().queryDataVehiculos();
    setState(() {
      //print('lista de autos offline: '+vehiculos.toString());
      //listaAutos = vehiculos!;
    });
  }



  void proveedores()async {
    var provee = await getProveedores();
    setState(() {
      listaProveedores = provee!;
    });

    listaProveedores.forEach((element) {
      Proveedores proveed = Proveedores(
        targetvalues: element['targetvalues'],
      );

      Controllerconsulta().queryCountProveedores().then((value) {
        if (value>0) {
          print('value proveedores: ' + value.toString());
        } else {
          //INSERT EN LA TABLA DE PROVEEDORES
          Controllerconsulta().addDataProveedores(proveed).then((value) {
            if (value > 0) {
              print('valor en el insert proveedores: ' + value.toString());
              print("correcta inserción de proveedores");
            } else {
              print("fallo insercion proveedores");
            }
          });
        }
      });//query count
    }); //foreach
  }

  void proveedoresOffConnection()async{
    var provee = await Controllerconsulta().queryDataProveedores();
    setState(() {
      listaProveedores = provee!;
    });
  }


    Widget titulo() =>
        Padding(
            padding: const EdgeInsets.only(left: 15.0,),
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

    Widget pago_select() =>
        Center(
            child: Theme(
                data: ThemeData(
                    canvasColor: Colors.white
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      hint: Text('*Pago'),
                      value: valueDropdownPago,
                      items: <String>['Efectivo', 'Transferencia', 'Credito'].map<
                          DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                              child: Text(
                                value,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            )
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          valueDropdownPago = newValue.toString();
                        });
                      }
                  ),
                )
            )
        );

    Widget concepto_select() =>
        Center(
            child: Theme(
                data: ThemeData(
                    canvasColor: Colors.white
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      hint: Text('*Concepto'),
                      value: valueDropdownConcepto,
                      items: <String>['Gasolina', 'Diesel', 'Gas natural'].map<
                          DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                              child: Text(
                                value,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            )
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          valueDropdownConcepto = newValue.toString();
                        });
                      }
                  ),
                )
            )
        );

    Widget _addGasto() {
      var vehiculos = [];
      var idsv = [];
      var proveedores = [];


      listaProveedores.forEach((element) => proveedores.add(element['targetvalues']));

      return Center(
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .99,
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
                                  SizedBox(height: 12),
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
                                        valueDropdownProveedor = '';
                                      },
                                      underline: SizedBox(),
                                      hint: Text((valueDropdownProveedor == null || valueDropdownProveedor == '') ? 'Proveedor' : valueDropdownProveedor!),
                                      items: proveedores.map<DropdownMenuItem<String>>((val) {
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
                                      value: valueDropdownProveedor,
                                      onChanged: (newValue) {
                                        print('New '+newValue);
                                        setState(() {
                                          for (int i = 0; i < proveedores.length; i++) {
                                            print('en if '+newValue+' '+listaProveedores[i]['targetvalues']);
                                            if (listaProveedores[i]['targetvalues']== newValue) {
                                              valueDropdownProveedor = newValue;
                                            }
                                          }
                                        });
                                      },
                                      isExpanded: true,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                            padding: const EdgeInsets.only(
                                                top: 1.0, bottom: 3.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                border: Border.all(color: Colors.grey)
                                            ),
                                            width: MediaQuery.of(context).size.width * .40,
                                            child: pago_select()
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(
                                                top: 1.0, bottom: 3.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                border: Border.all(color: Colors.grey)
                                            ),
                                            width: MediaQuery.of(context).size.width * .40,
                                            child: concepto_select()
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 21,
                                            right: 21,
                                            bottom: 1.0),
                                        child: Container(
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
                                                labelText: 'Km de carga',
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              controller: _kilometraje,
                                              keyboardType: TextInputType
                                                  .number,
                                              maxLength: 100,
                                              maxLines: null,
                                              textAlign: TextAlign.left
                                          ),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * .90,

                                        ),
                                      )
                                  ),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 21,
                                            right: 21,
                                            bottom: 1.0),
                                        child: Container(
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
                                                labelText: 'Litros cargados',
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              controller: _litros,
                                              keyboardType: TextInputType.number,
                                              maxLength: 100,
                                              maxLines: null,
                                              textAlign: TextAlign.left
                                          ),

                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * .90,
                                        ),
                                      )
                                  ),

                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 21,
                                            right: 21,
                                            bottom: 1.0),
                                        child: Container(
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
                                              labelText: 'Precio por litro',
                                              labelStyle: TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                            controller: _costo,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            maxLength: 100,
                                            maxLines: null,
                                            textAlign: TextAlign.left,
                                          ),
                                          width: MediaQuery.of(context).size.width * .90,
                                        ),
                                      )
                                  ),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 21,
                                            right: 21,
                                            bottom: 1.0),
                                        child: Container(
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
                                                labelText: 'Folio',
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              controller: _folio,
                                              keyboardType: TextInputType.text,
                                              maxLength: 100,
                                              maxLines: null,
                                              textAlign: TextAlign.left,
                                          ),

                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * .90,
                                        ),
                                      )
                                  ),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 21,
                                            right: 21,
                                            bottom: 1.0),
                                        child: Container(
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
                                                labelText: 'Comentarios',
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              controller: _comentarios,
                                              keyboardType: TextInputType.text,
                                              maxLength: 500,
                                              maxLines: null,
                                              textAlign: TextAlign.left
                                          ),
                                          width: MediaQuery.of(context).size.width * .90,
                                        ),
                                      )
                                  ),
                                  Container(
                                    height: 40,
                                    width: 150,
                                    child: ElevatedButton(
                                      style: DARK_BUTTON_STYLE,
                                      child: Text('Guardar',
                                          style: TEXT_BUTTON_STYLE,
                                          textAlign: TextAlign.center),
                                      onPressed: () async {

                                      var idgastosn = await Controllerconsulta().queryDataGastosID();
                                         idgastosn = idgastosn+1;
                                        if (_formKey.currentState!.validate()) {
                                          if (!(valueDropdownAutos == null || valueDropdownConcepto == null || valueDropdownPago == null|| valueDropdownProveedor == null || _kilometraje!.text == '' || _litros!.text == '' || _costo!.text == '' || _folio!.text == '')) {
                                            Conn.isInternet().then((connection) {
                                              if (connection) {
                                                guardarGastos(
                                                    widget.info.id.toString(),
                                                    valueDropdownProveedor!.toString(),
                                                    _costo!.text,
                                                    _kilometraje!.text,
                                                    _comentarios!.text,
                                                    DateTime.now().toString(),
                                                    _litros!.text,
                                                    valueDropdownAutos!.toString(),
                                                    valueDropdownPago!.toString(),
                                                    valueDropdownConcepto!.toString(),
                                                    _folio!.text).then((value) {
                                                  Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) =>
                                                              gastosDetails(
                                                                  detalles: value,
                                                                  id_user: widget.info.id.toString())));
                                                });
                                              }
                                              else {
                                                String hoy = DateTime.now().toString();

                                                double? litrop = double.parse(_litros!.text);
                                                double? pxl = double.parse(_costo!.text);

                                                var total = pxl * litrop;

                                                Gastos gastos = Gastos(
                                                    gastosid: idgastosn.toString(),
                                                    gasto_id: 'local',
                                                    concepto: valueDropdownConcepto!.toString(),
                                                    costo: total.toString(),
                                                    proveedor: valueDropdownProveedor!.toString(),
                                                    litros: _litros!.text,
                                                    fecha_gasto: hoy.substring(0, 10),
                                                    vehiculo_id: valueDropdownAutos!.toString()
                                                );

                                                Controllerconsulta().addDataGastos(gastos).then((value) {
                                                  if (value > 0) {

                                                    GastoD gastod = GastoD(
                                                        gastosid: idgastosn.toString(),
                                                        gasto_id: 'local',
                                                        concepto: valueDropdownConcepto!.toString(),
                                                        tipo_pago: valueDropdownPago!.toString(),
                                                        costo: total.toString(),
                                                        proveedor: valueDropdownProveedor!.toString(),
                                                        litros: _litros!.text,
                                                        precio_litro: _costo!.text,
                                                        kilometraje: _kilometraje!.text,
                                                        comentario: _comentarios!.text,
                                                        fecha_gasto: hoy.substring(0, 10),
                                                        km_ini: '0',
                                                        rendimiento: (double.parse(_kilometraje?.text ?? '0')/double.parse(_litros?.text ?? '1')).toString(),
                                                        recorrido: '0',
                                                        hora: hoy.substring(11, 19),
                                                        pxk: (total/double.parse(_kilometraje?.text ?? '1')).toString(),
                                                        vehiculo_id: valueDropdownAutos!.toString(),
                                                        folio: _folio!.text
                                                    );

                                                    Controllerconsulta().addDataGastosDetails(gastod).then((value) {
                                                      if (value > 0) {
                                                        Navigator.pop(context);
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => gastosDetails(detalles: gastod, id_user: widget.info.id.toString())));
                                                      } else {
                                                        showToast(context, 'Hubo un error con la inserción');
                                                      }
                                                    });
                                                  } else {
                                                    //print('fallo la insercion del gasto n');
                                                  }
                                                });
                                              }
                                            });
                                          }else{
                                            showToast(context, 'Complete los campos vacíos para continuar');
                                          }
                                        }
                                      }

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
            title: Text('Agregar gasto'),
            backgroundColor: DARK_BLUE_COLOR,
          ),
          body: ListView(
              children: <Widget>[
                _addGasto(),
              ])
      );
    }
  }


