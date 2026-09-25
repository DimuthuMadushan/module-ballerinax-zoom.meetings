# Cancel meetings by topic

This example pages through every upcoming meeting a user hosts, picks out the ones whose topic contains a given phrase (case-insensitive) and that have not yet started, and cancels them, emailing the host and alternative hosts about each cancellation. It runs as a dry run by default and only lists what it would cancel.

## Prerequisites

- A Zoom General App, its client ID and client secret, and a refresh token for the user who hosts the meetings, as described in the [setup guide](../../ballerina/README.md#setup-guide). The app needs the `meeting:read:list_meetings` and `meeting:delete:meeting` scopes.
- Push the connector to the local repository:
  ```bash
  cd ../../ballerina
  bal pack && bal push --repository=local
  ```
- Create a `Config.toml` in this directory:
  ```toml
  clientId = "<CLIENT_ID>"
  clientSecret = "<CLIENT_SECRET>"
  refreshToken = "<REFRESH_TOKEN>"
  # The host's Zoom user ID or email address, or "me" for the authorizing user.
  userId = "me"
  # Must not be empty; an empty phrase is rejected.
  topicContains = "<TOPIC_PHRASE>"
  # Cancels the matching meetings for real. Leave false to only list them.
  cancelMeetings = false
  ```

## Run the example

```bash
bal run
```
