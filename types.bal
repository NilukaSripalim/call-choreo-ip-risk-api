import ballerina/http;

# [Configurable] OAuth2 application configuration.
type OAuth2App readonly & record {|
    # OAuth2 token endpoint URL
    string tokenUrl;
    # OAuth2 client ID
    string clientId;
    # OAuth2 client secret
    string clientSecret;
|};

# The Redis connection parameter based configuration. 
@display {label: "Redis Connection Configuration"}
public type RedisConnectionConfig record {|
    # Host address of the Redis database 
    @display {label: "Host"}
    string host;
    # Port of the Redis database
    @display {label: "Port"}
    int port = 6379;
    # The password for the Redis database
    @display {label: "Password"}
    string password?;
|};

# User credential record.
type UserCredential record {|
    # User ID
    @display {label: "User ID"}
    readonly string id;
    # Username
    @display {label: "Username"}
    readonly string username;
    # Password
    @display {label: "Password"}
    readonly string password;
|};

# Authentication context record.
type AuthenticationContext record {|
    # Context ID
    string contextId;
    # Username
    string username;
|};

# Asgardeo user info record.
type AsgardeoUser record {|
    # User ID
    string id;
    # Username
    string username;
    # Whether the user is migrated
    boolean isMigrated;
|};

# Asgardeo user info record.
type AsgardeoGetUserResponse record {|
    # User ID
    string id;
    # Username
    string userName;
    # Emails
    string[] emails;
    # WSO2 SCIM schema
    record {
        # Whether the user is migrated. This is a string value that will be either "true" or "false".
        string is_migrated;
    } urn\:scim\:wso2\:schema;
    json...;
|};

# Asgardeo Resource record.
type AsgardeoResource record {|
    *AsgardeoUser;
    string...;
|};

# Authentication cache detail record.
type AuthenticationStatusDetail record {|
    # Authentication status
    AuthenticationCacheStatus status;
    # Username
    string username;
|};

# Authentication cache status.
enum AuthenticationCacheStatus {
    # Pending authentication
    AUTHENTICATION_PENDING,
    # The user is not authenticated
    NOT_AUTHENTICATED,
    # The user is authenticated
    AUTHENTICATED
}

# Authentication status.
enum AuthenticationStatus {
    # Authentication is pending
    PENDING,
    # Authentication is complete
    COMPLETE
}

# Unsecured Authentication response.
type SecuredAuthenticationResponse record {|
    *http:Ok;
    # The response payload
    record {
        # Authentication cache status
        AuthenticationCacheStatus status;
    } body;
|};

# Unsecured Authentication response.
type UnsecuredAuthenticationResponse record {|
    *http:Ok;
    # The response payload
    record {
        # Authentication status
        AuthenticationStatus status;
    } body;
|};
