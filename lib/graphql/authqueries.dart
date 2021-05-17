import 'dart:convert';

import 'package:safesale/models/searchcriterio.dart';

const q_nerbyProperties =
    '''query MyQuery(\$lat:Float!, \$lon: Float!, \$limit: Int!, \$nextToken:String ) {
                                    nearbyProperties(limit: \$limit, nextToken: \$nextToken, location: {lat: \$lat, lon: \$lon}, m: 50000) {
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
    '''query MyQuery( \$limit: Int!, \$nextToken:String ) {
                                                            searchProperties(limit: \$limit,  nextToken: \$nextToken,  criteria:{''' +
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
                                        username
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
                                          devices {
                                              items {
                                                id
                                                token
                                                platform
                                                vendorid
                                              }
                                              nextToken
                                            }
                                           conversations(limit: 100) {
                                              items {
                                                id
                                                conversation {
                                                  id
                                                  name
                                                  type
                                                  schedulerdate
                                                  scheduler
                                                  property {
                                                    id
                                                    nombre
                                                  }
                                                  associated{
                                                    items{
                                                      guestmail
                                                    }
                                                  }
                                                  messages(filter: {unread: {eq: true}, authorId: {ne: \$id}}, sortDirection: DESC, limit: 1) {
                                                  items {
                                                      createdAt
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                        }
                                      }''';

const m_createUser = '''mutation CreateUser(\$id:ID!,\$username:String!) {
                                     createUser(input: {id: \$id, username:\$username}){
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

const m_createFav =
    '''mutation CreateUserFavs(\$userFavsPropertyId:ID!, \$userFavsUserId:ID! ) {
                                     createUserFavs(input: {userFavsPropertyId: \$userFavsPropertyId, userFavsUserId:\$userFavsUserId}){
                                        id
                                      }
                                   }''';

const m_deleteFav = '''mutation DeleteFav(\$id:ID!) {
                                     deleteUserFavs(input: {id: \$id}){
                                        id
                                      }
                                   }''';

const q_getuserbyusername = '''query ListUser(\$username:String!) {
                      listUsers(filter: {username: {eq: \$username}}) {
                      items {
                      id
                      username
                    }
                    nextToken
                  }
                }''';

const m_createDevice =
    '''mutation CreateUserDevice(\$deviceOwnerId: ID!, \$platform: String!, \$token: String! , \$vendorid: String! ) {
                                createDevice(input: {deviceOwnerId: \$deviceOwnerId, platform: \$platform, token: \$token, vendorid: \$vendorid}) {
    id
  }
}''';

const m_updateDevice = '''mutation UpdateDevice(\$token: String !, \$id: ID !) {
  updateDevice(input: {id: \$id, token: \$token}) {
    id
  }
}''';

const m_deleteDevice = '''mutation DeleteDevice(\$id:ID!) {
                                     deleteDevice(input: {id: \$id}){
                                        id
                                      }
                                   }''';

const m_createConvo =
    '''mutation CreateConvo(\$members: [ID!]!, \$name: String!, \$type: String! , \$conversationPropertyId: ID, \$schedulerdate: String, \$scheduler: String) {
                                     createConvo(input: {members: \$members, name: \$name, type: \$type, conversationPropertyId: \$conversationPropertyId, scheduler:\$scheduler, schedulerdate:\$schedulerdate }){
                                        id
                                      }
                                   }''';

const m_createConvoLink =
    '''mutation CreateConvoLink(\$convoLinkConversationId:ID!, \$convoLinkUserId:ID!, \$guestmail:String ) {
                                createConvoLink(input: {convoLinkConversationId: \$convoLinkConversationId, convoLinkUserId:\$convoLinkUserId, guestmail: \$guestmail }) {
                                  id
                                }
                          }''';

const m_createMessage =
    '''mutation CreateMessahe (\$authorId:ID!, \$content:String!, \$messageConversationId:ID!, \$guestmail:String ) {
  createMessage(input: {authorId: \$authorId, content: \$content, messageConversationId: \$messageConversationId, guestmail: \$guestmail, unread: true}) {
    id
  }
} ''';

const s_onCreateConvoLink = '''subscription OnCreateConvoLink{
  onCreateConvoLink {
    id
    user {
      id
      username
      conversations {
        nextToken
      }
      messages {
        nextToken
      }
      createdAt
      updatedAt
    }
    convoLinkUserId
    conversation {
      id
      messages {
        nextToken
      }
      associated {
        nextToken
      }
      name
      members
      createdAt
      updatedAt
    }
    convoLinkConversationId
    createdAt
    updatedAt
  }
}
''';

const s_onCreateMessage =
    '''subscription OnCreateMessage(\$messageConversationId: ID!) {
  onCreateMessage(messageConversationId: \$messageConversationId) {
    id
    author {
      id
      username
      conversations {
        nextToken
      }
      messages {
        nextToken
      }
      createdAt
      updatedAt
    }
    authorId
    content
    conversation {
      id
      messages {
        nextToken
      }
      associated {
        nextToken
      }
      name
      members
      createdAt
      updatedAt
    }
    messageConversationId
    createdAt
    updatedAt
  }
}
''';

const q_getMessages = '''query GetConvo(\$id: ID!) {
  getConvo(id: \$id) {
    messages(sortDirection: ASC) {
      items {
        authorId
        content
        createdAt
        id
        unread
      }
    }
  }
}''';

const m_updateMessage = '''mutation UpdateMessage( \$id: ID !) {
  updateMessage(input: {id: \$id, unread: false}) {
    id
  }
}''';
