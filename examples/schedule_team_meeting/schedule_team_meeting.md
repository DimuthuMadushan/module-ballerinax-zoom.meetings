# Schedule a team meeting

This example schedules a Zoom meeting that holds attendees in a waiting room until the host admits them, attaches a single-choice poll the host can launch during the meeting, and prints the invitation text Zoom generates so it can be shared by email or chat.

## Prerequisites

- A Zoom General App, its client ID and client secret, and a refresh token for the user who will host the meeting, as described in the [setup guide](../../ballerina/README.md#setup-guide). The app needs the `meeting:write:meeting`, `meeting:write:poll` and `meeting:read:invitation` scopes.
- The host must be on a Zoom Pro or higher plan, with meeting polls enabled in the account or user settings (**Settings** > **Meeting** > **Meeting polls/quizzes**).
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
  meetingTopic = "<MEETING_TOPIC>"
  # ISO 8601 in UTC, for example 2026-10-01T15:00:00Z
  startTime = "<YYYY-MM-DDTHH:MM:SSZ>"
  durationMinutes = 60
  timezone = "UTC"
  pollQuestion = "<POLL_QUESTION>"
  # Comma-separated, at least two answers
  pollAnswers = "<ANSWER_1>,<ANSWER_2>"
  ```

## Run the example

```bash
bal run
```
