/*
Developed by: Vanessa Garcia - 2022
 */

class Usuario {
  String? nombres;
  String? telefono;
  int? id;

  Usuario({
    required this.nombres,
    required this.telefono,
    required this.id,

  });

  /// Tranforms JSON to [Usuario]
  Usuario.fromJSON (Map jsonData) {
    nombres = jsonData['lastname']??'';
    telefono = jsonData['mobile']??'';
    var iden = jsonData['contactid'];
    id = iden is int? iden : int.parse(iden);
    //id = jsonData['contactid']??'';

  }


  /// Returns a string whit basic person info.
  @override
  String toString() {
    return 'contactid: $id, mobile: $telefono, lastname: $nombres';
  }

  Map<String, dynamic> toJSON()=>{
   // return {
      'lastname': nombres,
      'mobile': telefono,
      'contactid': id,
    };
  //}

}