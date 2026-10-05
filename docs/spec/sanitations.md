_Author_: @Laavanja19 \
_Created_: 2025/06/24 \
_Updated_: 2026/10/05 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Zoom Meetings.
The OpenAPI specification is obtained from the [Zoom Meetings API specification](https://github.com/wso2/api-specs/blob/main/openapi/zoom/meetings/2/openapi.json) (`openapi/zoom/meetings/2/openapi.json` in `api-specs`, `info.version: '2'`).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

Items 1, 5, 6 and 7 are applied to `docs/spec/openapi.json` before `bal openapi flatten`. Items 2, 3, 4 and 8 are applied to `docs/spec/aligned_ballerina_openapi.json`, after `bal openapi flatten` and `bal openapi align`, and must be re-applied after every re-align: the original keeps the vendor's duplicate declarations in the part schemas (so the public part records keep their fields), and has no `components/schemas` to lift into. Descriptions and summaries in the original were brought in line with the aligned spec.

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

   **Post-align step** (applied to `docs/spec/aligned_ballerina_openapi.json`): `GetUserMeetingsReportResponseDetails` and `GetUserMeetingsReportResponsePagination` both keep `next_page_token`, so that each public part record keeps `nextPageToken`. A third inline `allOf` member `{"type": "object", "properties": {"next_page_token": {"type": "string", "description": "The next page token is used to paginate through large result sets. A next page token will be returned whenever the set of available results exceeds the current page size. The expiration period for this token is 15 minutes", "example": "w7587w4eiyfsudgf", "x-ballerina-name": "nextPageToken"}}}` is appended to `GetUserMeetingsReportResponse.allOf`, so the composite record redeclares the field and compiles.

3. **Redeclared Symbol** : `recordingPlayPasscode` in types.bal

   **Issue** : The symbol `recordingPlayPasscode` is declared by two members of the `allOf` in `GetMeetingRecordingsResponse` (`GET /meetings/{meetingId}/recordings`), leading to a redeclaration error during compilation. Previously recorded against `InlineResponse2003`; the schema is `GetMeetingRecordingsResponse` after the renaming in this release.

   **Post-align step** (applied to `docs/spec/aligned_ballerina_openapi.json`): `GetMeetingRecordingsResponseBase` and `GetMeetingRecordingsResponseDetails` both keep `recording_play_passcode`, so that each public part record keeps `recordingPlayPasscode`. A fourth inline `allOf` member `{"type": "object", "properties": {"recording_play_passcode": {"type": "string", "description": "The cloud recording's passcode to be used in the URL. Directly splice this recording's passcode in `play_url` or `share_url` with `?pwd=` to access and play. Example: 'https://zoom.us/rec/share/**************?pwd=yNYIS408EJygs7rE5vVsJwXIz4-VW7MH'", "example": "yNYIS408EJygs7rE5vVsJwXIz4-VW7MH", "x-ballerina-name": "recordingPlayPasscode"}}}` is appended to `GetMeetingRecordingsResponse.allOf`, so the composite record redeclares the field and compiles.

4. **Redeclared Symbol** : `status` in types.bal

   **Issue** : The symbol `status` is declared by two members of the `allOf` in each registrant schema, one as the `approved`/`denied`/`pending` enum and one as a plain `string` (or a reordered enum), leading to a redeclaration error during compilation. Previously recorded against `RegistrationListRegistrants` only; after the renaming in this release the same conflict appears in four schemas: `ListWebinarRegistrantsResponseDetailsRegistrant`, `ListWebinarAbsenteesResponseDetailsRegistrant`, `GetMeetingRegistrantResponse` and `GetWebinarRegistrantResponse`. Following the note above, the enum definition is kept.

   **Post-align step** (applied to `docs/spec/aligned_ballerina_openapi.json`): the original has five such conflicts, in the 200 response schemas of `GET /meetings/{meetingId}/registrants/{registrantId}` and `GET /webinars/{webinarId}/registrants/{registrantId}`, and in the inline registrant items of `GET /webinars/{webinarId}/registrants`, `GET /past_webinars/{webinarId}/absentees` and `GET /meetings/{meetingId}/registrants` (the last is item 5). The first four stay as the vendor wrote them, so each public `...Extension` part record keeps its own `status` (`string`, or the reordered enum on `GetMeetingRegistrantResponseExtension`). After align, the `approved`/`denied`/`pending` enum from the schema's `...Details` member is added as a fourth inline `allOf` member to the four composites, so the composite redeclares it and compiles; the description is copied from that `...Details` member.

5. **Redeclared Symbol** : `status` in the inline registrant of `ListMeetingRegistrantsResponse`

   **Issue** : `GET /meetings/{meetingId}/registrants` returns registrants whose inline `allOf` declares `status` twice, as the `approved`/`denied`/`pending` enum and again as a plain `string`. `bal openapi flatten` leaves this item schema inline, so the generator merges all members into one record, and a redeclaration would produce an error.

   **Before**: `registrants.items.allOf[2].properties` has a plain `status` beside `join_url`, `create_time` and `participant_pin_code`.

   **After** (in `docs/spec/openapi.json`): that plain `status` is removed; the enum `status` from `allOf[1]` remains. This is the same fix as item 4, applied to an item schema that flatten leaves inline.

6. **Removed an invalid default** on the `recording_source_type` query parameter of `GET /users/{userId}/recordings`

   **Issue** : The parameter declares `"enum": ["cloud_recording_only", "my_notes_recording_only"]` with `"default": "null"`, a string that is not a member of the enum, so the generated `ListUserRecordingsQueries` failed to compile (`expected '"cloud_recording_only"|"my_notes_recording_only"', found 'string'`).

   **Before**: `"schema": {"type": "string", "enum": ["cloud_recording_only", "my_notes_recording_only"], "default": "null"}`

   **After** (in `docs/spec/openapi.json`): `"schema": {"type": "string", "enum": ["cloud_recording_only", "my_notes_recording_only"]}`. Leaving the parameter out returns all recordings, which is what the vendor's `null` meant.

7. **Set Zoom's OAuth 2.0 endpoints** on the `openapi_oauth` security scheme

   **Issue** : The `authorizationCode` flow has `"authorizationUrl": "/"` and empty `tokenUrl` and `refreshUrl`, so the generated `OAuth2RefreshTokenGrantConfig.refreshUrl` defaulted to `""` and every caller had to supply the token endpoint.

   **Before**: `"authorizationUrl": "/", "tokenUrl": "", "refreshUrl": ""`

   **After** (in `docs/spec/openapi.json`): `"authorizationUrl": "https://zoom.us/oauth/authorize", "tokenUrl": "https://zoom.us/oauth/token", "refreshUrl": "https://zoom.us/oauth/token"`

8. **Lifted inline array-item schemas nested in `allOf` into `components/schemas`**

   **Post-align step**: applied to `docs/spec/aligned_ballerina_openapi.json` after flatten and align, and it must be re-applied after every re-align. The original has no `components/schemas` to lift the schemas into.

   **Issue** : Inline object schemas used as array items inside an `allOf` member are given generator-derived type names such as `ListMeetingPollsResponsePollsItemsnull`, `GetMeetingRegistrationQuestionsResponse_questions` and, from the item's `title`, ``Tracking\ Field``, which is not usable as a type name.

   **Updated**: 25 such item schemas are moved into `components/schemas` and referenced with `$ref`, named `<Parent><Property>` with the property singularised (the item's `title` is dropped): `ListTrackingFieldsResponseTrackingField`, `ListWebinarPanelistsResponsePanelist`, `ListPastWebinarInstancesResponseWebinar`, `GetUpcomingEventsReportResponseUpcomingEvent`, `ListMeetingPollsResponsePoll` (with `...PollQuestion` and `...PollQuestionPrompt`), `ListWebinarPollsResponsePoll` (with `...PollQuestion` and `...PollQuestionPrompt`), `ListMeetingRegistrantsResponseRegistrant` and `ListRecordingRegistrantsResponseRegistrant` (each with `...CustomQuestion`), `GetMeetingRegistrationQuestionsResponseQuestion`, `GetMeetingRegistrationQuestionsResponseCustomQuestion`, `GetWebinarRegistrationQuestionsResponseQuestion`, `GetWebinarRegistrationQuestionsResponseCustomQuestion`, `GetMeetingRegistrantResponseDetailsCustomQuestion`, `GetWebinarRegistrantResponseDetailsCustomQuestion`, `ListWebinarAbsenteesResponseDetailsRegistrantDetailsCustomQuestion`, `ListWebinarRegistrantsResponseDetailsRegistrantDetailsCustomQuestion`, `GetMeetingRecordingsResponseBaseRecordingFile`, `GetMeetingRecordingsResponseExtensionParticipantAudioFile` and `ListUserRecordingsResponseExtensionMeetingRecordingFile`.

   **Reason**: Stable, readable public type names. The item schemas themselves are unchanged.

   **Other aligned-only edits** (also post-align): the descriptions that align cannot carry (an `allOf: [$ref]` wrapper with a `description` on `$ref` properties, and a few reworded property descriptions in schemas flatten lifts out of request bodies) live only in the committed aligned spec, and the `openapi_authorization` API-key scheme description. They affect doc comments in `types.bal` only.

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
