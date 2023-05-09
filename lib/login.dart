
import 'package:choferes/request.dart';
import 'package:flutter/material.dart';

import 'DBlocal/consultas.dart';
import 'conexion/conn.dart';
import 'conexion/urls.dart';
import 'controller/Usuario.dart';
import 'funciones/alertas.dart';
import 'funciones/sesiones.dart';

class Login extends StatefulWidget {
  final Future<String> load;
  Login({Key? key, required this.load}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController? usrCtr;
  TextEditingController? pssCtr;
  int hasSession = 0;

  Future<String?> isInteret()async{
    await Conn.isInternet().then((connection){
      if (connection) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              children: <Widget>[
                Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                Text("       Conectado a Internet")
              ]
          ),
        ),
        );
        print("Conectado a Internet");
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              children: <Widget>[
               Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                ),
                Expanded (child: Text("     En este momento no tienes conexión a Internet"))
              ]
          ),
        ),
        );
        print("No tienes conexión a Internet");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    isInteret();
    Conn.isInternet().then((connection){
      this.widget.load.then((res) {
        setState(() {
          hasSession = res == '' ? -1 : 1;
        });
        if (res != '') {
          print('res: ' + res);

          if (connection) {
            loadSessionReq(res.toString()).then((value) {
              print("value: " + value.toString());
              if (value != null) {
                verifyUser(value, context, saveSession: true);
              }
              else
                setState(() {
                  hasSession = -1;
                });
            });

          }else{
            Controllerconsulta().queryDataLogin().then((value) {
              //convertir la lista a mapa
              Map? map = value!.asMap();

              if(value!=null || value != ''){
                verifyUser(map[0], context, saveSession: true);
              }
              else setState(() {
                hasSession = -1;
              });
            });
          }
        }
      });
    });

    usrCtr = TextEditingController();
    pssCtr = TextEditingController();
  }

  @override
  void dispose() {
    usrCtr?.dispose();
    pssCtr?.dispose();
    super.dispose();
  }

  Widget logIn(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 100,
            padding: const EdgeInsets.only(top:40, bottom: 15.0),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              height: 360,
              width: 300,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0, right: 15, left: 15),
                    child: Column(
                        children: <Widget>[
                          Container(
                              width: 220,
                              padding: const EdgeInsets.only(bottom: 20.0),
                             // child: Image.network(SERVER_URL+'/test/logo/vtiger-crm-logo.png',)
                            child: Image.asset('assets/logo_tesa.png')
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Usuario',
                              style: TextStyle(
                                fontSize: 19,
                                color: Color(0xFF37474F),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: usrCtr,
                            autocorrect: false,
                            validator: (value){
                              if(value==''){
                                return 'Se requiere ingresar su usuario';
                              }
                              return null;
                            },
                          ),
                          Container(
                            width: 250,
                            padding: const EdgeInsets.only(bottom: 15.0),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Contraseña',
                              style: TextStyle(
                                fontSize: 19,
                                color: Color(0xFF37474F),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: pssCtr,
                            obscureText: true,
                            autocorrect: false,
                            maxLength: 20,
                            validator: (value){
                              if(value==''){
                                return 'Se requiere ingresar su contraseña';
                              }
                              return null;
                            },
                          ),
                          ///Iniciar Sesion Boton
                          ButtonTheme(
                            //alignment: Alignment.topCenter,
                            minWidth: 230,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text('Ingresar', style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  print("hola vanessa: " +usrCtr!.text +' '+ pssCtr!.text);
                                  loginReq(usrCtr!.text, pssCtr!.text).then((onValue) async {
                                    if (onValue!=null) {

                                      print('onValue'+ onValue.toString());

                                      //guardar los datos en una base de datos local para que despues podamos entrar sin conexion
                                      Usuario usuario = Usuario(id: onValue.id, nombres: onValue.nombres.toString(), telefono: onValue.telefono.toString());
                                      await Controllerconsulta().addDataLogin(usuario).then((value){

                                        if (value>0) {
                                          print("correcto");
                                        }else{
                                          print("fallo");
                                        }
                                      });

                                      verifyUser(onValue, context);

                                    } else {
                                      showAlertDialog(context, 'Error', 'Usuario o contraseña erroneos');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BackgroundImage(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
         // image: NetworkImage(SERVER_URL+'/layouts/vlayout/skins/softed/images/pattern.png'),
          image: AssetImage('assets/personal.jpg'),
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _session() => hasSession!=-1?Center(child: loadingUser):Text('');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
            backgroundColor: Colors.transparent,
            body:ListView(
                children: <Widget>[
                  logIn(),
                  _session()
                ]
            )
        ),
      ],
    );
  }
}

