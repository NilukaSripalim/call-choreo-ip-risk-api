import ballerina/http;

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
    boolean hasRisk;
};

configurable string geoApiKey = ?;

service / on new http:Listener(8090) {
    resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {

        // Process the request data here
        // Simplified risk determination based on example logic
        boolean hasRisk = req.email.value.split("@")[1] != "example.com";

        RiskResponse resp = {
            email: req.email,
            name: req.name,
            userName: req.userName,
            correlationID: req.correlationID,
            hasRisk: hasRisk
        };

        return resp;
    }
}
