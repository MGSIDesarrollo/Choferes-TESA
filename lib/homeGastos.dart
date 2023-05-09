/*
Developed by: Vanessa Garcia - 2023
 */
import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/request.dart';
import 'package:flutter/material.dart';

import 'AddGastos.dart';
import 'DBlocal/consultas.dart';
import 'controller/Usuario.dart';
import 'funciones/colores.dart';
import 'funciones/sesiones.dart';
import 'gastos/controllerGastos.dart';
import 'gastosDetails.dart';


class HomeGastos extends StatefulWidget {
  //String id;
  final Usuario info;
  static const routeName = '/HomeGastos';
  HomeGastos({Key? key, required this.info}) : super(key: key);

  @override
  _HomeGastosState createState() => _HomeGastosState();
}


class _HomeGastosState extends State<HomeGastos> {

  List? list;
  bool loading = true;
  Future userList()async{
    list = await Controllerconsulta().queryDataGastos();
    setState(() {loading=false;});
    //print(list);
  }

  List? list2;
  bool loading2 = true;

  Future userList2(String id)async{
    list2 = await Controllerconsulta().queryDataGastosDetails(id.toString());
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
                title: Text('${data[index]['gasto_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Proveedor:  ${data[index]['proveedor']}\nCosto: \$${data[index]['costo']}\nLitros:  ${data[index]['litros']}\nFecha:  ${data[index]['fecha_gasto']}",
                  style: TextStyle(color: Colors.black, fontSize: 14.5),
                ),
                onTap:(){
                  //print ('presionaste el gasto numero:' + data[index]['gastosid']);
                  getGastoDetails(widget.info.id.toString(), data[index]['gastosid']).then((value){
                    // print('revs detalles: ' + value.toString());
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => gastosDetails(
                        detalles:value,
                        id_user: widget.info.id.toString()
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
                title: Text('${data[index]['gasto_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Proveedor:  ${data[index]['proveedor']}\nCosto:  \$${data[index]['costo']}\nLitros:  ${data[index]['litros']}\nFecha:  ${data[index]['fecha_gasto']}",
                  style: TextStyle(color: Colors.black, fontSize: 14.5),
                ),
                onTap:(){
                  //print ('presionaste el gasto numero:' + data[index]['gastosid']);
                  userList2(data[index]['gastosid']);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => gastosDetails(
                      detalles:list2?[0],
                      id_user: widget.info.id.toString()
                  )
                  )
                  );
                  print(data[index]['gastosid']);
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

  Widget _gastos()=>FutureBuilder(
    future: getGastos(widget.info.id.toString()),
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      if(snapshot.hasData) {
        if (snapshot.data.length==0) return emptyResponse;
        // print('snapshot viajes: ' + snapshot.data.length.toString());

        for (var i = 0; i < snapshot.data.length; i++){
          Controllerconsulta().queryCountGastos(snapshot.data[i]['gastosid'].toString()).then((value) {
            if(value>0){
              print('value gastos if: ' + value.toString());
            }else{
              //INSERT table: gastos
              Gastos gastos = Gastos(
                gastosid: snapshot.data[i]['gastosid'].toString(),
                gasto_id: snapshot.data[i]['gasto_id'].toString(),
                concepto: snapshot.data[i]['concepto'].toString(),
                costo: snapshot.data[i]['costo'].toString(),
                proveedor: snapshot.data[i]['proveedor'].toString(),
                litros: snapshot.data[i]['litros'].toString(),
                fecha_gasto: snapshot.data[i]['fecha_gasto'].toString(),
                vehiculo_id: snapshot.data[i]['vehiculo_id'].toString()
              );
              Controllerconsulta().addDataGastos(gastos).then((value){
                if(value>0){
                  //print("correcta inserción del gasto");

                  getGastoDetails(widget.info.id.toString(), snapshot.data[i]['gastosid'].toString()).then((value){
                    //print('detalles del viaje: ' +value!.viajesid.toString());
                    GastoD gastosD = GastoD(
                      gastosid: value!.gastosid,
                      gasto_id: value.gasto_id,
                      concepto: value.concepto,
                      tipo_pago: value.tipo_pago,
                      costo: value.costo,
                      proveedor: value.proveedor,
                      litros: value.litros,
                      precio_litro: value.precio_litro,
                      kilometraje: value.kilometraje,
                      comentario: value.comentario,
                      fecha_gasto: value.fecha_gasto,
                      km_ini: value.km_ini,
                      rendimiento: value.rendimiento,
                      recorrido: value.recorrido,
                      hora: value.hora,
                      pxk: value.pxk,
                      vehiculo_id: value.vehiculo_id,
                    );

                    Controllerconsulta().addDataGastosDetails(gastosD).then((value){

                      if (value>0) {
                        print('valor en el insert gasto: ' + value.toString());
                        print("correcta inserción de detalles gasto");
                      }else{
                        print("fallo insercion detalles gasto");
                      }
                    });

                  });
                }else{
                  print('fallo la insercion del gasto');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gastos(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: inteco,
        onPressed: (){
         // print('boton agregar');
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddGastos(
              info: widget.info
          )
          )
          );
        },
      ),
    );
  }
}