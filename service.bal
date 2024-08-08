import ballerina/http;
import ballerina/log;

configurable string asgardeoUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;

final string asgardeoScopesString = "internal_user_mgt_view internal_user_mgt_list internal_user_mgt_create internal_user_mgt_delete internal_user_mgt_update";

final http:Client asgardeoClient = check new (asgardeoUrl, {
    auth: {
        tokenUrl: "https://api.asgardeo.io/t/orgniluka0617newruntime/oauth2/token",
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: asgardeoScopesString
    }
});

# Checks the health of the Asgardeo server. Uses Asgardeo SCIM 2.0 API.
isolated function checkAsgardeoHealth() returns error? {
    http:Response response = check asgardeoClient->/scim2/ServiceProviderConfig.get();
    if response.statusCode != http:STATUS_OK {
        return error("Asgardeo server is not reachable.");
    }
}

# Creates a user in the Asgardeo user store. Uses Asgardeo SCIM 2.0 API.
isolated function createAsgardeoUser() returns json|error {
    json userPayload = {
        "email": {
            "value": "test1@test.com",
            "primary": true
        },
        "name": {
            "givenName": "testuser1",
            "familyName": "testuser2"
        },
        "password": "Wso2@1234",
        "userName": "DEFAULT/test1@test.com"
    };

    http:Response response = check asgardeoClient->/scim2/Users.post(userPayload);
    if response.statusCode != http:STATUS_CREATED {
        log:printError("Error while creating user.", response);
        return error("Error while creating user.");
    }
    return check response.getJsonPayload();
}
