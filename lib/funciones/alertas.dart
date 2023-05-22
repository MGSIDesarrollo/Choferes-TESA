/*
 Developer by: Vanessa
*/
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'colores.dart';

/// Procedure that generate an alert, whit an simbol of alert.
showAlertDialog(BuildContext context, String tittle, String message, {final Icon icono = const Icon(Icons.warning, color: Colors.yellow, size: 55.0)}) {
  AlertDialog alert = AlertDialog(
    title: Row(
        children: <Widget>[
          Text(tittle,),
          icono,
        ]
    ),
    content: Text(message, style: TextStyle(
      color: Colors.black,
    )),
  );
  _showDialog(context, alert);
}

showSimpleDialog(
    BuildContext context,
    String tittle,
    String message,
    {final Icon icono = const Icon(Icons.notifications, color: Colors.white, size: 35.0)}
    ) {
  const TextStyle _style = TextStyle(
    color: Colors.white,
  );
  dynamic _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  AlertDialog alert = AlertDialog(
    title: Row(
        children: <Widget>[
          icono,
          Text(tittle,  style: _style),
        ]
    ),
    backgroundColor: DARK_BLUE_COLOR,
    content: Text(message,  style: _style),
    actions: <Widget>[
      ElevatedButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
        //  color: Colors.white,
        // shape: _shape,
      )
    ],
    shape: _shape,
  );
  _showDialog(context, alert);
}

/// Procedure that generate an select Alert.
/// *Note: The [yesAction] function is a [MaterialPageRoute].
showAlertSelectDialog(BuildContext context, Function yesAction, String title, {titleStyle: DANGER_TEXT_STYLE}) {
  AlertDialog alert = AlertDialog(
    title: Row(
        children: <Widget>[
          Expanded(child:Text(title, style: titleStyle, softWrap: true,)),
          Icon(Icons.warning, color: Colors.red, size: 55.0),
        ]
    ),
    actions: <Widget>[
      TextButton(
        child: Text('No'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text('Sí'),
        onPressed: yesAction(),
      ),
    ],
  );
  _showDialog(context, alert);
}


showMessageDialog(BuildContext context, String tittle, String message){
  AlertDialog alert = AlertDialog(
    title: Text(tittle),
    content: Text(message),
    backgroundColor: ALERTA,
  );
  _showDialog(context, alert);
}

/// Procedure for show an Alert.
_showDialog(BuildContext context, var alert){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showToast(BuildContext context, String message, {int duration=2, Color background=Colors.lightBlue, int align=1}){
  ToastContext().init(context);
  Toast.show(message, duration: duration, backgroundColor: background, gravity: align);
}


