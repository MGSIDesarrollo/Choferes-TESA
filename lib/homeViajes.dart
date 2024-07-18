import 'package:choferes/AddViajes.dart';
import 'package:choferes/controller/Usuario.dart';
import 'package:choferes/funciones/alertas.dart';
import 'package:choferes/request.dart';
import 'package:choferes/viajes/controllerDetailsV.dart';
import 'package:choferes/viajes/controllerViajes.dart';
import 'package:choferes/viajesDetails.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'funciones/colores.dart';
import 'funciones/loopAnimation.dart';
import 'funciones/sesiones.dart';
import 'funciones/widgets.dart';

class HomeViajes extends StatefulWidget {
  //String id;
  final Usuario info;
  static const routeName = '/HomeViajes';
  HomeViajes({Key? key, required this.info}) : super(key: key);

  @override
  _HomeViajesState createState() => _HomeViajesState();
}


class _HomeViajesState extends State<HomeViajes> with SingleTickerProviderStateMixin{

  List? list;
  int itemQuantity = 3;
  Future userList()async{
    bodylist = await Controllerconsulta().queryDataTravel();
    print('Bodylist outconection '+bodylist.toString());
    setState(() {loading=false;});
  }

  List? list2;
  List bodylist = [];
  bool loading = true, conexion = false, loading2 = true, waiting= true;
  late MyLoopAnimation _loopAnimation;

  Future userList2(String id) async {
    list2 = await Controllerconsulta().queryDataDetails(id.toString());
    setState(() {loading2=false;});
    print(list2);
  }

  @override
  void initState(){
    super.initState();
    setViajes();
    userList();
    _loopAnimation = MyLoopAnimation(this);
    Conn.isInternet().then((value) {setState(() {
      conexion = value;
    });});
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
                setViajes();
              });}),
          ),
          IconButton(
            icon: Icon(itemQuantity == 1 ? Icons.grid_view : itemQuantity == 2 ? Icons.grid_on_sharp : Icons.view_list),
            onPressed: _changeItemView,
          ),
        ],
      ),
      body: waiting ? stateBody() : _body(bodylist),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add, color: LIGHT),
        backgroundColor: DARK_BLUE_COLOR,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddViajes(info: widget.info)));
        },
      ),
    );
  }

  Widget _body(data){
    return data.isEmpty? emptyViajes : GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemQuantity,
        childAspectRatio: itemQuantity == 1 ? 3.0 : 1.0,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          borderOnForeground: true,
          elevation: 4,
          child: Container(
            decoration: DECORATION_BLUE_GRADIENT,
            child: ListTile(
                title: Text('Ruta: ${data[index]['ruta_id']}', style: titleSize(), maxLines: 3, overflow: TextOverflow.ellipsis),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fecha inicio:  ${data[index]['fecha']}", maxLines: 2, overflow: TextOverflow.ellipsis, style: textSize(),),
                      Text("Hora inicio:  ${data[index]['hora_prev']}", maxLines: 2, overflow: TextOverflow.ellipsis, style: textSize(),),
                    ]),
                onTap:() async{
                  /*if (conexion){
                    getviajeDetails(widget.info.id.toString(), data[index]['viajesid']).then((value){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                          detalles:value,
                          info: widget.info
                      )));
                    });
                  }else {*/
                    print('Id de consulta '+data[index].toString());
                      await userList2(data[index]['viajesid']);
                      list2 == null ? showToast(context, 'Espere unos segundos y vuelva a intentarlo',) :
                      (list2![0].kil_fin == '') ? Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                          detalles:list2?[0],
                          info: widget.info
                      ))) : showToast(context, 'Este viaje ya ha sido finalizado');
                  //}
                }
            ),
            // ],
          ),
        );
      },
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
                title: Text('Ruta: ${data[index]['ruta_id']}',
                    style:   TextStyle(fontWeight: FontWeight.bold,  fontSize: 17.0)),
                subtitle: Text(
                  "Fecha inicio previsto:  ${data[index]['fecha']}\nHora inicio previsto:  ${data[index]['hora_prev']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onTap:()async {
                  //print ('presionaste el viaje numero1:' + data[index]['viajesid']);
                  await userList2(data[index]['viajesid']);
                  list2 == null ? showToast(context, 'Espere unos segundos y vuelva a intentarlo',) :
                  (list2![0].kil_fin == '') ? Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => viajesDetails(
                      detalles:list2?[0],
                      info: widget.info
                  ))) : showToast(context, 'Este viaje ya ha sido finalizado');
                  //print(data[index]['viajesid']);
                  //print(list2?[0]);
                }
            ),
            // ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  setViajes() async {
    /*await getViajes(widget.info.id.toString()).then((value) {
      setState(() {
        bodylist = value ?? [];
        waiting = false;
        loading = false;
        if (value != null && value != []){
          for (var i = 0; i < value.length; i++) {
            Controllerconsulta().queryCountTravel(
                value[i]['viajesid'].toString()).then((val) {
              if (val > 0) {} else {
                Viaje viaje = Viaje(
                    viajesid: value[i]['viajesid'].toString(),
                    viaje_id: value[i]['viaje_id'].toString(),
                    fecha: value[i]['fecha'].toString(),
                    hora_prev: value[i]['hora_prev'].toString(),
                    vehiculo_id: value[i]['vehiculo_id'].toString(),
                    ruta_id: value[i]['ruta_id'].toString(),
                    accountname: value[i]['accountname'].toString());
                Controllerconsulta().addDataTravel(viaje).then((resp) {
                  if (resp > 0) {
                    getviajeDetails(widget.info.id.toString(),
                        value[i]['viajesid'].toString()).then((value2) {
                      ViajeD viajeD = ViajeD(
                          viajesid: value2!.viajesid,
                          viaje_id: value2.viaje_id,
                          nombre_ruta: value2.nombre_ruta,
                          fecha: value2.fecha,
                          hora_prev: value2.hora_prev,
                          vehiculo_id: value2.vehiculo_id,
                          ruta_id: value2.ruta_id,
                          cliente: value2.cliente,
                          comentario: value2.comentario,
                          centro: value2.centro,
                          horario_inicio: value2.horario_inicio,
                          horario_final: value2.horario_final,
                          kil_ini: value2.kil_ini,
                          kil_fin: value2.kil_fin,
                          vehiculosid: value2.vehiculosid,
                          idcliente: value2.idcliente,
                          tipo: value2.tipo
                      );

                      Controllerconsulta().addDataDetails(viajeD).then((
                          value) {});
                    });
                  } else {
                    print('fallo la insercion del viaje');
                  }
                });
              }
            });
          }
        }
      });
    });*/
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

  Widget stateBody() {
    Conn.isInternet().then((value) {
      setState(() {
        conexion = value;
        loading = value;
      });
    });
    if (!conexion) {
      return _body(bodylist);
    }
    if(loading){
      return _body(bodylist); Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width));
    }
    return emptyViajes;
  }
}