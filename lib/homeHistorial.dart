import 'package:choferes/request.dart';
import 'package:choferes/viajesDetails.dart';

import 'package:flutter/material.dart';

import 'conexion/conn.dart';
import 'controller/Usuario.dart';
import 'funciones/alertas.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/widgets.dart';

class HomeHistorial extends StatefulWidget {
  //String id;
  final Usuario info;
  static const routeName = '/HomeHistorial';
  HomeHistorial({Key? key, required this.info}) : super(key: key);

  @override
  _HomeHistorialState createState() => _HomeHistorialState();
}


class _HomeHistorialState extends State<HomeHistorial> with SingleTickerProviderStateMixin{

  bool loading = true, waiting = true, conexion = false, msj = false;
  DateTime? startDate, endDate, sd, ed;
  late MyLoopAnimation _loopAnimation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  List bodylist = [];
  String start = 'Fecha inicial', end = 'Fecha final';
  int anio = DateTime.now().year; // Puedes cambiar el año aquí
  int numeroSemana = 1;
  List<Map<String, dynamic>>? semanas;
  Map<String, dynamic>? semanaSeleccionada;

  @override
  void initState(){
    super.initState();
    semanas = obtenerSemanasAnio(anio);
    if (semanas!.isNotEmpty) {
      semanaSeleccionada = obtenerSemanaActual();
      print(semanaSeleccionada.toString());
      startDate = semanaSeleccionada?['inicio'] ?? DateTime.now();
      endDate = semanaSeleccionada?['fin'] ?? DateTime.now();
      setHistory(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
    }
    _loopAnimation = MyLoopAnimation(this);
  }

  Widget _body(List data){
    return data.isEmpty ? emptyHistorial : ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(3),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        msj = false;
        return Card(
          color: Colors.white,
          borderOnForeground: true,
          elevation: 4,
          child: Container(
            margin: EdgeInsets.only(top: 4.0, left:3.0, bottom: 4.0),
            //children: <Widget>[
            child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text('Ruta: ${data[index]['ruta_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Fecha inicio previsto:  ${data[index]['fecha']}\nHora inicio previsto:  ${data[index]['hora_prev']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap:(){
                  getviajeDetails(widget.info.id.toString(), data[index]['viajesid']).then((value){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                        viajesDetails(detalles:value, info: widget.info)));
                    //print(value);
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

  setHistory(String fInicial, String fFinal) async {
    bool conn = await Conn.isInternet();
    if (conn){
      getHistorial(context, widget.info.id.toString(), fInicial, fFinal, msj).then((value) {
            setState(() {
              bodylist = value ?? [];
              waiting = false;
              loading = false;
            });

      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        key: _navigatorKey,
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: ((){
                setState(() {
                  loading = true;
                  waiting = true;
                  startDate = semanaSeleccionada!['inicio'];
                  endDate = semanaSeleccionada!['fin'];
                  setHistory(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
                });}),
            ),],
          backgroundColor: DARK_BLUE_COLOR,
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
                  ],),
                ),
              ]),),
            Expanded(child: waiting ? stateBody() : _body(bodylist),),
          ]),
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
        return outConection;
      }
      if(loading){
        return Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width));
      }
      return emptyHistorial;
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
                      setHistory(startDate.toString().substring(0, 10), endDate.toString().substring(0, 10));
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
