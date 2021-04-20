/* Amplify Params - DO NOT EDIT
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


const appsyncUrl = process.env.API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT
const apiKey = process.env.API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT


const { request } = require('/opt/appSyncRequest')

const { getConvo } = require('/opt/queries')

exports.handler = async event => {

  //eslint-disable-line
  console.log(JSON.stringify(event, null, 2));
  event.Records.forEach(record => {
    console.log(record.eventID);
    console.log(record.eventName);
    console.log('DynamoDB Record: %j', record.dynamodb);
  });


  try {
    // create a TODO with AWS_IAM auth
    var result = await request(
      {
        query: getConvo,
        operationName: 'GetConvo',
        variables: {
          input: {
            id: '3881abe5-1066-4827-9f09-0dd68f938378',
            guestmail: 'contacto@gpoaztlan.com',
            convoLinkUserId: '9f532486-8a44-4b0a-82cf-0544e33cd416'
          },
        },
      },
      appsyncUrl, apiKey
    )
    console.log('iam results:', result)

  } catch (error) {
    console.log(error)
  }

  return Promise.resolve('Successfully processed DynamoDB record');
};
