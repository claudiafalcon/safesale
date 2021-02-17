#




 safesale

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Following for addind a geopoint in elastic searcgh


Following for addind a geopoint in elastic searcgh

PUT /property
PUT /property/_mapping/doc
{
  "properties": {
    "location": {
      "type": "geo_point"
    }
  }
}

curl -XDELETE https://search-amplify-elasti-1jhhlzsmb057p-fjseujlcwr2vihi3tcwwxw5lkq.us-east-1.es.amazonaws.com/property              



curl -XPUT https://search-amplify-elasti-1jhhlzsmb057p-fjseujlcwr2vihi3tcwwxw5lkq.us-east-1.es.amazonaws.com/property/_mapping/doc -d '{
   "properties": {
    "location": {
      "type": "geo_point"
    },
    "nombre" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "descripcion" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "caracteristicas" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "localidad" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "direccion" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "entidad" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    },
    "amenidades" : {
        "type": "text",
          "analyzer": "mianalizador",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
    }
  }
}' -H 'Content-Type: application/json'

curl -XPUT https://search-amplify-elasti-1jhhlzsmb057p-fjseujlcwr2vihi3tcwwxw5lkq.us-east-1.es.amazonaws.com/property -d '{
   "settings":{
      "number_of_shards":2,
      "number_of_replicas":1,
      "analysis":{
         "analyzer":{
            "mianalizador":{
               "tokenizer":"standard",
               "filter":[
                  "lowercase",
                  "asciifolding",
                  "default_spanish_stopwords",
                  "default_spanish_stemmer"
               ]
            }
         },
         "filter":{
            "default_spanish_stemmer":{
               "type":"stemmer",
               "name":"spanish"
            },
            "default_spanish_stopwords":{
               "type":"stop",
               "stopwords":[
                  "_spanish_"
               ]
            }
         }
      }
   }
}'  -H 'Content-Type: application/json'




GET /_search
{
  "query": { 
     "bool":{
       "must":[{"multi_match" : {
      "query":      "atizapan",
      "type":       "cross_fields",
      "fields": [ "nombre","descripcion","caractecteristicas","entidad","direccion","localidad"]}}, 
      {"query_string" : {
            "query" : "Balcón OR Areas Comunes OR Asador"
            , "fields": ["amenidades"]
        }
         
         
       }
         ]
           ,
      "filter": [ 
        { "term":  { "tipo": "departamento" }},
        {  "range": {"recamaras": {"gte": "3"}}},
        {  "range": {"estacionamientos": {"gte": "2"}}},
        {  "range": {"baths": {"gte": "1"}}},
        {  "range": {"terreno_m2": {"gte": "1"}}},
        {  "range": {"construccion_m2": {"gte": "1"}}},
        {  "range": {"precio": {"gte": "1","lte": "3000000"}}}
        
        
        
      ]
    }
  }
  
}