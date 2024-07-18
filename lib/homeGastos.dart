import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'AddGastos.dart';
import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'controller/Usuario.dart';
import 'package:choferes/viajes/controllerVehiculos.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/widgets.dart';
import 'gastos/controllerGastos.dart';
import 'gastosDetails.dart';
import 'mapa.dart';

class HomeGastos extends StatefulWidget {
  final Usuario info;
  static const routeName = '/HomeGastos';
  HomeGastos({Key? key, required this.info}) : super(key: key);

  @override
  _HomeGastosState createState() => _HomeGastosState();
}

class _HomeGastosState extends State<HomeGastos> with SingleTickerProviderStateMixin{

  List list = [];
  List bodylist = [];
  int itemQuantity = 3;
  Vehiculo? vehiculoSel;
  bool localload = true;
  int anio = DateTime.now().year;
  int numeroSemana = 1;
  List<Map<String, dynamic>>? semanas;
  Map<String, dynamic>? semanaSeleccionada;
  Future <bool> userList() async{
    list = await Controllerconsulta().queryDataGastos();
    setState(() { bodylist = list;});
    return true;
  }

  List? list2;
  bool loading = true, conexion = false, loading2 = true, waiting= true;
  DateTime? startDate, endDate;
  late MyLoopAnimation _loopAnimation;
  Future userList2(String id)async{
    list2 = await Controllerconsulta().queryDataGastosDetails(id.toString());
    setState(() {loading2=false;});
  }
  @override
  void initState(){
    super.initState();
    userList();
    super.initState();
    semanas = obtenerSemanasAnio(anio);
    if (semanas!.isNotEmpty) {
      semanaSeleccionada = obtenerSemanaActual();
      print(semanaSeleccionada.toString());
      startDate = semanaSeleccionada?['inicio'] ?? DateTime.now();
      endDate = semanaSeleccionada?['fin'] ?? DateTime.now();
    }
    setGastos(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
    _loopAnimation = MyLoopAnimation(this);
    Controllerconsulta().queryVehiculoSel().then((value) =>
      setState(() {
        vehiculoSel = value;
      }));
  }

  Widget _body(List data) {
    print('gastos '+data.toString());
    return data.isEmpty ? emptyGastos :
      GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemQuantity,
        childAspectRatio: itemQuantity == 1 ? 3.0 : 1.0,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            decoration: DECORATION_BLUE_GRADIENT,
            child: ListTile(
              //trailing: Icon(Icons.keyboard_arrow_right, color: DARK,),
              title: null, //Text('${data[index]['gasto_id']}', style: titleSize(),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Proveedor:  ${data[index]['proveedor']}", maxLines: 2, overflow: TextOverflow.ellipsis, style: textSize(),),
                  Text("Costo: \$${data[index]['costo']}", overflow: TextOverflow.ellipsis, style: textSize(),),
                  Text("Litros:  ${data[index]['litros']}", overflow: TextOverflow.ellipsis, style: textSize(),),
                  Text("Fecha:  ${data[index]['fecha_gasto']}", overflow: TextOverflow.ellipsis, style: textSize(),),
                ],
              ),
              onTap: () {
                getGastoDetails(widget.info.id.toString(), data[index]['gastosid']).then((value){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => gastosDetails(
                      detalles:value,
                      id_user: widget.info.id.toString()
                  )));
                });
              },
            ),
          ),
        );
      },
    );
  }

  setGastos(String fInicial, String fFinal) async {
      bool conn = await Conn.isInternet();
      if (conn){
        getGastos(widget.info.id.toString(), vehiculoSel?.crmid.toString() ?? '', fInicial, fFinal).then((value) {
          setState(() {
            bodylist = value ?? [];
            waiting = false;
            loading = false;
            if (value != null && value != []){
              Controllerconsulta().deleteAllDataGastos();
              for (var i = 0; i < value.length; i++){
                Controllerconsulta().queryCountGastos(value[i]['gastosid'].toString()).then((val) {
                  if(val>0){
                  }else{
                    //INSERT table: gastos
                    Gastos gastos = Gastos(
                        gastosid: value[i]['gastosid'].toString(),
                        gasto_id: value[i]['gasto_id'].toString(),
                        concepto: value[i]['concepto'].toString(),
                        costo: value[i]['costo'].toString(),
                        proveedor: value[i]['proveedor'].toString(),
                        litros: value[i]['litros'].toString(),
                        fecha_gasto: value[i]['fecha_gasto'].toString(),
                        vehiculo_id: value[i]['vehiculo_id'].toString()
                    );
                    Controllerconsulta().addDataGastos(gastos).then((resp){
                      if(resp>0){
                        //print("correcta inserción del gasto");

                        getGastoDetails(widget.info.id.toString(), value[i]['gastosid'].toString()).then((info){
                          //print('detalles del viaje: ' +value!.viajesid.toString());
                          GastoD gastosD = GastoD(
                            gastosid: info!.gastosid,
                            gasto_id: info.gasto_id,
                            concepto: info.concepto,
                            tipo_pago: info.tipo_pago,
                            costo: info.costo,
                            proveedor: info.proveedor,
                            litros: info.litros,
                            precio_litro: info.precio_litro,
                            kilometraje: info.kilometraje,
                            comentario: info.comentario,
                            fecha_gasto: info.fecha_gasto,
                            km_ini: info.km_ini,
                            rendimiento: info.rendimiento,
                            recorrido: info.recorrido,
                            hora: info.hora,
                            pxk: info.pxk,
                            vehiculo_id: info.vehiculo_id,
                            folio: info.folio,
                          );

                          Controllerconsulta().addDataGastosDetails(gastosD).then((value){

                            if (value>0) {
                              //print('valor en el insert gasto: ' + value.toString());
                              //print("correcta inserción de detalles gasto");
                            }else{
                              //print("fallo insercion detalles gasto");
                            }
                          });

                        });
                      }else{
                        //print('fallo la insercion del gasto');
                      }//else
                    });
                  }//else
                });
              }
            }
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: LIGHT,
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
        backgroundColor: DARK_BLUE_COLOR,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ((){
              setState(() {
                loading = true;
                waiting = true;
                startDate = semanaSeleccionada!['inicio'];
                endDate = semanaSeleccionada!['fin'];
                setGastos(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
              });}),
          ),
          IconButton(
            icon: Icon(itemQuantity == 1 ? Icons.grid_view : itemQuantity == 2 ? Icons.grid_on_sharp : Icons.view_list),
            onPressed: _changeItemView,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:([
          Center(child: Text('Semana actual: '+(obtenerSemanaActual()?['numero'] ?? '0').toString(), style: TEXT_LARGE_LABEL_STYLE, textAlign: TextAlign.center,),),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:([
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: DARK_BLUE_COLOR
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Selecciona una semana'),
                      content: SingleChildScrollView(
                        child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),child: _selectWeek(context),),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                ),
                child: Row(children: [
                  Text('Semana ${semanaSeleccionada!['numero']}', style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05, color: LIGHT),),
                  Icon(Icons.arrow_drop_down_outlined, color: LIGHT,),
                ],),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => Mapa()),
                  );
                },
                child: Text('Mapa de gasolineras', style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05, color: LIGHT)),
              ),
            ]),),
          Expanded(child: waiting ? stateBody() : _body(bodylist),),
        ]),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 16.0,
            right: 0.0,
            child: Row(children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DARK_BLUE_COLOR,
                  shape: CircleBorder(),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => AddGastos(info: widget.info)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
          ],),
      ),]
      ),
    );
  }

  Widget stateBody() {
    Conn.isInternet().then((value) {
      setState(() {
        conexion = value;
        loading = value;
      });
    });
    if (!conexion) {
      userList().then((resp){
        setState(() {
          localload = !resp;
        });
      });
      if (localload){
        return Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width));
      }else{
        return _body(bodylist);
      }

    }
    if(loading){
      return Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width));
    }
    return emptyGastos;
  }

  void _changeItemView() {
    setState(() {
      if (itemQuantity == 1) {
        itemQuantity = 2;
      } else if (itemQuantity == 2) {
        itemQuantity = 3;
      } else {
        itemQuantity = 1;
      }
    });
  }

  TextStyle textSize(){
    return itemQuantity == 1 ? TEXT_LARGE : itemQuantity == 2 ? TEXT_MEDIUM : TEXT_MINI;
  }
  TextStyle titleSize(){
    return itemQuantity == 1 ? TEXT_LARGE_BOLD : itemQuantity == 2 ? TEXT_MEDIUM_BOLD : TEXT_SMALL_BOLD;
  }

  List<Map<String, dynamic>> obtenerSemanasAnio(int anio) {
    DateTime primerDia = DateTime(anio, 1, 1);
    DateTime primerSabado = primerDia.add(Duration(days: (6 - primerDia.weekday) % 7));

    List<Map<String, dynamic>> semanas = [];
    DateTime inicioSemana = primerSabado.subtract(Duration(days: 7));

    while (inicioSemana.year <= anio) {
      DateTime finSemana = inicioSemana.add(Duration(days: 6));
      semanas.add({
        'inicio': inicioSemana,
        'fin': finSemana,
        'numero': numeroSemana,
      });
      inicioSemana = finSemana.add(Duration(days: 1));
      numeroSemana++;
    }

    return semanas;
  }

  Widget _selectWeek(BuildContext context) {
    bool color = true;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(child: Container(height: MediaQuery.sizeOf(context).height*.15, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<Map<String, dynamic>>(
            value: semanaSeleccionada,
            onChanged: (Map<String, dynamic>? nuevaSemana) {
              showAlertSelectDialog(
                context,
                'Confirmar fechas',
                content: 'Seguro que desea seleccionar la semana ${nuevaSemana!['numero']}\nDel ${nuevaSemana['inicio'].toString().substring(0, 10)} al ${nuevaSemana['fin'].toString().substring(0, 10)}',
              ).then((value) {
                if (value == true) {
                  setState(() {
                    loading = true;
                    waiting = true;
                    semanaSeleccionada = nuevaSemana;
                    startDate = nuevaSemana['inicio'];
                    endDate = nuevaSemana['fin'];
                    numeroSemana = nuevaSemana['numero'];
                    setGastos(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
                  });
                  Navigator.pop(context);
                }
              });
            },
            items: semanas!.map((semana) {
              color = !color;
              String inicioStr = semana['inicio'].toString().substring(0, 10);
              String finStr = semana['fin'].toString().substring(0, 10);
              int numeroSemana = semana['numero'];
              return DropdownMenuItem<Map<String, dynamic>>(
                value: semana,
                child: Container(
                  decoration: BoxDecoration(
                    color: semanaSeleccionada == semana ? Colors.white : (color ? Colors.blue[100] : Colors.grey[300]),
                    //border: Border.all(color: Colors.black12), // Borde
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Semana $numeroSemana:', style: TEXT_MEDIUM_BOLD),
                      Text('$inicioStr - $finStr', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
            // Establece la altura máxima del menú desplegable
            dropdownColor: Colors.white,
            isExpanded: true,
            menuMaxHeight: MediaQuery.sizeOf(context).height*.5, // Altura máxima del menú desplegable
          ),
          SizedBox(height: 20),
          if (startDate != null && endDate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha de inicio: ${startDate.toString().substring(0, 10)}', style: TEXT_MEDIUM),
                Text('Fecha de fin: ${endDate.toString().substring(0, 10)}', style: TEXT_MEDIUM),
              ],
            ),
        ],
      ),),),
    );
  }
  Map<String, dynamic>? obtenerSemanaActual() {

    DateTime hoy = DateTime.now();//.add(Duration(days: -1));
    for (var semana in semanas!) {
      if ((hoy.isAfter(semana['inicio']) && hoy.isBefore(semana['fin'])) || hoy.toString().substring(0, 10) == semana['inicio'].toString().substring(0, 10) || hoy.toString().substring(0, 10) == semana['fin'].toString().substring(0, 10)) {
        return semana;
      }
    }
    return null;
  }
}