import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../DBlocal/consultas.dart';
import '../controller/Usuario.dart';
import '../selectVehiculo.dart';
import 'colores.dart';


void verifyUser(Usuario usr, context,  {bool saveSession = false}) {
  print('verifyuser '+usr.toString());
  Controllerconsulta().queryDataLogin().then((value) {
    if(value!.vehiculo == '' || value.vehiculo == '0'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectVehiculo(info: value, mostrarAppBar: true,)),);
    }else{
      Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false,
          arguments: {'datos': usr, 'save': saveSession } );
    }
  });
}

void closeSession() async {
  var directory = await getApplicationDocumentsDirectory();
  var path = directory.path;
  File session = File('$path/gIAU');
  session.writeAsString('');
}

void saveSessionFunct( String hash) async {

  var directory = await getApplicationDocumentsDirectory();
  var path = directory.path;

  File session = File('$path/gIAU');
  session.writeAsString(hash);
}

Future<String> loadSession() async {
  print('Load session!');
  var directory = await getApplicationDocumentsDirectory();
  var path = directory.path;

  try {
    File session = File('$path/gIAU');
    String contents = await session.readAsString();
    return contents;
  } catch (e) {
    print('Exception here: $e');
    return '';
  }
}


Widget loadingUser = Column(
    children: <Widget>[
      SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Comprobando si hay una sesión', style: TEXT_BUTTON_STYLE,),
      )
    ]
);
