/*class Vehiculo {
  String? crmid;
  String? id;
  String? nombre; //vehiculos_id
  String? propietario;
  String? codigo_tipo;
  String? tipo;
  String? marca;
  String? modelo;
  String? num_serie;
  String? num_motor;
  String? poliza;
  String? com_poliza;
  String? vigencia;
  String? placas_est;
  String? placas_fed;
  String? kilometraje;

  Vehiculo({
    required this.crmid,
    required this.id,
    required this.nombre,
    required this.propietario,
    required this.codigo_tipo,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.num_serie,
    required this.num_motor,
    required this.poliza,
    required this.com_poliza,
    required this.vigencia,
    required this.placas_est,
    required this.placas_fed,
    required this.kilometraje,

  });

  /// Tranforms JSON to [Usuario]
  Vehiculo.fromJSON (Map jsonData) {
     crmid = jsonData['crmid'] ?? '';
     id = jsonData['id'] ?? '';
     nombre = jsonData['nombre'] ?? '';
     propietario = jsonData['propietario'] ?? '';
     codigo_tipo = jsonData['codigo_tipo'] ?? '';
     tipo = jsonData['tipo'] ?? '';
     marca = jsonData['marca'] ?? '';
     modelo = jsonData['modelo'] ?? '';
     num_serie = jsonData['num_serie'] ?? '';
     num_motor = jsonData['num_motor'] ?? '';
     poliza = jsonData['poliza'] ?? '';
     com_poliza = jsonData['com_poliza'] ?? '';
     vigencia = jsonData['vigencia'] ?? '';
     placas_est = jsonData['placas_est'] ?? '';
     placas_fed = jsonData['placas_fed'] ?? '';
     kilometraje = jsonData['kilometraje'] ?? '';
  }


  /// Returns a string whit basic person info.
  @override
  String toString() {
    return 'crmid: $crmid, '
        'id: $id, '
        'nombre: $nombre, '
        'propietario: $propietario, '
        'codigo_tipo: $codigo_tipo, '
        'tipo: $tipo, '
        'marca: $marca, '
        'modelo: $modelo, '
        'num_serie: $num_serie, '
        'num_motor: $num_motor, '
        'poliza: $poliza, '
        'com_poliza: $com_poliza, '
        'vigencia: $vigencia, '
        'placas_est: $placas_est, '
        'placas_fed: $placas_fed, '
        'kilometraje: $kilometraje, ';
  }

  Map<String, dynamic> toJSON()=>{
    'crmid': crmid,
    'id': id,
    'nombre': nombre,
    'propietario': propietario,
    'codigo_tipo': codigo_tipo,
    'tipo': tipo,
    'marca': marca,
    'modelo': modelo,
    'num_serie': num_serie,
    'num_motor': num_motor,
    'poliza': poliza,
    'com_poliza': com_poliza,
    'vigencia': vigencia,
    'placas_est': placas_est,
    'placas_fed': placas_fed,
    'kilometraje': kilometraje,
  };
}*/