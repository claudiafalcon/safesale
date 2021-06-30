
const AWS = require("aws-sdk");
const region = process.env.REGION;
const applicationId = process.env.PINPOINT_PROJECT_ID;

var action = 'OPEN_APP';

var priority = 'high';

var ttl = 60;

var silent = false;

function CreateMessageRequest(service, token, message, title) {

    if (service == 'FCM') {

        var RawContent = {
            "notification": {
                "title": title,
                "body": message
            }
        };

        var messageRequest = {
            'Addresses': {
                [token]: {
                    'ChannelType': 'GCM'
                }
            },
            'MessageConfiguration': {
                'GCMMessage': {
                    'Action': action,
                    'Body': message,
                    'Priority': priority,
                    'SilentPush': silent,
                    'Title': title,
                    'TimeToLive': ttl,
                    'RawContent': JSON.stringify(RawContent)
                }
            }
        };
    } else if (service == 'APNS') {
        messageRequest = {
            'Addresses': {
                [token]: {
                    'ChannelType': 'APNS'
                }
            },
            'MessageConfiguration': {
                'APNSMessage': {
                    'Action': action,
                    'Body': message,
                    'Priority': priority,
                    'SilentPush': silent,
                    'Title': title,
                    'TimeToLive': ttl
                }
            }
        };
    }

    return messageRequest
}



/**
 * @param {String} service the typeOfservice FCM, APN, etc
 * @param {String} token token to send the notu
 * @param {String} message the message to send
 * @param {String} title the title of the message
 */
exports.sendmessage = async (service, token, message, title) => {
    var messageRequest = CreateMessageRequest(service, token, message, title);


    // Specify that you're using a shared credentials file, and specify the
    // IAM profile to use.
    //var credentials = new AWS.SharedIniFileCredentials({ profile: 'default' });
    //AWS.config.credentials = credentials;

    // Specify the AWS Region to use.
    //AWS.config.update({ region: region });

    //Create a new Pinpoint object.
    var pinpoint = new AWS.Pinpoint();
    var params = {
        "ApplicationId": applicationId,
        "MessageRequest": messageRequest
    };


    try {
        console.log('App: ' + applicationId);
        // Try to send the message.
        let data = await pinpoint.sendMessages(params).promise();
        console.log('Success sending Push: ' + JSON.stringify(data));
    }
    catch (error) {
        console.log("error :: ", error);
    }
}
