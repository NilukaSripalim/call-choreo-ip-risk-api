import ballerina/http;
import ballerina/log;

type Email record {
    string value;
    boolean primary;
};

type Name record {
    string givenName;
    string familyName;
};

type RiskRequest record {
    Email email;
    Name name;
    string userName;
    string correlationID;
};

type RiskResponse record {
    Email email;
    Name name;
    string userName;
    string correlationID;
};

configurable string geoApiKey = ?;

service / on new http:Listener(8090) {
    resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {

        // Process the request data here
        // Simplified risk determination based on example logic
        //boolean hasRisk = req.email.value.split("@")[1] != "example.com";
        string jsonString = check request.getTextPayload();

        // Log the received JSON payload (optional for debugging purposes)
        log:printInfo("Received JSON Payload: " + jsonString);

        RiskResponse resp = {
            email: req.email,
            name: req.name,
            userName: req.userName,
            correlationID: req.correlationID  
        };

        return resp;
    }
}
