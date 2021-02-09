import 'dart:ffi';

import 'package:safesale/models/media.dart';
import 'package:safesale/models/location.dart';

class Property {
  final String id;
  final String nombre;
  final String descripcion;
  final Location location;
  final String status;
  final String tipo;
  final String asesor;
  final Media video;
  final List<Media> gallery;
  final String caracteristicas;
  final int construccionM2;
  final String amenidades;
  final String cp;
  final String createdAt;
  final String direccion;
  final int edad;
  final String entidad;
  final int estacionamientos;
  final int inventario;
  final int wc;
  final int baths;
  final String localidad;
  final String pais;
  final String precio;
  final String propietario;
  final int recamaras;
  final int terrenoM2;
  final String updatedAt;

  Property(
      {this.id,
      this.nombre,
      this.descripcion,
      this.location,
      this.status,
      this.tipo,
      this.asesor,
      this.video,
      this.gallery,
      this.caracteristicas,
      this.construccionM2,
      this.amenidades,
      this.cp,
      this.createdAt,
      this.direccion,
      this.edad,
      this.entidad,
      this.estacionamientos,
      this.inventario,
      this.localidad,
      this.pais,
      this.precio,
      this.propietario,
      this.recamaras,
      this.terrenoM2,
      this.updatedAt,
      this.wc,
      this.baths});

  factory Property.fromJson(Map<String, dynamic> data) {
    List<Media> gallery = <Media>[];

    if (data["gallery"] != null) {
      var list = data["gallery"] as List;
      gallery = list.map((i) => Media.fromJson(i)).toList();
    }

    return Property(
      id: data["id"] as String,
      nombre: data["nombre"] as String,
      descripcion: data["descripcion"] as String,
      location: Location.fromJson(data["location"]),
      status: data["status"] as String,
      tipo: data["tipo"] as String,
      asesor: data["asesor"] as String,
      video: data["video"] == null ? null : Media.fromJson(data["video"]),
      gallery: gallery,
      caracteristicas: data["carcateristicas"] == null
          ? ''
          : data["carcateristicas"] as String,
      construccionM2:
          data["construccion_m2"] == null ? 0 : data["construccion_m2"] as int,
      amenidades:
          data["amenidades"] == null ? "" : data["amenidades"] as String,
      cp: data["cp"] == null ? '' : data["cp"] as String,
      createdAt: data["createdAt"] == null ? null : data["createdAt"] as String,
      direccion: data["direccion"] == null ? "" : data["direccion"] as String,
      edad: data["edad"] == null ? 0 : data["edad"] as int,
      entidad: data["entidad"] == null ? "" : data["entidad"] as String,
      estacionamientos: data["estacionamientos"] == null
          ? 0
          : data["estacionamientos"] as int,
      inventario: data["inventario"] == null ? 0 : data["inventario"] as int,
      localidad: data["localidad"] == null ? "" : data["localidad"] as String,
      pais: data["pais"] == null ? "Mexico" : data["pais"] as String,
      precio:
          data["precio"] == null ? "No Disponible" : data["precio"] as String,
      propietario:
          data["propietario"] == null ? "" : data["propietario"] as String,
      recamaras: data["recamaras"] == null ? 0 : data["recamaras"] as int,
      terrenoM2: data["terreno_m2"] == null ? 0 : data["terreno_m2"] as int,
      updatedAt: data["createdAt"] == null ? null : data["createdAt"] as String,
      wc: data["wc"] == null ? 0 : data["wc"] as int,
      baths: data["baths"] == null ? 0 : data["baths"] as int,
    );
  }
}
