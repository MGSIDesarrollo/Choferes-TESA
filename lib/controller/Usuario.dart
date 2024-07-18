class Usuario {
  String? nombres;
  String? telefono;
  int? id;
  String? vehiculo;

  Usuario({
    required this.nombres,
    required this.telefono,
    required this.id,
    required this.vehiculo,
  });

  /// Tranforms JSON to [Usuario]
  Usuario.fromJSON (Map jsonData) {
    nombres = jsonData['lastname']??'';
    telefono = jsonData['mobile']??'';
    var iden = jsonData['contactid'];
    id = iden is int? iden : int.parse(iden);
    vehiculo = jsonData['vehiculo']??'';
  }


  /// Returns a string whit basic person info.
  @override
  String toString() {
    return 'contactid: $id, mobile: $telefono, lastname: $nombres, vehiculo: $vehiculo';
  }

  Map<String, dynamic> toJSON()=>{
   // return {
      'lastname': nombres,
      'mobile': telefono,
      'contactid': id,
      'vehiculo': vehiculo,
    };
  //}

}