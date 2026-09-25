# Running tests

## Prerequisites

The live tests need a Zoom General App with user authorization, and a refresh token for that user. To create one, follow the setup guide in the [Ballerina Zoom Meetings connector](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/tree/main/README.md).

You also need the ID of the user the tests act as. Find it with:

```curl
curl -X GET "https://api.zoom.us/v2/users/me" \
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Test environments

There are two test environments. The default is a mock server for the Zoom API; the other is the live Zoom API.

 Test Groups | Environment
-------------|---------------------------------------------------
 mock_tests  | Mock server for the Zoom API (default environment)
 live_tests  | Zoom API

Tests that need a paid plan or an add-on (registration, webinars, cloud recordings, meeting summaries, tracking fields) or a meeting in a particular state (in progress, already recorded) are in `mock_tests` only. Every live test that creates a meeting deletes it afterwards.

## Running tests against the mock server

Make sure the `IS_LIVE_SERVER` environment variable is unset or set to `false`, then run:

```bash
./gradlew clean test
```

## Running tests against the Zoom API

Set the following environment variables.

On Linux or macOS:

```bash
export IS_LIVE_SERVER="true"
export ZOOM_CLIENT_ID="your_client_id"
export ZOOM_CLIENT_SECRET="your_client_secret"
export ZOOM_REFRESH_TOKEN="your_refresh_token"
export ZOOM_USER_ID="your_user_id"
```

On Windows (PowerShell, current session):

```powershell
$env:IS_LIVE_SERVER = "true"
$env:ZOOM_CLIENT_ID = "your_client_id"
$env:ZOOM_CLIENT_SECRET = "your_client_secret"
$env:ZOOM_REFRESH_TOKEN = "your_refresh_token"
$env:ZOOM_USER_ID = "your_user_id"
```

Then run the live tests:

```bash
./gradlew clean test -Pgroups=live_tests
```
