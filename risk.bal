/**
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
*/
//type RiskResponse record {
  //  Email email;
  //  Name name;
   // string userName;
   // string correlationID;
//};

//configurable string geoApiKey = ?;

//service / on new http:Listener(8090) {
    //resource function post risk(@http:Payload RiskRequest req) returns error? {
  //  resource function post echorisk(http:Caller caller, http:Request req) returns error? {

        // Process the request data here
        // Simplified risk determination based on example logic
        //boolean hasRisk = req.email.value.split("@")[1] != "example.com";
        string jsonString = check req.getTextPayload();

        // Log the received JSON payload (optional for debugging purposes)
     //   log:printInfo("Received JSON Payload: " + jsonString);

        
  //  }
//}

import ballerina/http;
import ballerina/log;
type RiskResponse record {
    boolean hasRisk;
};

type RiskRequest record {
    string ip;
};

type ipGeolocationResp record {
    string ip;
    string country_code2;
};

configurable string geoApiKey = ?;

service / on new http:Listener(8090) {
    resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {

        string ip = req.ip;
        http:Client ipGeolocation = check new ("https://api.ipgeolocation.io");
        ipGeolocationResp geoResponse = check ipGeolocation->get(string `/ipgeo?apiKey=${geoApiKey}&ip=${ip}&fields=country_code2`);

        string jsonString = check req.getTextPayload();

        // Log the received JSON payload (optional for debugging purposes)
        log:printInfo("Received JSON Payload: " + jsonString);

        RiskResponse resp = {
            // hasRisk is true if the country code of the IP address is not the specified country code.
            hasRisk: geoResponse.country_code2 != "LK"
        };
        return resp;
    }
}
