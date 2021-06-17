const gql = require('graphql-tag');


const getConvo = /* GraphQL */ gql`
  query GetConvo($id: ID!,$guestmail:String,$convoLinkUserId:ID!) {
    getConvo(id: $id) {
      id
      associated (filter: { not: { guestmail: { eq: $guestmail }, and: { not: { convoLinkUserId: { eq: $convoLinkUserId } } } } }) {
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
`;