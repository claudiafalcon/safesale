const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "safesalesearch": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://m5rpvgvc5rh6dlwbqlrxg5s3fi.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-fyjpi5hc6zczrbpucpcg2u63le"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:16993369-fa6e-4491-9cb2-a8dcbb116f4d",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_THHxX0XMz",
                        "AppClientId": "2smav9ndops2bgteud15voe6nm",
                        "AppClientSecret": "sira889rq3prgqpnl81mckqa5s7iegvp726sr14ja3her7j1sr4",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "s3-bucket-properties205233-dev",
                        "Region": "us-east-1"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://m5rpvgvc5rh6dlwbqlrxg5s3fi.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "safesalesearch_AMAZON_COGNITO_USER_POOLS"
                    },
                    "safesalesearch_API_KEY": {
                        "ApiUrl": "https://m5rpvgvc5rh6dlwbqlrxg5s3fi.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-fyjpi5hc6zczrbpucpcg2u63le",
                        "ClientDatabasePrefix": "safesalesearch_API_KEY"
                    },
                    "safesalesearch_AWS_IAM": {
                        "ApiUrl": "https://m5rpvgvc5rh6dlwbqlrxg5s3fi.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "safesalesearch_AWS_IAM"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "7fdc9f9916334dd9ab7404dc658f760a",
                        "Region": "us-east-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "s3-bucket-properties205233-dev",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';