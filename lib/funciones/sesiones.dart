/*
Developed by: Vanessa Garcia - 2022
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../controller/Usuario.dart';

void verifyUser(Usuario usr, context,  {bool saveSession = false}) {

  Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
          (Route<dynamic> route) => false,
      arguments: {
        'datos': usr,
        'save': saveSession
      }
  );
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
        child: Text('Comprobando si hay una sesión'),
      )
    ]
);

Widget progressWidget = Center(
    child: Column(
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Cargando datos...'),
          )
        ]
    )
);

Widget emptyResponse = Center(
    child: Container(
        margin: EdgeInsets.only(top: 5.0, left:3.0, right:9.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF81D4FA),
        ),
        height: 100.0,
        width: 200.0,
        alignment: Alignment.center,
        child:Text('Nada que mostrar', style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,)
    )
);