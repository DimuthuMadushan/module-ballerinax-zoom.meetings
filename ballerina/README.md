## Overview

[Zoom](https://www.zoom.com/) is a video conferencing platform from Zoom Video Communications that lets people host and join online meetings and webinars from any device.

The Zoom Meetings connector lets Ballerina applications work with version 2 of the Zoom Meetings API. It covers the full lifecycle of meetings and webinars, from scheduling and registration through in-meeting controls to recordings, transcripts, summaries and usage reports.

### Key features

- Schedule, update, end and cancel meetings and webinars, including recurring ones
- Manage registrants, panelists, polls and surveys
- Retrieve cloud recordings, transcripts and AI Companion meeting summaries
- Generate usage, participant, billing and activity reports for an account
- Manage devices, SIP phones, tracking fields and TSP audio settings
- Authenticate with OAuth 2.0 refresh tokens or a bearer access token

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

The Zoom Meetings connector provides practical examples illustrating usage in various scenarios. Explore these [examples](../examples/), covering the following use cases:

1. [Schedule a team meeting](../examples/schedule_team_meeting/schedule_team_meeting.md) - Create a meeting with a waiting room, attach a poll, and print the invitation to share with attendees.

2. [Cancel meetings by topic](../examples/cancel_meetings_by_topic/cancel_meetings_by_topic.md) - Find every scheduled meeting whose topic contains a phrase and cancel them, with a dry run by default.
