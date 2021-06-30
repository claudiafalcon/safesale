const gql = require('graphql-tag');
exports.getConvo = gql`
query GetConvo ($id:ID!,$guestmail:String,$convoLinkUserId:ID) {
    getConvo(id: $id) {
      id
      associated (filter: {not: {and: {guestmail: {eq: $guestmail}, and: {convoLinkUserId: {eq: $convoLinkUserId}}}}}){
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
            username
          }
          convoLinkUserId
        }
        nextToken
      }
      name
      type
    }
}
`;

//qur pasas