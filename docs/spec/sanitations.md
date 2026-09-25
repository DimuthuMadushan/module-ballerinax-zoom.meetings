_Author_: @Laavanja19 \
_Created_: 2025/06/24 \
_Updated_: 2026/09/25 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Zoom Meetings.
The OpenAPI specification is obtained from the [Zoom Meetings API specification](https://github.com/wso2/api-specs/blob/main/openapi/zoom/meetings/2/openapi.json) (`openapi/zoom/meetings/2/openapi.json` in `api-specs`, `info.version: '2'`).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

Item 1 is applied to `docs/spec/openapi.json` before `bal openapi flatten`. Every other item is applied to `docs/spec/aligned_ballerina_openapi.json`, after `bal openapi flatten` and `bal openapi align`.

## Sanitation Details

**Note** : In case of redeclared fields across multiple schemas under `allOf`, follow this rule:

* If one of the schema defines the field as a subtype (e.g., an `enum`) and another defines it as a base type (e.g., `string`), then choose the schema with the subtype and add the redeclared field in the mentioned way below.

1. **Unwrap single-member `allOf` request bodies** in `docs/spec/openapi.json`

   **Issue** : `bal openapi flatten` (2201.13.4) crashes on a request-body schema that is a single-member `allOf`. It names the lifted schema after the raw path (for example `/webinars/{webinarId}/polls`), and the `{` is then compiled as a regular expression, failing with `PatternSyntaxException: Illegal repetition`.

   **Before**:

   ```json
   "schema": {
     "allOf": [
       { "title": "Meeting and webinar polling object.", "type": "object", "properties": { ... } }
     ]
   }
   ```

   **After**:

   ```json
   "schema": { "title": "Meeting and webinar polling object.", "type": "object", "properties": { ... } }
   ```

   Each `allOf: [X]` is replaced with `X`, keeping any outer `description`. The schema means the same. It applies to 11 request bodies: `POST /meetings/{meetingId}/recordings/registrants` (whose outer `description`, `Registrant.`, is kept over the member's), `PATCH /meetings/{meetingId}/recordings/registrants/questions`, `PATCH /meetings/{meetingId}/registrants/questions`, `POST /meetings/{meetingId}/polls`, `PUT /meetings/{meetingId}/polls/{pollId}`, `POST /users/{userId}/meeting_templates`, `POST /users/{userId}/webinar_templates`, `POST /webinars/{webinarId}/polls`, `PUT /webinars/{webinarId}/polls/{pollId}`, `PATCH /webinars/{webinarId}/registrants/questions` and `PATCH /webinars/{webinarId}/survey`. A data comparison against the unmodified file confirms nothing else changed.

2. **Redeclared Symbol** : `nextPageToken` in types.bal

   **Issue** : The symbol `nextPageToken` is declared by two members of the `allOf` in `GetUserMeetingsReportResponse` (`GET /report/users/{userId}/meetings`), leading to a redeclaration error during compilation. Previously recorded against `InlineResponse20047`; the schema is `GetUserMeetingsReportResponse` after the renaming in this release.

   **Before**:

   ```json
    "GetUserMeetingsReportResponse": {
      "allOf": [
        { "$ref": "#/components/schemas/GetUserMeetingsReportResponsePagination" },
        { "$ref": "#/components/schemas/GetUserMeetingsReportResponseDetails" }
      ]
    }
   ```

   **After**:

   ```json
    "GetUserMeetingsReportResponse": {
      "allOf": [
        { "$ref": "#/components/schemas/GetUserMeetingsReportResponsePagination" },
        { "$ref": "#/components/schemas/GetUserMeetingsReportResponseDetails" },
        {
          "type": "object",
          "properties": {
            "next_page_token": {
              "type": "string",
              "description": "The next page token is used to paginate through large result sets. A next page token will be returned whenever the set of available results exceeds the current page size. The expiration period for this token is 15 minutes",
              "example": "w7587w4eiyfsudgk",
              "x-ballerina-name": "nextPageToken"
            }
          }
        }
      ]
    }
   ```

3. **Redeclared Symbol** : `recordingPlayPasscode` in types.bal

   **Issue** : The symbol `recordingPlayPasscode` is declared by two members of the `allOf` in `GetMeetingRecordingsResponse` (`GET /meetings/{meetingId}/recordings`), leading to a redeclaration error during compilation. Previously recorded against `InlineResponse2003`; the schema is `GetMeetingRecordingsResponse` after the renaming in this release.

   **Before**:

   ```json
    "GetMeetingRecordingsResponse": {
      "allOf": [
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseBase" },
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseDetails" },
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseExtension" }
      ]
    }
   ```

   **After**:

   ```json
    "GetMeetingRecordingsResponse": {
      "allOf": [
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseBase" },
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseDetails" },
        { "$ref": "#/components/schemas/GetMeetingRecordingsResponseExtension" },
        {
          "type": "object",
          "properties": {
            "recording_play_passcode": {
              "type": "string",
              "description": "The cloud recording's passcode to be used in the URL. Directly splice this recording's passcode in `play_url` or `share_url` with `?pwd=` to access and play. Example: 'https://zoom.us/rec/share/**************?pwd=yNYIS408EJygs7rE5vVsJwXIz4-VW7MH'",
              "example": "yNYIS408EJygs7rE5vVsJwXIz4-VW7MH",
              "x-ballerina-name": "recordingPlayPasscode"
            }
          }
        }
      ]
    }
   ```

4. **Redeclared Symbol** : `status` in types.bal

   **Issue** : The symbol `status` is declared by two members of the `allOf` in each registrant schema, one as the `approved`/`denied`/`pending` enum and one as a plain `string` (or a reordered enum), leading to a redeclaration error during compilation. Previously recorded against `RegistrationListRegistrants` only; after the renaming in this release the same conflict appears in four schemas: `ListWebinarRegistrantsResponseDetailsRegistrant`, `ListWebinarAbsenteesResponseDetailsRegistrant`, `GetMeetingRegistrantResponse` and `GetWebinarRegistrantResponse`. Following the note above, the enum definition is redeclared.

   **Before**:

   ```json
    "ListWebinarRegistrantsResponseDetailsRegistrant": {
      "allOf": [
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantBase" },
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantDetails" },
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantExtension" }
      ]
    }
   ```

   **After**:

   ```json
    "ListWebinarRegistrantsResponseDetailsRegistrant": {
      "allOf": [
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantBase" },
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantDetails" },
        { "$ref": "#/components/schemas/ListWebinarRegistrantsResponseDetailsRegistrantExtension" },
        {
          "type": "object",
          "properties": {
            "status": {
              "type": "string",
              "description": "The registrant's status. \n* `approved` - Registrant is approved. \n* `denied` - Registrant is denied. \n* `pending` - Registrant is waiting for approval",
              "example": "approved",
              "enum": ["approved", "denied", "pending"]
            }
          }
        }
      ]
    }
   ```

   The same third-party redeclaration is added to the other three schemas, each copying the enum definition from its own `...Details` member.

   None of the three items previously recorded here (2, 3 and 4) was dropped: all three still apply under the new schema names.

5. **Redeclared Symbol** : `status` in the inline registrant of `ListMeetingRegistrantsResponse`

   **Issue** : `GET /meetings/{meetingId}/registrants` returns registrants whose inline `allOf` declares `status` twice, as the `approved`/`denied`/`pending` enum and again as a plain `string`. `bal openapi flatten` leaves this item schema inline, so the generator merges all members into one record, and a third redeclaration (item 4's fix) would only add another duplicate.

   **Before**: `registrants.items.allOf[2].properties` has `status: {"type": "string"}` beside `join_url`, `create_time` and `participant_pin_code`.

   **After**: that plain `status` is removed; the enum `status` from `allOf[1]` remains.

6. **Removed an invalid default** on the `recording_source_type` query parameter of `GET /users/{userId}/recordings`

   **Issue** : The parameter declares `"enum": ["cloud_recording_only", "my_notes_recording_only"]` with `"default": "null"`, a string that is not a member of the enum, so the generated `ListUserRecordingsQueries` failed to compile (`expected '"cloud_recording_only"|"my_notes_recording_only"', found 'string'`).

   **Before**: `"schema": {"type": "string", "enum": ["cloud_recording_only", "my_notes_recording_only"], "default": "null"}`

   **After**: `"schema": {"type": "string", "enum": ["cloud_recording_only", "my_notes_recording_only"]}`. Leaving the parameter out returns all recordings, which is what the vendor's `null` meant.

7. **Set Zoom's OAuth 2.0 endpoints** on the `openapi_oauth` security scheme

   **Issue** : The `authorizationCode` flow has `"authorizationUrl": "/"` and empty `tokenUrl` and `refreshUrl`, so the generated `OAuth2RefreshTokenGrantConfig.refreshUrl` defaulted to `""` and every caller had to supply the token endpoint.

   **Before**: `"authorizationUrl": "/", "tokenUrl": "", "refreshUrl": ""`

   **After**: `"authorizationUrl": "https://zoom.us/oauth/authorize", "tokenUrl": "https://zoom.us/oauth/token", "refreshUrl": "https://zoom.us/oauth/token"`

8. **Lifted inline array-item schemas nested in `allOf` into `components/schemas`**

   **Issue** : Inline object schemas used as array items inside an `allOf` member are given generator-derived type names such as `ListMeetingPollsResponsePollsItemsnull`, `GetMeetingRegistrationQuestionsResponse_questions` and, from the item's `title`, ``Tracking\ Field``, which is not usable as a type name.

   **Updated**: 25 such item schemas are moved into `components/schemas` and referenced with `$ref`, named `<Parent><Property>` with the property singularised (the item's `title` is dropped): `ListTrackingFieldsResponseTrackingField`, `ListWebinarPanelistsResponsePanelist`, `ListPastWebinarInstancesResponseWebinar`, `GetUpcomingEventsReportResponseUpcomingEvent`, `ListMeetingPollsResponsePoll` (with `...PollQuestion` and `...PollQuestionPrompt`), `ListWebinarPollsResponsePoll` (with `...PollQuestion` and `...PollQuestionPrompt`), `ListMeetingRegistrantsResponseRegistrant` and `ListRecordingRegistrantsResponseRegistrant` (each with `...CustomQuestion`), `GetMeetingRegistrationQuestionsResponseQuestion`, `GetMeetingRegistrationQuestionsResponseCustomQuestion`, `GetWebinarRegistrationQuestionsResponseQuestion`, `GetWebinarRegistrationQuestionsResponseCustomQuestion`, `GetMeetingRegistrantResponseDetailsCustomQuestion`, `GetWebinarRegistrantResponseDetailsCustomQuestion`, `ListWebinarAbsenteesResponseDetailsRegistrantDetailsCustomQuestion`, `ListWebinarRegistrantsResponseDetailsRegistrantDetailsCustomQuestion`, `GetMeetingRecordingsResponseBaseRecordingFile`, `GetMeetingRecordingsResponseExtensionParticipantAudioFile` and `ListUserRecordingsResponseExtensionMeetingRecordingFile`.

   **Reason**: Stable, readable public type names. The item schemas themselves are unchanged.

9. Change `GetMeetingTranscriptResponse download_restriction_reason` to nullable
- **Original**: The `download_restriction_reason` field in `GetMeetingTranscriptResponse` was `not nullable`.
- **Updated**: The `download_restriction_reason` field has been updated to be `nullable`.
- **Reason**: The API can return a null value for this field.
<!-- auto-generated -->

10. Change `GetMeetingTranscriptResponse download_url` to nullable
- **Original**: The `download_url` field in `GetMeetingTranscriptResponse` was `not nullable`.
- **Updated**: The `download_url` field has been updated to be `nullable`.
- **Reason**: The API can return a null value for this field.
<!-- auto-generated -->

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```

Note: The license year is 2025, as set in `docs/license.txt`.
