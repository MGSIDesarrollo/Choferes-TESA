import 'package:choferes/viajes/controllerVehiculos.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'controller/Usuario.dart';
import 'funciones/colores.dart';

class ReglamentoOperadores extends StatefulWidget {
  ReglamentoOperadores({Key? key,}) : super(key: key);

  @override
  _ReglamentoOperadoresState createState() => _ReglamentoOperadoresState();
}

class _ReglamentoOperadoresState extends State<ReglamentoOperadores> {
  Vehiculo? vehiculoSel;

  void initState() {
    super.initState();
    Controllerconsulta().queryVehiculoSel().then((value) =>
        setState(() {
          vehiculoSel = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        foregroundColor: LIGHT,
        title: Text('Reglamento'),
        backgroundColor: DARK_BLUE_COLOR,
      ),*/
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
          child: _body(),),
      ]),),
    );
  }

  Widget _body() {
    //print('vinfo: '+ _arguments!['vinfo'].toString());
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 6,),
          titulo('REGLAMENTO PARA OPERADORES DE TRANSPORTE'),
          Divider(color: Colors.black, indent: 15, endIndent: 15,),
          _rowText('1.- ',  '🕒🚍 El operador debe iniciar la ruta conforme al horario del croquis autorizado. \n- No está autorizado realizar paradas que no estén estipuladas de manera oficial. \n- Debe realizar todas las paradas según el croquis de ruta, aunque en estas no suban usuarios.'),
          _rowText('2.- ', '🆔🔍 Al momento de abordar la unidad, el usuario deberá mostrar su gafete de identificación. \n- En caso de no mostrarlo, el operador deberá entregar el formato de “Usuarios sin Identificación” para que lo llene el usuario.'),
          _rowText('3.- ', '📞🚨 El operador deberá informar cualquier eventualidad en el desarrollo de la ruta (riñas entre usuarios se notificarán al departamento de Recursos Humanos).'),
          _rowText('4.- ', '🏭📋 Al llegar a la planta, deberá registrarse en vigilancia.'),
          _rowText('5.- ', '🚪🚌 Al momento de la salida de planta, el operador deberá ubicarse en la puerta de su unidad.'),
          _rowText('6.- ', '🕡📋 Reportarse con el supervisor media hora antes del inicio de la ruta.'),
          _rowText('7.- ', '🔧✔️ Verificación de las condiciones óptimas de la unidad.'),
          _rowText('8.- ', '📄✔️ Verificación de documentación (licencias, pólizas y seguros).'),
          _rowText('9.- ', '👔👖 Código de vestir (uniforme).'),
          _rowText('10.- ', '🧼✂️ Higiene impecable. Todo operador deberá andar aseado, afeitado y con pelo corto; si no, se aplicará sanción.'),
          _rowText('11.- ', '🚭 Prohibido fumar dentro y fuera de las unidades, en los horarios de desarrollo, llegada y salida de los usuarios de las rutas.'),
          _rowText('12.- ', '🚗⚠️ Manejar con cautela y precaución. La velocidad en carretera local es de 60 km/h y en carretera federal 95 km/h.'),
          _rowText('13.- ', '🚗↔️ Debes guardar siempre la distancia necesaria con el vehículo que transita adelante.'),
          _rowText('14.- ', '🕑🚏 Presentarse 10 minutos antes en la parada de inicio que le corresponda.'),
          _rowText('15.- ', '🚍🚫 Las unidades que completen el cupo de personal no efectuarán más paradas, por lo que deberán reportarlo a su supervisor correspondiente.'),
          _rowText('16.- ', '📚🛑 Portar el manual de rutas y respetar las paradas oficiales, aun cuando no se encuentre el personal en ellas, y no realizar paradas que no estén autorizadas.'),
          _rowText('17.- ', '🚫🗣️ Está estrictamente prohibido platicar con el personal a bordo.'),
          _rowText('18.- ', '🚦🚸 Debes respetar las reglas y señalamientos de vialidad.'),
          _rowText('19.- ', '🚫🍺 Por ninguna circunstancia deberá conducir habiendo ingerido bebidas embriagantes ni llevarlas a bordo.'),
          _rowText('20.- ', '🚫📱 Evita distracciones. Por ninguna razón deberás traer acompañantes (parientes, novias, conocidos, etc.) ni usar celular sin manos libres.'),
          _rowText('21.- ', '🪧🚍 No olvidar colocar el letrero de la empresa en la unidad.'),
          _rowText('22.- ', '🤝🚌 Mantén la relación usuario-operador de una manera respetuosa, cordial y servicial.'),
          _rowText('23.- ', '🎵🚫 Queda estrictamente prohibido llevar música en la unidad.'),
          _rowText('24.- ', '🚫↩️ Queda estrictamente prohibido regresar la unidad a las paradas anteriores.'),
          _rowText('25.- ', '🔗💺 Solicitar a los usuarios que se coloquen correctamente el cinturón de seguridad.'),
          _rowText('26.- ', '🛑👫 Al abordar la unidad o al descenso de los usuarios, deberá realizar un alto total hasta que los usuarios estén ubicados en su lugar respectivo.'),
          _rowText('27.- ', '🔍🚍 Revisión de la unidad al llegar a planta (en el intervalo de entrada y salida).'),
          /*Text('\n\n*Nota importante:* Para mayor seguridad y servicio, ayúdanos a respetar el reglamento de transporte. La persona que no cumpla con dicho reglamento será reportada a Recursos Humanos.', textAlign: TextAlign.center, style: TEXT_RULE_STYLE,),
          Text('\nReporta cualquier falta al área de Recursos Humanos.', style: TEXT_RULE_STYLE, textAlign: TextAlign.center),
          Text('\nTransporte Empresarial y Servicios Administrativos S.A. de C.V.', style: TEXT_RULE_STYLE, textAlign: TextAlign.center),
          Text('\nJuanacatlán, Jal. Malecón No.12 int 3 Centro 37 32 27 47', style: TEXT_RULE_STYLE, textAlign: TextAlign.center),*/
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _rowText(String first, String second) => Padding(
    padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Esta es la línea clave
      children: [
        Text(
            '$first',
            style: TEXT_RULE_STYLE
        ),
        Expanded(
          child: Text(
            '$second',
            textAlign: TextAlign.justify,
            style: TEXT_RULE_STYLE,
            softWrap: true,
          ),
        ),
      ],
    ),
  );

  Widget titulo(String first) =>
      Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 2),
        child: Text('$first',
          style: TextStyle(
              fontSize: 19.5,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ), textAlign: TextAlign.center,
        ),
      );
}