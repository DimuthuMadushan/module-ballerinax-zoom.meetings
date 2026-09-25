# Change Log

This file contains all the notable changes done to the Ballerina `zoom.meetings` package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

This is a major release. Code written against 1.x does not compile against 2.0.0 without changes.

### Changed

- **Resource methods are replaced by remote methods.** Every operation is now a named remote method instead of a resource path. For example:

  | 1.x | 2.0.0 |
  |---|---|
  | `zoom->/users/[userId]/meetings()` | `zoom->listMeetings(userId)` |
  | `zoom->/users/[userId]/meetings.post(payload)` | `zoom->createMeeting(userId, payload)` |
  | `zoom->/meetings/[meetingId]()` | `zoom->getMeeting(meetingId)` |
  | `zoom->/meetings/[meetingId].patch(payload)` | `zoom->updateMeeting(meetingId, payload)` |
  | `zoom->/meetings/[meetingId].delete()` | `zoom->deleteMeeting(meetingId)` |
  | `zoom->/users/[userId]/upcoming_meetings()` | `zoom->listUpcomingMeetings(userId)` |
  | `zoom->/meetings/[meetingId]/invitation()` | `zoom->getMeetingInvitation(meetingId)` |

  Path parameters become the leading positional arguments, followed by the request payload where there is one. Query parameters are still passed as named arguments.

- **Generated type names changed.** Anonymous `InlineResponse<NNN>` and path-derived record names are replaced with names derived from the operation that uses them, for example `InlineResponse20028` → `ListMeetingsResponse` and `InlineResponse2018` → `CreateMeetingResponse`. Request payloads are named `<Operation>Request`, for example `CreateMeetingRequest`.

- **The legacy SIP phone operations are removed.** Zoom retired `/sip_phones` in favour of `/sip_phones/phones`. Use the replacements, which are part of this release:

  | Removed operation | Replacement |
  |---|---|
  | `GET /sip_phones` (`listSipPhones`) | `listSipPhones` → `GET /sip_phones/phones` |
  | `POST /sip_phones` (`createSIPPhone`) | `enableSipPhone` → `POST /sip_phones/phones` |
  | `PATCH /sip_phones/{phoneId}` (`updateSIPPhone`) | `updateSipPhone` → `PATCH /sip_phones/phones/{phoneId}` |
  | `DELETE /sip_phones/{phoneId}` (`deleteSIPPhone`) | `deleteSipPhone` → `DELETE /sip_phones/phones/{phoneId}` |

- **The minimum Ballerina distribution is now 2201.13.4** (Swan Lake Update 13).

### Added

- `getMeetingTranscript` and `deleteMeetingTranscript` (`GET`/`DELETE /meetings/{meetingId}/transcript`)
- `deleteMeetingSummary` (`DELETE /meetings/{meetingId}/meeting_summary`)
- `listUserMeetingSummaries` (`GET /users/{userId}/meeting_summaries`)
- `listArchivedFileDownloadAudits` (`GET /archive_files/download_audit`)
- `getDisclaimerReport` (`GET /report/disclaimer`)
- `getRemoteSupportReport` (`GET /report/remote_support`)

### Changed

- `OAuth2RefreshTokenGrantConfig.refreshUrl` now defaults to `https://zoom.us/oauth/token`, so it no longer has to be configured.
