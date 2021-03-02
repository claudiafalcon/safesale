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

const q_getUser = '''query GetUser(\$id:ID!) {
                                      getUser(id: \$id) {
                                        id
                                           alerts(limit: 10) {
                                            items {
                                              amenidades
                                              baths
                                              construccion_m2
                                              createdAt
                                              estacionamientos
                                              id
                                              precio_from
                                              precio_to
                                              recamaras
                                              searchCriteria
                                              terreno_m2
                                              tipo
                                              updatedAt
                                            }
                                            nextToken
                                          }
                                          favs(limit: 10) {
                                            items {
                                              property {
                                                amenidades
                                                asesor
                                                baths
                                                caracteristicas
                                                construccion_m2
                                                cp
                                                creacion
                                                createdAt
                                                descripcion
                                                direccion
                                                edad
                                                entidad
                                                estacionamientos
                                                id
                                                inventario
                                                localidad
                                                location {
                                                  lat
                                                  lon
                                                }
                                                nombre
                                                pais
                                                precio
                                                propertyGeohash
                                                propertyHashKey
                                                propietario
                                                recamaras
                                                status
                                                terreno_m2
                                                tipo
                                                updatedAt
                                                wc
                                              }
                                              createdAt
                                              id
                                              updatedAt
                                            }
                                            nextToken
                                          }
                                        }
                                      }''';

const m_createUser = '''mutation CreateUser(\$id:ID!) {
                                     createUser(input: {id: \$id}){
                                        id
                                      }
                                   }''';

String m_create_alert(SearchCriterio criterio) =>
    '''mutation CreateAlert(\$alertUserId:ID!) {
                                     createAlert(input: {
                                        alertUserId:\$alertUserId ''' +
    criterio.toGrapql() +
    '''
                                        }){
                                          id
                                        
                                      }
                                   }''';

const m_deleteAlert = '''mutation DeleteAlert(\$id:ID!) {
                                     deleteAlert(input: {id: \$id}){
                                        id
                                      }
                                   }''';
