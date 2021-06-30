const AWS = require("aws-sdk");
const region = process.env.REGION;
const applicationId = process.env.PINPOINT_PROJECT_ID;

var senderAddress = "no-reply@safesaleonline.com";


var charset = "UTF-8";

function CreateEmailRequest(toaddress, message, title) {

    var messageRequest = {
        'Addresses': {
            [toaddress]: {
                'ChannelType': 'EMAIL'
            }
        },
        'MessageConfiguration': {
            'EmailMessage': {
                'FromAddress': senderAddress,
                'SimpleEmail': {
                    'Subject': {
                        'Charset': charset,
                        'Data': title
                    },
                    'HtmlPart': {
                        'Charset': charset,
                        'Data': message
                    }
                }
            }
        }
    };

    return messageRequest;
}






/**
 * @param {String} service the typeOfservice FCM, APN, etc
 * @param {String} toaddress Address to send the notu
 * @param {String} message the message to send
 * @param {String} title the title of the message
 */
exports.sendemail = async (toaddress, message, title) => {
    var messageRequest = CreateEmailRequest(toaddress, message, title);


    var pinpoint = new AWS.Pinpoint();
    var params = {
        "ApplicationId": applicationId,
        "MessageRequest": messageRequest
    };


    try {
        console.log('App: ' + applicationId);
        // Try to send the message.
        let data = await pinpoint.sendMessages(params).promise();
        console.log("Email sent! Message ID: ", data['MessageResponse']['Result'][toaddress]['MessageId']);
    }
    catch (error) {
        console.log("error :: ", error);
    }
}

