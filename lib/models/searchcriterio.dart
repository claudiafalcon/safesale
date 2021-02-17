import 'dart:ffi';

import 'package:safesale/models/media.dart';
import 'package:safesale/models/location.dart';

class SearchCriterio {
  String criteria;
  String amenidades;
  int baths;
  int construccionm2;
  int terrenom2;
  int estacionamientos;
  int preciofrom;
  int precioto;
  int recamaras;
  String tipo;

  SearchCriterio();

  Map toJson() {
    var json = new Map();
    json['searchCriteria'] = this.criteria;
    if (this.amenidades != null) json['amenidades'] = this.amenidades;
    if (this.baths != null) json['baths'] = this.baths;
    if (this.construccionm2 != null)
      json['construccion_m2'] = this.construccionm2;
    if (this.terrenom2 != null) json['terreno_m2'] = this.terrenom2;
    if (this.estacionamientos != null)
      json['estacionamientos'] = this.estacionamientos;
    if (this.preciofrom != null) json['precio_from'] = this.preciofrom;
    if (this.precioto != null) json['precio_to'] = this.precioto;
    if (this.recamaras != null) json['recamaras'] = this.recamaras;
    if (this.tipo != null) json['tipo'] = this.tipo;
    return json;
  }

  String toGrapql() {
    var query = StringBuffer();

    if (this.amenidades != null)
      query.write('amenidades:"' + this.amenidades + '",');
    if (this.baths != null) {
      query.write('baths:');
      query.write(this.baths);
      query.write(',');
    }
    if (this.construccionm2 != null) {
      query.write('construccion_m2:');
      query.write(this.construccionm2);
      query.write(',');
    }

    if (this.terrenom2 != null) {
      query.write('terreno_m2:');
      query.write(this.terrenom2);
      query.write(',');
    }
    if (this.estacionamientos != null) {
      query.write('estacionamientos:');
      query.write(this.estacionamientos);
      query.write(',');
    }

    if (this.preciofrom != null) {
      query.write('precio_from:');
      query.write(this.preciofrom);
      query.write(',');
    }

    if (this.precioto != null) {
      query.write('precio_to:');
      query.write(this.precioto);
      query.write(',');
    }

    if (this.recamaras != null) {
      query.write('recamaras:');
      query.write(this.recamaras);
      query.write(',');
    }

    if (this.tipo != null) query.write('tipo:"' + this.tipo + '",');

    query.write('searchCriteria:"' + this.criteria + '"');
    return query.toString();
  }
}
