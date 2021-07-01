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




const appsyncUrl = process.env.API_SAFESALESEARCH_GRAPHQLAPIENDPOINTOUTPUT;
const apiKey = process.env.API_SAFESALESEARCH_GRAPHQLAPIKEYOUTPUT;

const region = process.env.REGION;

var applicationId = process.env.PINPOINT_PROJECT_ID;


const { request } = require('/opt/appSyncRequest');

const { getConvo } = require('/opt/queries');

const { sendmessage } = require('/opt/sendNotifications');
const { sendemail } = require('/opt/sendEmail');



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
        );
        if (result.data.getConvo.associated) {
          let name = result.data.getConvo.name;
          let id = result.data.getConvo.id;
          let category = result.data.getConvo.type;
          let idxx1 = result.data.getConvo.name.indexOf(":") + 1;
          let idxx2 = result.data.getConvo.name.indexOf(" de: ");
          if (idxx1 < 1)
            idxx1 = 0;
          if (idxx2 < 1)
            idxx2 = result.data.getConvo.name.length() - 1;
          let title = result.data.getConvo.name.substring(idxx1, idxx2);


          for (let idx in result.data.getConvo.associated.items) {
            let typechannel;
            let toaddress;
            const user = result.data.getConvo.associated.items[idx];
            if (user.guestmail) {
              typechannel = "Email";
              toaddress = user.guestmail;

            }
            else {
              toaddress = user.user.username;
              console.log("user ::", toaddress);

              if (user.user.devices) {

                for (let idx2 in user.user.devices.items) {
                  if (user.user.devices.items[idx2].platform == "ios") {
                    typechannel = "APNS";
                  }
                  else if (user.user.devices.items[idx2].platform == "android") {
                    typechannel = "FCM";
                  }

                  await sendmessage(typechannel, user.user.devices.items[idx2].token, content, title, id, category);
                }
              }
              if (!typechannel) {
                typechannel = "Email";
                console.log("Email::", toaddress);
              }



            }
            if (typechannel == "Email") {
              var body_html = `<html><head></head><body><h1>Safe Sale Te ha respondindo:</h1><p>` + content + `</p></body></html>`;

              await sendemail(toaddress, body_html, title);

            }
          }
        }

      } catch (error) {
        console.log(error);
      }
    }
  }

  return Promise.resolve('Successfully processed DynamoDB record');
};
