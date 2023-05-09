/*
Developed by: Vanessa Garcia - 2022
 */
class Vehiculo {
  String? id_vehiculo;
  String? vehiculo;
  String? tipovehiculo;
  String? num_serie;
  String? vehiculosid;

  Vehiculo({
    this.id_vehiculo,
    this.vehiculo,
    this.tipovehiculo,
    this.num_serie,
    this.vehiculosid,
  });

  /// Tranforms JSON to [Vehiculo]
  factory Vehiculo.fromJSON(Map<String, dynamic> json) => Vehiculo(
    id_vehiculo: json["id_vehiculo"],
    vehiculo: json["vehiculo"],
    tipovehiculo: json["tipovehiculo"],
    num_serie: json["num_serie"],
    vehiculosid: json["vehiculosid"],
  );

  /// Returns a string whit basic person info.
  @override
  String toString() {
    return 'id_vehiculo: $id_vehiculo, vehiculo: $vehiculo, tipovehiculo: $tipovehiculo, num_serie: $num_serie, vehiculosid: $vehiculosid';
  }

  Map<String, dynamic> toJSON()=>{
    'id_vehiculo': id_vehiculo,
    'vehiculo': vehiculo,
    'tipovehiculo': tipovehiculo,
    'num_serie': num_serie,
    'vehiculosid': vehiculosid,
  };

}