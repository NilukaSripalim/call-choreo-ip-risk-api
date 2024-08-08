import ballerina/http;
import ballerina/log;

configurable string asgardeoUrl = ?; // Base URL for Asgardeo API
configurable string clientId = ?; // Client ID
configurable string clientSecret = ?; // Client Secret

// Combine scopes into a single space-separated string
final string asgardeoScopesString = "internal_user_mgt_view internal_user_mgt_list internal_user_mgt_create internal_user_mgt_delete internal_user_mgt_update";

// Define a token URL for authorization
final string tokenUrl = "https://api.asgardeo.io/t/wso2externalstg/oauth2/token";

// Construct the ClientAuthConfig using configurable variables
configurable string asgardeoClientConfig = string`{
    "tokenUrl": "https://api.asgardeo.io/t/orgniluka0617newruntime/oauth2/token",
    "clientId": "${clientId}",
    "clientSecret": "${clientSecret}",
    "scopes": "${asgardeoScopesString}"
}`;

@display {
    label: "Asgardeo Client",
    id: "asgardeo/client"
}
final http:Client asgardeoClient = check new (asgardeoUrl, {
    auth: check asgardeoClientConfig.fromJSON()
});

# Checks the health of the Asgardeo server. Uses Asgardeo SCIM 2.0 API.
#
# + return - `()` if the server is reachable, else an `error`
isolated function checkAsgardeoHealth() returns error? {
    http:Response response = check asgardeoClient->/scim2/ServiceProviderConfig.get();
    if response.statusCode != http:STATUS_OK {
        return error("Asgardeo server is not reachable.");
    }
}

# Creates a new user in the Asgardeo user store. Uses Asgardeo SCIM 2.0 API.
# Create User - https://wso2.com/asgardeo/docs/apis/scim2/#/operations/createUser
#
# + user - User data to be created
# + return - `()` if the user was created successfully, else an `error`
isolated function createAsgardeoUser(json user) returns error? {
    http:Response response = check asgardeoClient->/scim2/Users.post(user);
    
    if response.statusCode != http:STATUS_CREATED {
        json|error jsonPayload = response.getJsonPayload();
        log:printError(string `Error while creating user. ${jsonPayload is json ?
            jsonPayload.toString() : response.statusCode}`);
        return error("Error while creating user.");
    }
    
    return ();
}

# Main function to create a user and check server health.
public function main() returns error? {
    // Check Asgardeo server health
    error? healthCheckError = checkAsgardeoHealth();
    if healthCheckError is error {
        return healthCheckError;
    }

    // Define user data with provided payload
    json newUser = {
        "email": {
            "value": "test1@test.com",
            "primary": true
        },
        "name": {
            "givenName": "Niluka",
            "familyName": "Sripali"
        },
        "password": "Wso2@1234",
        "userName": "DEFAULT/kim@gmail.com"
    };

    // Create user
    error? createUserError = createAsgardeoUser(newUser);
    if createUserError is error {
        return createUserError;
    }

    log:printInfo("User created successfully.");
}
