import 'package:animate_do/animate_do.dart';
import 'package:choferes/gastos/controllerGastoDetails.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:choferes/viajesDetails.dart';

import 'package:flutter/material.dart';

import 'AddGastos.dart';
import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'controller/Usuario.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/sesiones.dart';
import 'funciones/widgets.dart';
import 'gastos/controllerGastos.dart';
import 'gastosDetails.dart';


class Estadisticas extends StatefulWidget {
  //String id;
  final Usuario info;
  static const routeName = '/Estadisticas';
  Estadisticas({Key? key, required this.info}) : super(key: key);

  @override
  _EstadisticasState createState() => _EstadisticasState();
}


class _EstadisticasState extends State<Estadisticas> with SingleTickerProviderStateMixin{

  List? list;
  int anio = DateTime.now().year;
  int numeroSemana = 1;
  List bodylist = [];
  List<Map<String, dynamic>>? semanas;
  Map<String, dynamic>? semanaSeleccionada;
  bool loading = true, conexion = false, loading2 = true, waiting= true;

  DateTime? startDate, endDate, sd, ed;
  late MyLoopAnimation _loopAnimation;

  List? list2;
  String start = 'Fecha inicial', end = 'Fecha final', totalViajes = '...', hrsTrabajadas = '...';
  bool msj = false;

  @override
  void initState(){
    super.initState();
    semanas = obtenerSemanasAnio(anio);
    if (semanas!.isNotEmpty) {
      semanaSeleccionada = obtenerSemanaActual();
      print(semanaSeleccionada.toString());
      startDate = semanaSeleccionada?['inicio'] ?? DateTime.now();
      endDate = semanaSeleccionada?['fin'] ?? DateTime.now();
      setEstadis(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
    }
    _loopAnimation = MyLoopAnimation(this);
  }

  Widget _body(data){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 25),
      color: Colors.white,
      borderOnForeground: true,
      elevation: 4,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        //children: <Widget>[
        child: Row(children: [
          Expanded(child: Column(children: [
            Text('Viajes totales: ', textAlign: TextAlign.center, style: TEXT_LABEL_STYLE,),
            Container(height: 100, width: 100, child: Card(child: Center(child: Text(totalViajes, style: TEXT_XXXLARGE,))),),
          ],),),
          Expanded(child: Column(children: [
            Text('Horas trabajadas: ', textAlign: TextAlign.center, style: TEXT_LABEL_STYLE,),
            Container(height: 100, width: 100, child: Card(child: Center(child: Text(hrsTrabajadas, style: TEXT_XXXLARGE,))),),
          ],),),
        ],)
        // ],
      ),
    );
  }


  setEstadis(String fInicial, String fFinal) async {
    bool conn = await Conn.isInternet();
    if (conn){
      getEstadisticas(context, widget.info.id.toString(), fInicial, fFinal).then((value) {
        setState(() {
          bodylist = value ?? [];
          waiting = false;
          loading = false;
          totalViajes = value?[0]['totales'] ?? '0';
          hrsTrabajadas = value?[0]['trabajadas'] ?? '0';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: DARK_BLUE_COLOR,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ((){
              setState(() {
                loading = true;
                waiting = true;
                startDate = semanaSeleccionada!['inicio'];
                endDate = semanaSeleccionada!['fin'];
                setEstadis(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
              });}),
          ),],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:([
          Center(child: Text('Semana actual: '+obtenerSemanaActual()!['numero'].toString(), style: TEXT_LARGE_LABEL_STYLE, textAlign: TextAlign.center,),),
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
            ]),),
          Expanded(child: waiting ? stateBody() : _body(bodylist),),
        ]),
      ),
    );
  }

  Widget _selectWeek(BuildContext context) {
    bool color = true;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                    setEstadis(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
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
                Text('Fecha de inicio: ${startDate.toString().substring(0, 10)}'),
                Text('Fecha de fin: ${endDate.toString().substring(0, 10)}'),
              ],
            ),
        ],
      ),
    );
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

  Map<String, dynamic>? obtenerSemanaActual() {

    DateTime hoy = DateTime.now();//.add(Duration(days: -1));
    for (var semana in semanas!) {
      if ((hoy.isAfter(semana['inicio']) && hoy.isBefore(semana['fin'])) || hoy.toString().substring(0, 10) == semana['inicio'].toString().substring(0, 10) || hoy.toString().substring(0, 10) == semana['fin'].toString().substring(0, 10)) {
        return semana;
      }
    }
    return null;
  }

  Widget stateBody() {
    Conn.isInternet().then((value) {
      setState(() {
        conexion = value;
        loading = value;
      });
    });
    if (!conexion) {
      return outConection;
    }
    if(loading){
      return Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width));
    }
    return emptyHistorial;
  }
}
