import 'package:flutter/material.dart';

import 'funciones/colores.dart';

class gastosDetails extends StatefulWidget {
  //final Detalles detalles;
  final detalles;
  String id_user;
  static const routeName = '/gastosDetails';
  gastosDetails({Key? key, this.detalles, required this.id_user}) : super(key: key);

  @override
  _gastosDetailsPageState createState() => _gastosDetailsPageState();
}

class _gastosDetailsPageState extends State<gastosDetails> {

  @override
  void initState(){
    super.initState();
  }

  Widget _body(){
    //print('vinfo: '+ _arguments!['vinfo'].toString());
      return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
            child: Card(
              color: Colors.white,
              borderOnForeground: true,
              elevation: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 6,),
                  titulo('Información general'),
                  Divider(color: Colors.black, indent: 15, endIndent: 15,),
                  //_rowText('ID: ', '${widget.detalles.gasto_id.toString()}'),
                  _rowText('Vehiculo: ', '${widget.detalles.vehiculo_id.toString()}'),
                  _rowText('Proveedor: ', '${widget.detalles.proveedor.toString()}'),
                  _rowText('Concepto: ', '${widget.detalles.concepto.toString()}'),
                  _rowText('Fecha de carga:', '${widget.detalles.fecha_gasto.toString()}'),
                  _rowText('Hora de carga:', '${widget.detalles.hora.toString()}'),
                  _rowText('Folio:', '${widget.detalles.folio.toString()}'),
                  _observaciones('Comentarios:   ', widget.detalles.comentario.toString()),
                  SizedBox(height: 15,),
                  titulo('Información detallada'),
                  Divider(color: Colors.black, indent: 15, endIndent: 15,),
                  _rowText('Pago: ', '${widget.detalles.tipo_pago.toString()}'),
                  _rowText('Costo: ', '\$${widget.detalles.costo.toString()}'),
                  _rowText('Precio por litro: ', '${widget.detalles.precio_litro.toString()}'),
                  _rowText('Litros: ', '${widget.detalles.litros.toString()}'),
                  _rowText('Rendimiento: ', '${widget.detalles.rendimiento.toString()}'),
                  //_rowText('Recorrido:', '${widget.detalles.recorrido.toString()}'),
                  _rowText('Precio por kilometro:', '\$${widget.detalles.pxk.toString()}'),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget _rowText(String first, String second) => Padding(
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

  Widget _observaciones(String first, String second) => Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4, top: 6),
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

  Widget titulo(String first) => Padding(
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

  @override
  Widget build(BuildContext context) {
    //_arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // print('id: ' + _arguments!['id_user'].toString());
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
        ),
        body: _body()
    );
  }

}