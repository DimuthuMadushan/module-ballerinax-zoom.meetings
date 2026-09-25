# Ballerina Zoom Meetings connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-zoom.meetings.svg)](https://github.com/ballerina-platform/module-ballerinax-zoom.meetings/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/zoom.meetings.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fzoom.meetings)

## Overview

[Zoom](https://www.zoom.com/) is a video conferencing platform from Zoom Video Communications that lets people host and join online meetings and webinars from any device.

The Zoom Meetings connector lets Ballerina applications work with version 2 of the Zoom Meetings API. It covers the full lifecycle of meetings and webinars, from scheduling and registration through in-meeting controls to recordings, transcripts, summaries and usage reports.

## Setup guide

To use the Zoom meetings connector, you must have access to the Zoom API through  [Zoom Marketplace](https://marketplace.zoom.us/) and a project under it. If you do not have a Zoom account, you can sign up for one [here](https://zoom.us/signup#/signup).

### Step 1: Create a new app
   1. Open the [Zoom Marketplace](https://marketplace.zoom.us/).

   2. Click "Develop" → "Build App"

      ![Zoom Marketplace](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/build-app.png)

   3. Choose **"General App"** app type (for user authorization with refresh tokens)

      ![App Type](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/general-app.png)
   

   4. Fill in Basic Information, choose Admin-managed option.

### Step 2: Configure OAuth settings

   1. **Note down your credentials:**
      * Client ID
      * Client Secret

      ![App Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/app-credentials.png)
      
   2. **Set Redirect URI:** Add your application's redirect URI

   3. **Add scopes:** Add the scopes for the operations your application calls. Each operation lists the scopes it accepts in the API reference; for example, scheduling and listing meetings needs `meeting:write:meeting` and `meeting:read:list_meetings`, and looking up the user ID below needs `user:read:user`.

      ![App Scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-zoom.meetings/refs/heads/main/docs/setup/resources/app-scopes.png)

### Step 3: Activate the app
 
   1. Complete all necessary information fields.

   2. Once, the necessary fields are correctly filled, app will be activated.

### Step 4: Get user authorization

   1. **Direct users to authorization URL** (replace `YOUR_CLIENT_ID` and `YOUR_REDIRECT_URI`):
      ```
      https://zoom.us/oauth/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI
      ```

   2. **User authorizes the app** and gets redirected to your callback URL with an authorization code

   3. **Exchange authorization code for tokens:**
      ```curl
      curl -X POST https://zoom.us/oauth/token \
      -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
      -d "grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=YOUR_REDIRECT_URI"
      ```

      This returns both `access_token` and `refresh_token`.

      Replace:
         * `CLIENT_ID` with your app's Client ID
         * `CLIENT_SECRET` with your app's Client Secret
         * `AUTHORIZATION_CODE` with the code received from the callback
         * `YOUR_REDIRECT_URI` with your configured redirect URI

### Step 5: Verify your setup
   ```curl
      curl -X GET "https://api.zoom.us/v2/users/me" \
      -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
   ```
      
   This will give you the user ID needed for API calls.

## Quickstart

To use the Zoom Meetings connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `zoom.meetings` module.

```ballerina
import ballerinax/zoom.meetings;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the credentials obtained in the setup guide:

   ```toml
   clientId = "<CLIENT_ID>"
   clientSecret = "<CLIENT_SECRET>"
   refreshToken = "<REFRESH_TOKEN>"
   userId = "<USER_ID>"
   ```

   Zoom issues a new refresh token each time the access token is refreshed and invalidates the old one. The client keeps the latest token in memory while the application runs, but it does not write it back to `Config.toml`. Before you restart the application, update `refreshToken` in `Config.toml` with the latest token, or it will fail to authenticate.

2. Create a `meetings:Client` with the credentials. The connector refreshes the access token against `https://zoom.us/oauth/token` as needed.

   ```ballerina
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string refreshToken = ?;
   configurable string userId = ?;

   final meetings:Client zoom = check new ({
       auth: {clientId, clientSecret, refreshToken}
   });
   ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. For example, schedule a meeting for the user:

```ballerina
public function main() returns error? {
    meetings:CreateMeetingResponse _ = check zoom->createMeeting(userId, {
        topic: "Team sync",
        'type: 2,
        // Replace with a future date-time in UTC.
        startTime: "2026-10-01T15:00:00Z",
        duration: 30
    });
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Zoom Meetings connector provides practical examples illustrating usage in various scenarios. Explore these [examples](examples/), covering the following use cases:

1. [Schedule a team meeting](examples/schedule_team_meeting/schedule_team_meeting.md) - Create a meeting with a waiting room, attach a poll, and print the invitation to share with attendees.

2. [Cancel meetings by topic](examples/cancel_meetings_by_topic/cancel_meetings_by_topic.md) - Find every upcoming meeting whose topic contains a phrase and cancel them, with a dry run by default.

## Build from the source

### Setting up the prerequisites
1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:
    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)
   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.
2. Download and install [Ballerina Swan Lake](https://ballerina.io/).
3. Download and install [Docker](https://www.docker.com/get-started).
   > **Note**: Ensure that the Docker daemon is running before executing any tests.
4. Export Github Personal access token with read package permissions as follows,
    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```
### Build options
Execute the commands below to build from the source.
1. To build the package:
   ```bash
   ./gradlew clean build
   ```
2. To run the tests:
   ```bash
   ./gradlew clean test
   ```
3. To build without the tests:
   ```bash
   ./gradlew clean build -x test
   ```
4. To run tests against different environments:
   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```
5. To debug the package with a remote debugger:
   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```
6. To debug with the Ballerina language:
   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```
7. Publish the generated artifacts to the local Ballerina Central repository:
    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```
8. Publish the generated artifacts to the Ballerina Central repository:
   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`zoom.meetings` package](https://central.ballerina.io/ballerinax/zoom.meetings/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
