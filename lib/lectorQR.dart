import 'package:choferes/request.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'funciones/alertas.dart';
import 'funciones/colores.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRScannerPage(),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController controller = MobileScannerController();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.granted;
  LocationData _locationData = LocationData.fromMap({});
  Location location = new Location();
  bool loading = false;
  bool? mesage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(Barcode barcode, MobileScannerArguments? args) async{
    final String code = barcode.rawValue ?? '---';
    print('QR Code detected: $code');
    setState(() {
      loading = true;
    });
    await checar(code);
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
          backgroundColor: DARK_BLUE_COLOR
      ),
      body: loading ? Stack(children: [Center(child: CircularProgressIndicator(),)],) : MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }

  Future<String?> checar(String code) async{
    await getLocation().then((_){
      registrarChecada(_locationData.latitude.toString(), _locationData.longitude.toString(), code).then((value) {
        print('respuesta de la checada '+value.toString());
        setState(() {
          loading = false;
        });
        if (value != 'Error'){
          showAlertDialog(context, 'Exito', 'Checada registrada con éxito.\n'+value!['nombres']+' '+value!['apellidos']+ ' a bordo.', icono: Icon(null));
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });

        }
        else {
          showAlertDialog(context, 'Error', 'No se pudo realizar la checada.');
        }
      });
    });
  }

  getLocation()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      _locationData = await location.getLocation();
      //print('locacion obtenida '+_locationData.toString());
      //print('Latitud: ${_locationData.latitude}, Longitud: ${_locationData.longitude}');
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }
}