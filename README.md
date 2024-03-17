# IP Risk Assessment Service

The IP Risk Assessment Service is designed to evaluate the risk associated with IP addresses based on their geolocation. By leveraging the IP Geolocation API, it determines the country associated with an IP address and assesses its risk, primarily focusing on whether the IP originates from a country other than Sri Lanka (LK).

## Prerequisites

To use this service, you'll need:

- Ballerina Swan Lake installed. For installation instructions, visit [Ballerina's official documentation](https://ballerina.io/).
- An API key for the IP Geolocation API. You can obtain one by signing up at [IPGeolocation](https://api.ipgeolocation.io).

## Configuration

Before deploying the service, you must configure the API key for the IP Geolocation service. This is done by setting the `geoApiKey` in a `Config.toml` file.

1. Create a `Config.toml` file in the same directory as your Ballerina service file.
2. Add the following content, replacing `your_api_key_here` with your actual IP Geolocation API key:

```toml
geoApiKey = "your_api_key_here"
