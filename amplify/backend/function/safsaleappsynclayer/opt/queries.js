
const gql = require('graphql-tag');
exports.getConvo = gql(`query GetConvo {
      getConvo(id: "85dc3fff-00aa-4433-b9f2-7adadf53f142") {
        id
        associated (filter: 
                            { not:  { convoLinkUserId: { eq: "933156f2-0a2a-43ac-b437-0d8152dbd91b"} } } ) {
          items {
            guestmail
            id
            user {
              devices {
                items {
                  token
                  platform
                }
              }
            }
            convoLinkUserId
          }
          nextToken
        }
        name
        type
      }
    }
    `);