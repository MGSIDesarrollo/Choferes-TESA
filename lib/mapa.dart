import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../funciones/colores.dart';
import '../funciones/loopAnimation.dart';
import '../funciones/widgets.dart';

class Mapa extends StatefulWidget {
  Mapa({Key? key,}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> with SingleTickerProviderStateMixin{

  var controller;
  late MyLoopAnimation _loopAnimation;

  @override
  void initState() {
    super.initState();
    _loopAnimation = MyLoopAnimation(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: LIGHT,
          title: Text('Gasolineras'),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child:/* ruta == null ? Center(child: progressWidget(_loopAnimation, MediaQuery.of(context).size.width)) : */html(),
        )
    );
  }

  Widget html(){
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )..loadRequest(Uri.parse('https://www.google.com/maps/d/viewer?mid=1GCqGVkb4ETqH6w-WXFpNO3kYPUOlpQs&ll=20.686387195806063%2C-103.34730875517403&z=12'));
    return WebViewWidget(controller: controller);
  }
}