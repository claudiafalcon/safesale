import 'dart:convert';

import 'package:safesale/models/searchcriterio.dart';

const q_nerbyProperties = '''query MyQuery(\$lat:Float!, \$lon: Float!) {
                                    nearbyProperties(limit: 10, location: {lat: \$lat, lon: \$lon}, m: 50000) {
                                      total
                                      nextToken
                                      items {
                                        video 
                                        updatedAt
                                        tipo
                                        terreno_m2
                                        status
                                        recamaras
                                        propietario
                                        precio
                                        pais
                                        nombre
                                        location {
                                          lon
                                          lat
                                        }
                                        localidad
                                        inventario
                                        id
                                        galery {
                                          bucket
                                          key
                                          region
                                        }
                                        estacionamientos
                                        entidad
                                        edad
                                        direccion
                                        descripcion
                                        createdAt
                                        cp
                                        construccion_m2
                                        caracteristicas
                                        asesor
                                        amenidades
                                      }
                                    }
                                  }''';

String q_preffix_search(SearchCriterio criterio) =>
    '''query MyQuery {
                                                            searchProperties(criteria:{''' +
    criterio.toGrapql() +
    '''}) {
                                      total
                                      nextToken
                                      items {
                                        video 
                                        updatedAt
                                        tipo
                                        terreno_m2
                                        status
                                        recamaras
                                        propietario
                                        precio
                                        pais
                                        nombre
                                        location {
                                          lon
                                          lat
                                        }
                                        localidad
                                        inventario
                                        id
                                        galery {
                                          bucket
                                          key
                                          region
                                        }
                                        estacionamientos
                                        entidad
                                        edad
                                        direccion
                                        descripcion
                                        createdAt
                                        cp
                                        construccion_m2
                                        caracteristicas
                                        asesor
                                        amenidades
                                      }
                                    }
                                  }''';
