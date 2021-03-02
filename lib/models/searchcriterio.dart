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
  SearchCriterio.fill(
      {this.criteria,
      this.amenidades,
      this.baths,
      this.construccionm2,
      this.terrenom2,
      this.estacionamientos,
      this.preciofrom,
      this.precioto,
      this.recamaras,
      this.tipo});

  factory SearchCriterio.fromJson(Map<String, dynamic> data) {
    return SearchCriterio.fill(
      criteria: data["searchCriteria"] == null
          ? ""
          : data["searchCriteria"] as String,
      amenidades:
          data["amenidades"] == null ? null : data["amenidades"] as String,
      baths: data["baths"] == null ? null : data["baths"] as int,
      construccionm2: data["construccion_m2"] == null
          ? null
          : data["construccion_m2"] as int,
      terrenom2: data["terreno_m2"] == null ? null : data["terreno_m2"] as int,
      estacionamientos: data["estacionamientos"] == null
          ? null
          : data["estacionamientos"] as int,
      preciofrom:
          data["precio_from"] == null ? null : data["precio_from"] as int,
      precioto: data["precio_to"] == null ? null : data["precio_to"] as int,
      recamaras: data["recamaras"] == null ? null : data["recamaras"] as int,
      tipo: data["tipo"] == null ? null : data["tipo"] as String,
    );
  }

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
