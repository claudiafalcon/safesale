/* Amplify Params - DO NOT EDIT
  API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIIDOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT
  AUTH_SAFESALEBA936A14_USERPOOLID
  ENV
  FUNCTION_SAFESALEBA936A14POSTCONFIRMATION_NAME
  REGION
Amplify Params - DO NOT EDIT *//* Amplify Params - DO NOT EDIT
  API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIIDOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT
  AUTH_SAFESALEBA936A14_USERPOOLID
  ENV
  FUNCTION_SAFESALEBA936A14POSTCONFIRMATION_NAME
  REGION
Amplify Params - DO NOT EDIT *//* Amplify Params - DO NOT EDIT
  API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIIDOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT
  ENV
  FUNCTION_SEARCHDELIVERYADDRESSES_NAME
  REGION
Amplify Params - DO NOT EDIT *//* Amplify Params - DO NOT EDIT
  API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
  API_SAFESALESEARCH_GRAPHQLAPIIDOUTPUT
  ENV
  FUNCTION_SEARCHDELIVERYADDRESSES_NAME
  REGION
Amplify Params - DO NOT EDIT */
const axios = require('axios');
const gql = require('graphql-tag');
const graphql = require('graphql');
const { print } = graphql;
var AWS = require("aws-sdk");




const appsyncUrl = process.env.API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
const apiKey = process.env.API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT


const { request } = require('/opt/appSyncRequest')

const { getConvo } = require('/opt/queries')
exports.handler = async (event) => {
  //eslint-disable-line
  console.log(JSON.stringify(event, null, 2));

  for (let prop in event.Records) {
    console.log(event.Records[prop].eventID);
    console.log(event.Records[prop].eventName);
    console.log('DynamoDB Record: %j', event.Records[prop].dynamodb);
    if (event.Records[prop].eventName == "INSERT") {
      try {

        const record = AWS.DynamoDB.Converter.unmarshall(event.Records[prop].dynamodb.NewImage);
        let conversationId = record["messageConversationId"];
        let guestmail = record["guestmail"];
        let authorid = record["authorId"];
        let id = record["id"];
        let content = record["content"];

        // create a TODO with AWS_IAM auth
        var result = await request(
          {
            query: print(getConvo),
            operationName: 'GetConvo',
            variables: {
              id: conversationId,
              guestmail: guestmail,
              convoLinkUserId: authorid,
            },
          },
          appsyncUrl, apiKey
        )
        console.log('iam results:', result)

      } catch (error) {
        console.log(error)
      }
    }
  }

  return Promise.resolve('Successfully processed DynamoDB record');
};
