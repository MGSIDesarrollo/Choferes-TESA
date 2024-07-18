import 'package:flutter/material.dart';

import 'funciones/colores.dart';
import 'funciones/sesiones.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(choferes());
}

class choferes extends StatelessWidget {
  const choferes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choferes TESA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PTSerif',
        primaryColor: inteco,
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(
          buttonColor: LIGHT_BLUE_COLOR,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(load: loadSession()),
         '/home':(context) => Home(),
      },
    );
  }
}

