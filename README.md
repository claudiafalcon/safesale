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
{"acknowledged":true}%                                                                                         boofalcon@MacBook-Pro-de-Claudia ~ % curl -XPUT https://search-amplify-elasti-1jhhlzsmb057p-fjseujlcwr2vihi3tcwwxw5lkq.us-east-1.es.amazonaws.com/property -d '{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "standard",
          "filter": [ "lowercase", "my_snow" ]
        }
      },
      "filter": {
        "my_snow": {
          "type": "snowball",
          "language": "Spanish"
        }
      }
    }
  }
}' -H 'Content-Type: application/json'
