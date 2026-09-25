// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Delete a meeting
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + occurrenceId - The meeting or webinar occurrence ID
    # + scheduleForReminder - `true`: Notify host and alternative host about the meeting cancellation via email.
    # `false`: Do not send any email notification
    # + cancelMeetingReminder - `true`: Notify registrants about the meeting cancellation via email. 
    # `false`: Do not send any email notification to meeting registrants. 
    # The default value of this field is `false`
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP Status Code**: `204`   
#  
# Meeting deleted)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `300` <br>
#  Invalid parameter: `occurrence_id`. <br>
# **Error Code:** `3000` <br>
#  Cannot access webinar information. <br>
# **Error Code:** `3018` <br>
#  Not allowed to delete PMI. <br>
# **Error Code:** `3037` <br>
#  Not allowed to delete PAC. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function delete meetings/[int meetingId](@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Query {name: "schedule_for_reminder"} boolean? scheduleForReminder, @http:Query {name: "cancel_meeting_reminder"} boolean? cancelMeetingReminder) returns http:NoContent|http:BadRequest|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }

    # Delete a meeting poll
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + pollId - The poll ID
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP Status Code:** `204`   
#  
# Meeting Poll deleted)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `4400` <br>
#  Meeting polls disabled. To enable this feature, enable the **Meeting Polls/Quizzes** setting in the Zoom web portal's **Settings** interface. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `404` <br>
#  Meeting poll not found. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function delete meetings/[int meetingId]/polls/[string pollId]() returns http:NoContent|http:BadRequest|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }

    # Delete a meeting registrant
    #
    # + meetingId - The meeting ID
    # + registrantId - The meeting registrant ID
    # + occurrenceId - The meeting occurrence ID
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP status code:** `204`   
#  
# OK)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `200` <br>
#  Only available for paid users: {userId}. <br>
# **Error Code:** `300` <br>
#  The value that you entered for the Registrant ID field is invalid. Enter a valid value and try again. <br>
# **Error Code:** `300` <br>
#  Registration has not been enabled for this meeting: {meetingId}. <br>
# **Error Code:** `3000` <br>
#  Cannot access webinar info. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function delete meetings/[int meetingId]/registrants/[string registrantId](@http:Query {name: "occurrence_id"} string? occurrenceId) returns http:NoContent|http:BadRequest|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }

    # Delete a webinar
    #
    # + webinarId - The webinar's ID
    # + occurrenceId - The meeting or webinar occurrence ID
    # + cancelWebinarReminder - `true` - Notify panelists and registrants about the webinar cancellation via email. 
    # `false` - Do not send any email notification to webinar registrants and panelists. 
    # The default value of this field is `false`
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP Status Code:** `204` <br>
#  Webinar deleted)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3000` <br>
#  Your request could not be processed because webinars created via event directory can not be updated or deleted using this method. <br>
# **Error Code:** `3000` <br>
#  You cannot update or delete simulive webinars that have started using this method. <br>
# **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for this user in order to perform this action. <br>
# **Error Code:** `200` <br>
#  No permission. <br>
# **Error Code:** `3000` <br>
#  Webinar occurrence does not exist. <br>
# **Error Code:** `300` <br>
#  Invalid webinar ID. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Webinar does not exist: {webinarId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function delete webinars/[int webinarId](@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Query {name: "cancel_webinar_reminder"} boolean? cancelWebinarReminder) returns http:NoContent|http:BadRequest|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }

    # Get a meeting
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, store it as a long format integer and **not** an integer. Meeting IDs can be more than 10 digits
    # + occurrenceId - Meeting occurrence ID. Provide this field to view meeting details of a particular occurrence of the [recurring meeting](https://support.zoom.us/hc/en-us/articles/214973206-Scheduling-Recurring-Meetings)
    # + showPreviousOccurrences - Set this field's value to `true` to view meeting details of all previous occurrences of a [recurring meeting](https://support.zoom.us/hc/en-us/articles/214973206-Scheduling-Recurring-Meetings). 
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# Meeting object returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3000` <br>
#  Cannot access webinar info. <br>
# **Error Code:** `3161` <br>
#  Your user account is not allowed meeting hosting and scheduling capabilities. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId](@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Query {name: "show_previous_occurrences"} boolean? showPreviousOccurrences) returns GetMeetingResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: meetingId, uuid: "aDYlohsHRtCd4ii1uC2+hA==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", hostEmail: "jchill@example.com",
            topic: "Quarterly planning sync", 'type: 2, status: "waiting", startTime: "2026-10-01T15:00:00Z", duration: 60,
            timezone: "America/Los_Angeles", agenda: "Review Q4 roadmap", createdAt: "2026-09-20T08:30:00Z",
            joinUrl: "https://us05web.zoom.us/j/85746065432?pwd=bXlQdHpXa0RaVmI4bkdqZz09",
            startUrl: "https://us05web.zoom.us/s/85746065432?zak=eyJ0eXAiOiJKV1Qi", password: "Rz7kQ2"
        };
    }

    # Get meeting invitation
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer, not a simple integer. Meeting IDs can exceed 10 digits
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# Meeting invitation returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId]/invitation() returns GetMeetingInvitationResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            invitation: "Jill Chill is inviting you to a scheduled Zoom meeting.\n\nTopic: Quarterly planning sync\nTime: Oct 1, 2026 08:00 AM Pacific Time\n\nJoin Zoom Meeting\nhttps://us05web.zoom.us/j/85746065432",
            sipLinks: ["85746065432@zoomcrc.com"]
        };
    }

    # List meeting polls
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + anonymous - Whether to query for polls with the **Anonymous** option enabled: 
    # * `true` &mdash; Query for polls with the **Anonymous** option enabled. 
    # * `false` &mdash; Do not query for polls with the **Anonymous** option enabled
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:**   
#  
# List polls of a Meeting  returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `4400` <br>
#  Meeting polls disabled. To enable this feature, enable the "Meeting Polls/Quizzes" setting in the Zoom web portal's "Settings" interface. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `404` <br>
#  Meeting Poll not found <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId]/polls(boolean? anonymous) returns ListMeetingPollsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            totalRecords: 1,
            polls: [
                {
                    id: "QalIoKWLTJehBJ8e1xRrbQ", status: "notstart", anonymous: false, pollType: 1, title: "Roadmap priorities",
                    questions: [{name: "Which quarter should we prioritise?", 'type: "single", answerRequired: true, answers: ["Q1", "Q2", "Q3", "Q4"], rightAnswers: ["Q4"]}]
                }
            ]
        };
    }

    # Get a meeting poll
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, store it as a `long` format integer, not a simple integer. Meeting IDs can exceed 10 digits
    # + pollId - The poll ID
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`   
#  
# Meeting Poll object returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `4400` <br>
#  Meeting polls disabled. To enable this feature, enable the "Meeting Polls/Quizzes" setting in the Zoom web portal's "Settings" interface. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `404` <br>
#  Meeting Poll not found. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId]/polls/[string pollId]() returns GetMeetingPollResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: pollId, status: "notstart", anonymous: false, pollType: 1, title: "Roadmap priorities",
            questions: [{name: "Which quarter should we prioritise?", 'type: "single", answerRequired: true, answers: ["Q1", "Q2", "Q3", "Q4"], rightAnswers: ["Q4"]}]
        };
    }

    # List meeting registrants
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, store it as a long format integer, not an integer. Meeting IDs can exceed 10 digits
    # + occurrenceId - The meeting or webinar occurrence ID
    # + status - Query by the registrant's status. 
    # * `pending` - The registration is pending. 
    # * `approved` - The registrant is approved. 
    # * `denied` - The registration is denied
    # + pageSize - The number of records returned within a single API call
    # + pageNumber - **Deprecated.** We will no longer support this field in a future release. Instead, use the `next_page_token` for pagination
    # + nextPageToken - Use the next page token to paginate through large result sets. A next page token is returned whenever the set of available results exceeds the current page size. This token's expiration period is 15 minutes
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# Successfully listed meeting registrants)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `300` <br>
#  Cannot access webinar info. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId]/registrants(@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Query {name: "next_page_token"} string? nextPageToken, "pending"|"approved"|"denied" status = "approved", @http:Query {name: "page_size"} int pageSize = 30, @http:Query {name: "page_number"} int pageNumber = 1) returns ListMeetingRegistrantsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            pageSize: pageSize, pageNumber: pageNumber, pageCount: 1, totalRecords: 1, nextPageToken: "",
            registrants: [
                {
                    id: "9tboDiHUQAeOnbmudzWa5g", firstName: "Jill", lastName: "Chill", email: "jchill@example.com",
                    status: "approved", city: "San Jose", country: "US", createTime: "2026-09-21T10:15:00Z",
                    joinUrl: "https://us05web.zoom.us/w/85746065432?tk=r4nd0mT0k3n", participantPinCode: 380303
                }
            ]
        };
    }

    # Get a meeting registrant
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + registrantId - The registrant ID
    # + return - returns can be any of following types 
    # http:Ok (The retrieved meeting registrant)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3000` <br>
#  Cannot access webinar info. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get meetings/[int meetingId]/registrants/[string registrantId]() returns GetMeetingRegistrantResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: registrantId, firstName: "Jill", lastName: "Chill", email: "jchill@example.com", status: "approved",
            city: "San Jose", country: "US", org: "Example Corp", jobTitle: "Product Manager",
            createTime: "2026-09-21T10:15:00Z", joinUrl: "https://us05web.zoom.us/w/85746065432?tk=r4nd0mT0k3n",
            participantPinCode: 380303
        };
    }

    # Get a meeting or webinar summary
    #
    # + meetingId - The meeting's universally unique ID (UUID). When you provide a meeting UUID that begins with a `/` character or contains the `//` characters, you **must** double-encode the meeting UUID before making an API request
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200` Meeting summary object returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `200` <br>
#  Only available for Paid account. <br>
# **Error Code:** `300` <br>
#  Invalid meeting ID. <br>
# )
    # http:Forbidden (**HTTP Status Code:** `403` <br>
#  Forbidden  
# 
#  **Error Code:** `2305` <br>
#  Access to meeting summaries is restricted by account settings. To use this feature, disable the **Only share meeting summaries by email** setting in the **Account Settings** page of the Zoom web portal. <br>
# **Error Code:** `2305` <br>
#  Access to meeting summaries is restricted to specific IP address ranges. To allow access, go to the **Settings** page in the Zoom web portal and update the **IP address access control** setting. <br>
# **Error Code:** `2305` <br>
#  The meeting summary has been moved to Trash and cannot be accessed. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get meetings/[string meetingId]/meeting_summary() returns GetMeetingSummaryResponse|http:BadRequest|http:Forbidden|http:NotFound|http:TooManyRequests {
        return {
            meetingUuid: meetingId, meetingId: 85746065432, meetingHostId: "30R7kT7bTIKSNUFEuH_Qlg",
            meetingHostEmail: "jchill@example.com", meetingTopic: "Quarterly planning sync",
            meetingStartTime: "2026-10-01T15:00:00Z", meetingEndTime: "2026-10-01T16:00:00Z",
            summaryStartTime: "2026-10-01T15:00:00Z", summaryEndTime: "2026-10-01T16:00:00Z",
            summaryCreatedTime: "2026-10-01T16:02:00Z", summaryTitle: "Meeting summary for Quarterly planning sync",
            summaryContent: "## Quick recap\nThe team agreed to prioritise the Q4 roadmap items.\n\n## Next steps\n- Share the final roadmap with stakeholders",
            summaryDocUrl: "https://docs.zoom.us/doc/QX3xZ9bVTC2mXFy2W9Q7Yw"
        };
    }

    # Get meeting recordings
    #
    # + meetingId - To get a meeting's cloud recordings, provide the meeting ID or UUID. If providing the meeting ID instead of UUID, the response will be for the latest meeting instance. 
    # To get a webinar's cloud recordings, provide the webinar's ID or UUID. If providing the webinar ID instead of UUID, the response will be for the latest webinar instance. 
    # If a UUID starts with `/` or contains `//` (example: `/ajXp112QmuoKj4854875==`), **[double encode](/docs/api/using-zoom-apis/#meeting-id-and-uuid) the UUID** before making an API request. 
    # + includeFields - Include fields in the response. Currently, only accepts `download_access_token` to get this token field and value for downloading the meeting's recordings. The `download_access_token` requires **View the recording content** enabled for the role authorizing the account. Use the format `include_fields=download_access_token`
    # + ttl - The `download_access_token` Time to Live (TTL) value. This parameter is only valid if the `include_fields` query parameter contains the value `download_access_token`
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`   
#  
# Recording object returned. 
# 
# **Error Code:** `200`   
#  
# You do not have the right permissions)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `1010` <br>
#  User not found on this account: {accountId}. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User "{userId}" does not exist or does not belong to this account. <br>
# **Error Code:** `3301` <br>
#  There is no recording for this meeting. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get meetings/[string meetingId]/recordings(@http:Query {name: "include_fields"} string? includeFields, int? ttl) returns GetMeetingRecordingsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            uuid: meetingId, id: 85746065432, accountId: "Cx3wERazSgup7ZWRHQM8-w", hostId: "30R7kT7bTIKSNUFEuH_Qlg",
            topic: "Quarterly planning sync", 'type: "2", startTime: "2026-10-01T15:00:00Z", duration: 58,
            totalSize: 529758, recordingCount: 1,
            recordingFiles: [
                {
                    id: "ed6c2f27-2ae7-42f4-b3d0-835b493e4fa8", meetingId: meetingId, fileType: "MP4",
                    fileExtension: "MP4", fileSize: 529758d, status: "completed",
                    recordingStart: "2026-10-01T15:00:05Z", recordingEnd: "2026-10-01T15:58:40Z",
                    playUrl: "https://us05web.zoom.us/rec/play/Qg75t7xZBtEbAkjdlgbfdngBBBB",
                    downloadUrl: "https://us05web.zoom.us/rec/download/Qg75t7xZBtEbAkjdlgbfdngBBBB"
                }
            ]
        };
    }

    # Get a meeting transcript
    #
    # + meetingId - To get a meeting's transcript, provide the meeting ID or meeting UUID. If the meeting ID is provided instead of UUID, the response will be for the latest meeting instance. 
    # To get a webinar's transcript, provide the webinar ID or the webinar UUID. If the webinar ID is provided instead of UUID, the response will be for the latest webinar instance. 
    # If a UUID starts with `/` or contains `//`, like `/ajXp112QmuoKj4854875==`, you must **double encode** the UUID before making an API request. 
    # + return - returns can be any of following types 
    # http:Ok (HTTP Status Code: 200  Transcript object returned)
    # http:Forbidden (**HTTP Status Code:** `403` <br>
#  Forbidden  No permission 
# 
#  )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3322` <br>
#  This meeting transcript does not exist. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get meetings/[string meetingId]/transcript() returns GetMeetingTranscriptResponse|http:Forbidden|http:NotFound|http:TooManyRequests {
        return {
            meetingId: meetingId, accountId: "Cx3wERazSgup7ZWRHQM8-w", hostId: "30R7kT7bTIKSNUFEuH_Qlg",
            meetingTopic: "Quarterly planning sync", transcriptCreatedTime: "2026-10-01T16:05:00Z",
            canDownload: true, autoDelete: false,
            downloadUrl: "https://us05web.zoom.us/rec/archive/download/transcript/Qg75t7xZBtEbAkjdlgbfdngBBBB"
        };
    }

    # Get past meeting details
    #
    # + meetingId - The meeting's ID or universally unique ID (UUID). 
    # * If you provide a meeting ID, the API will return a response for the latest meeting instance. 
    # * If you provide a meeting UUID that begins with a `/` character or contains the `//` characters, you **must** [double encode](https://marketplace.zoom.us/docs/api-reference/using-zoom-apis/#meeting-id-and-uuid) the meeting UUID before making an API request
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200` Meeting information returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `300` <br>
#  Cannot access meeting information. <br>
# **Error Code:** `200` <br>
#  Only available for paid account: {accountId}. <br>
# **Error Code:** `12702` <br>
#  Cannot access a meeting a year ago. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get past_meetings/[string meetingId]() returns GetPastMeetingResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            uuid: meetingId, id: 85746065432, hostId: "30R7kT7bTIKSNUFEuH_Qlg", userName: "Jill Chill",
            userEmail: "jchill@example.com", topic: "Quarterly planning sync", 'type: 2,
            startTime: "2026-10-01T15:00:00Z", endTime: "2026-10-01T16:00:00Z", duration: 60,
            totalMinutes: 180, participantsCount: 3, 'source: "Zoom", hasMeetingSummary: true
        };
    }

    # Get past meeting participants
    #
    # + meetingId - The meeting's ID or universally unique ID (UUID). 
    # * If you provide a meeting ID, the API will return a response for the latest meeting instance. 
    # * If you provide a meeting UUID that begins with a `/` character or contains the `//` characters, you **must** double-encode the meeting UUID before making an API request
    # + pageSize - The number of records returned within a single API call
    # + nextPageToken - Use the next page token to paginate through large result sets. A next page token is returned whenever the set of available results exceeds the current page size. This token's expiration period is 15 minutes
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`
# 
# Past meeting participants returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `200` <br>
#  Only available for paid account: {accountId} <br>
# **Error Code:** `12702` <br>
#  Can not access a meeting a year ago. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get past_meetings/[string meetingId]/participants(@http:Query {name: "next_page_token"} string? nextPageToken, @http:Query {name: "page_size"} int pageSize = 30) returns ListPastMeetingParticipantsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            pageSize: pageSize, pageCount: 1, totalRecords: 2, nextPageToken: "",
            participants: [
                {id: "30R7kT7bTIKSNUFEuH_Qlg", name: "Jill Chill", userEmail: "jchill@example.com", joinTime: "2026-10-01T15:00:00Z", leaveTime: "2026-10-01T16:00:00Z", duration: 3600, status: "in_meeting"},
                {id: "8b29rgg4bb2", name: "Ravi Kumar", userEmail: "rkumar@example.com", joinTime: "2026-10-01T15:02:00Z", leaveTime: "2026-10-01T15:55:00Z", duration: 3180, status: "in_meeting"}
            ]
        };
    }

    # List tracking fields
    #
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200` List of Tracking Fields returned)
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get tracking_fields() returns ListTrackingFieldsResponse|http:TooManyRequests {
        return {
            totalRecords: 1,
            trackingFields: [{id: "a32CJji-weJ92", 'field: "Cost center", required: false, visible: true, recommendedValues: ["Engineering", "Sales"]}]
        };
    }

    # List meetings
    #
    # + userId - The user's user ID or email address. For user-level apps, pass the `me` value
    # + 'type - The meeting type. 
    # * `scheduled` - All valid previous (unexpired) meetings, live meetings, and upcoming scheduled meetings. 
    # * `live` - All the ongoing meetings. 
    # * `upcoming` - All upcoming meetings, including live meetings. 
    # * `upcoming_meetings` - All upcoming meetings, including live meetings. 
    # * `previous_meetings` - All valid previous meetings whose scheduled end time has already passed
    # + pageSize - The number of records returned within a single API call
    # + nextPageToken - Use the next page token to paginate through large result sets. A next page token is returned whenever the set of available results exceeds the current page size. This token's expiration period is 15 minutes
    # + pageNumber - The page number of the current page in the returned records
    # + 'from - The start date
    # + to - The end date
    # + timezone - The timezone to assign to the `from` and `to` value. For a list of supported timezones and their formats, see our [timezone list](/docs/api/references/abbreviations/#timezones)
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# List of meeting objects returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:Forbidden (**HTTP Status Code:** `403` <br>
#  Forbidden  
# 
#  **Error Code:** `2306` <br>
#  Not allowed to view meetings scheduled for others. To use this feature, enable the **Display meetings scheduled for others** setting in the **Account Settings** page of the Zoom web portal. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User does not exist: {userId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rate-limits/). 
# 
#  )
    resource function get users/[string userId]/meetings(@http:Query {name: "next_page_token"} string? nextPageToken, @http:Query {name: "page_number"} int? pageNumber, string? 'from, string? to, string? timezone, "scheduled"|"live"|"upcoming"|"upcoming_meetings"|"previous_meetings" 'type = "scheduled", @http:Query {name: "page_size"} int pageSize = 30) returns ListMeetingsResponse|http:BadRequest|http:Forbidden|http:NotFound|http:TooManyRequests {
        return {
            pageSize: pageSize, pageNumber: 1, pageCount: 1, totalRecords: 2, nextPageToken: "",
            meetings: [
                {id: 85746065432, uuid: "aDYlohsHRtCd4ii1uC2+hA==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", topic: "Quarterly planning sync", 'type: 2, startTime: "2026-10-01T15:00:00Z", duration: 60, timezone: "America/Los_Angeles", createdAt: "2026-09-20T08:30:00Z", joinUrl: "https://us05web.zoom.us/j/85746065432"},
                {id: 81234567890, uuid: "Xk3lohsHRtCd4ii1uC2+hA==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", topic: "Weekly stand-up", 'type: 8, startTime: "2026-10-02T16:00:00Z", duration: 30, timezone: "America/Los_Angeles", createdAt: "2026-09-18T09:00:00Z", joinUrl: "https://us05web.zoom.us/j/81234567890"}
            ]
        };
    }

    # List all recordings
    #
    # + userId - The user's ID or email address. For user-level apps, pass the `me` value
    # + pageSize - The number of records returned within a single API call
    # + nextPageToken - The next page token paginates through a large set of results. A next page token returns whenever the set of available results exceeds the current page size. The expiration period for this token is 15 minutes
    # + mc - The query metadata of the recording if using an on-premise meeting connector for the meeting
    # + trash - The query trash.
    # * `true` - List recordings from trash.  
    # * `false` - Do not list recordings from the trash.  
    # The default value is `false`. If you set it to `true`, you can use the `trash_type` property to indicate the type of Cloud recording that you need to retrieve. 
    # + 'from - The start date in 'yyyy-mm-dd' UTC format for the date range where you would like to retrieve recordings. The maximum range can be a month. If no value is provided for this field, the default will be current date. 
    # For example, if you make the API request on June 30, 2020, without providing the `from` and `to` parameters, by default the value of 'from' field will be `2020-06-30` and the value of the 'to' field will be `2020-07-01`. 
    # **Note**: The `trash` files cannot be filtered by date range and thus, the `from` and `to` fields should not be used for trash files
    # + to - The end date in 'yyyy-mm-dd' 'yyyy-mm-dd' UTC format. 
    # + trashType - The type of cloud recording to retrieve from the trash. 
    # *   `meeting_recordings`: List all meeting recordings from the trash.  
    # *  `recording_file`: List all individual recording files from the trash. 
    # + meetingId - The meeting ID
    # + zraStatus - The Zoom Revenue Accelerator (ZRA) analysis status of a recording.
    # * `all` - all Revenue Accelerator status.
    # *  `added`: added to Revenue Accelerator.
    # *  `not_added`: not added to Revenue Accelerator.
    # *  `processing`: processing Revenue Accelerator analysis
    # + recordingSourceType - * `null` - Return all recordings, including cloud recordings and My Notes recordings.
    # * `cloud_recording_only` - Return only cloud recordings.
    # * `my_notes_recording_only` - Return only My Notes recordings
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# List of recording objects returned)
    # http:Unauthorized (**HTTP Status Code:** `401` <br>
#  Unauthorized  
# 
#  **Error Code:** `124` <br>
#  Requires an access token. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User {userId} does not exist, or does not belong to this account. <br>
# **Error Code:** `3301` <br>
#  There is no recording for this session. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get users/[string userId]/recordings(@http:Query {name: "next_page_token"} string? nextPageToken, string? 'from, string? to, @http:Query {name: "meeting_id"} int? meetingId, @http:Query {name: "recording_source_type"} "cloud_recording_only"|"my_notes_recording_only"? recordingSourceType, @http:Query {name: "page_size"} int pageSize = 30, string mc = "false", boolean trash = false, @http:Query {name: "trash_type"} string trashType = "meeting_recordings", @http:Query {name: "zra_status"} "all"|"added"|"not_added"|"processing" zraStatus = "all") returns ListUserRecordingsResponse|http:Unauthorized|http:NotFound|http:TooManyRequests {
        return {
            'from: "2026-09-01", to: "2026-09-30", pageSize: pageSize, pageCount: 1, totalRecords: 1, nextPageToken: "",
            meetings: [
                {
                    uuid: "aDYlohsHRtCd4ii1uC2+hA==", id: 85746065432, accountId: "Cx3wERazSgup7ZWRHQM8-w",
                    hostId: "30R7kT7bTIKSNUFEuH_Qlg", topic: "Quarterly planning sync", 'type: "2",
                    startTime: "2026-09-15T15:00:00Z", duration: 58, totalSize: 529758, recordingCount: 1,
                    shareUrl: "https://us05web.zoom.us/rec/share/Qg75t7xZBtEbAkjdlgbfdngBBBB"
                }
            ]
        };
    }

    # List upcoming meetings
    #
    # + userId - The user's user ID or email address. For user-level apps, pass [the `me` value](/docs/api/rest/using-zoom-apis/#the-me-keyword)
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200` List of upcoming meeting objects returned)
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  User does not exist: {userId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get users/[string userId]/upcoming_meetings() returns ListUpcomingMeetingsResponse|http:NotFound|http:TooManyRequests {
        return {
            totalRecords: 1,
            meetings: [{id: 85746065432, topic: "Quarterly planning sync", 'type: 2, startTime: "2026-10-01T15:00:00Z", duration: 60, timezone: "America/Los_Angeles", createdAt: "2026-09-20T08:30:00Z", joinUrl: "https://us05web.zoom.us/j/85746065432", isHost: true, usePmi: false}]
        };
    }

    # List webinars
    #
    # + userId - The user's user ID or email address. For user-level apps, pass the `me` value
    # + 'type - The type of webinar. 
    # * `scheduled` - All valid previous (unexpired) webinars, live webinars, and upcoming scheduled webinars. 
    # * `upcoming` - All upcoming webinars, including live webinars
    # + pageSize - The number of records returned within a single API call
    # + pageNumber - **Deprecated** We will no longer support this field in a future release. Instead, use the `next_page_token` for pagination
    # + includeEventsWebinar - Include Zoom events webinar in searches. The default is `true`
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# List of webinar objects returned)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `200` <br>
#  No permission. <br>
# **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for this user in order to perform this action. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User does not exist: {userId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get users/[string userId]/webinars(@http:Query {name: "include_events_webinar"} boolean? includeEventsWebinar, "scheduled"|"upcoming" 'type = "scheduled", @http:Query {name: "page_size"} int pageSize = 30, @http:Query {name: "page_number"} int pageNumber = 1) returns ListWebinarsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            pageSize: pageSize, pageNumber: pageNumber, pageCount: 1, totalRecords: 1, nextPageToken: "",
            webinars: [{id: 96543210987, uuid: "4Ch1sFPqSUe5m8Y5Qd4UYQ==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", topic: "Product launch webinar", 'type: 5, startTime: "2026-10-10T17:00:00Z", duration: 90, timezone: "America/Los_Angeles", createdAt: "2026-09-22T11:00:00Z", joinUrl: "https://us05web.zoom.us/j/96543210987"}]
        };
    }

    # List panelists
    #
    # + webinarId - The webinar's ID
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# Webinar plan subscription missing. Enable webinar for this user once the subscription is added)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `300` <br>
#  Invalid webinar ID. <br>
# **Error Code:** `200` <br>
#  No permission. <br>
# **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for this user in order to perform this action. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Webinar does not exist: {webinarId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function get webinars/[int webinarId]/panelists() returns ListWebinarPanelistsResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            totalRecords: 1,
            panelists: [{id: "z8yCxjabRdOZ5WHVt5QZyA", name: "Ravi Kumar", email: "rkumar@example.com", joinUrl: "https://us05web.zoom.us/w/96543210987?tk=p4n3l1st"}]
        };
    }

    # Get a webinar
    #
    # + webinarId - The webinar's ID or universally unique ID (UUID)
    # + occurrenceId - Unique identifier for an occurrence of a recurring webinar. [Recurring webinars](https://support.zoom.us/hc/en-us/articles/216354763-How-to-Schedule-A-Recurring-Webinar) can have a maximum of 50 occurrences. When you create a recurring Webinar using [**Create a webinar**](/docs/api-reference/zoom-api/methods#operation/webinarCreate) API, you can retrieve the Occurrence ID from the response of the API call
    # + showPreviousOccurrences - Set the value of this field to `true` to view webinar details of all previous occurrences of a recurring webinar
    # + return - returns can be any of following types 
    # http:Ok (**HTTP Status Code:** `200`  
#  
# Success)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `300` <br>
#  Invalid webinar ID. <br>
# **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for user {userId} to perform this action. <br>
# **Error Code:** `200` <br>
#  No permission. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Webinar does not exist: {webinarId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function get webinars/[string webinarId](@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Query {name: "show_previous_occurrences"} boolean? showPreviousOccurrences) returns GetWebinarResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        int|error id = int:fromString(webinarId);
        return {
            id: id is int ? id : 96543210987, topic: "Product launch webinar", agenda: "Introducing the new release",
            uuid: "4Ch1sFPqSUe5m8Y5Qd4UYQ==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", hostEmail: "jchill@example.com",
            'type: 5, startTime: "2026-10-10T17:00:00Z", duration: 90, timezone: "America/Los_Angeles",
            createdAt: "2026-09-22T11:00:00Z", joinUrl: "https://us05web.zoom.us/j/96543210987",
            startUrl: "https://us05web.zoom.us/s/96543210987?zak=eyJ0eXAiOiJKV1Qi"
        };
    }

    # Update a meeting
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, store it as a long format integer and **not** an integer. Meeting IDs can be greater than 10 digits
    # + occurrenceId - Meeting occurrence ID. Support change of agenda, `start_time`, duration, or settings {`host_video`, `participant_video`, `join_before_host`, `mute_upon_entry`, `waiting_room`, `watermark`, `auto_recording`}
    # + payload - Meeting 
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP Status Code:** `204`  
#  
# Meeting updated)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3161` <br>
#  Your user account is not allowed meeting hosting and scheduling capabilities. <br>
# **Error Code:** `300` <br>
#  The value that you entered in the `schedule_for` field is invalid. Enter a valid value and try again. <br>
# **Error Code:** `300` <br>
#  Invalid `enforce_login_domains`. Separate multiple domains with semicolons. <br>
# **Error Code:** `3000` <br>
#  Cannot access webinar information. <br>
# **Error Code:** `3000` <br>
#  Instant meetings do not support the `schedule_for` parameter, and you can't schedule an instant meeting for another user. <br>
# **Error Code:** `3000` <br>
#  Users in '{userId}' have been blocked from joining meetings and webinars. To unblock them, go to the **Settings** page in the Zoom web portal and update **Block users in specific domains from joining meetings and webinars**. <br>
# **Error Code:** `3000` <br>
#  You cannot schedule a meeting for {userId} <br>
# **Error Code:** `3000` <br>
#  Prescheduling is only available for scheduled meetings (type 2) and recurring meetings with no fixed time (type 3). <br>
# **Error Code:** `3000` <br>
#  Unable to schedule for a user outside of your account for a meeting with continuous chat. <br>
# )
    # http:Unauthorized (**HTTP Status Code:** `401` <br>
#  Unauthorized  
# 
#  **Error Code:** `124` <br>
#  Invalid access token. <br>
# **Error Code:** `124` <br>
#  Access token has expired. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rate-limits/). 
# 
#  **Error Code:** `4001` <br>
#  You have reached the maximum per-second rate limit for this API. Try again later. <br>
# )
    resource function patch meetings/[int meetingId](@http:Query {name: "occurrence_id"} string? occurrenceId, @http:Payload UpdateMeetingRequest payload) returns http:NoContent|http:BadRequest|http:Unauthorized|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }

    # Create a meeting poll
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + payload - The meeting poll object 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201`   
#  
# Meeting Poll Created)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `4400` <br>
#  * Meeting polls disabled. To enable this feature, enable the "Meeting Polls/Quizzes" setting in the Zoom web portal's "Settings" interface. 
# * Advanced meeting polls disabled. To enable this feature, enable the "Allow host to create advanced polls and quizzes" setting in the Zoom web portal's "Settings" interface. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `404` <br>
#  Meeting not found <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function post meetings/[int meetingId]/polls(@http:Payload CreateMeetingPollRequest payload) returns CreateMeetingPollResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: "QalIoKWLTJehBJ8e1xRrbQ", status: "notstart", anonymous: payload.anonymous, pollType: payload.pollType,
            title: payload.title, questions: payload.questions
        };
    }

    # Add a meeting registrant
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a long format integer and **not** an integer. Meeting IDs can exceed 10 digits
    # + occurrenceIds - A comma-separated list of meeting occurrence IDs. You can get this value with the [Get a meeting](/docs/api-reference/zoom-api/methods#operation/meeting) API
    # + payload - Details of the registrant to add to the meeting 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201`   
#  
# Meeting registration created)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3043` <br>
#  Meeting has reached maximum attendee capacity. <br>
# **Error Code:** `3000` <br>
#  Cannot access meeting info. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function post meetings/[int meetingId]/registrants(@http:Query {name: "occurrence_ids"} string? occurrenceIds, @http:Payload AddMeetingRegistrantRequest payload) returns AddMeetingRegistrantResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: meetingId, registrantId: "fdgsfh2ey82fuh", topic: "Quarterly planning sync",
            startTime: "2026-10-01T15:00:00Z", participantPinCode: 380303,
            joinUrl: "https://us05web.zoom.us/w/85746065432?tk=r4nd0mT0k3n"
        };
    }

    # Create a tracking field
    #
    # + payload - Tracking Field 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201`  
#  
# Tracking Field created)
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function post tracking_fields(@http:Payload CreateTrackingFieldRequest payload) returns CreateTrackingFieldResponse|http:TooManyRequests {
        return {
            id: "a32CJji-weJ92", 'field: payload.'field, required: payload.required, visible: payload.visible,
            recommendedValues: payload.recommendedValues
        };
    }

    # Create a meeting
    #
    # + userId - The user's user ID or email address. For user-level apps, pass the `me` value
    # + payload - The meeting object 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201` Meeting created)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3161` <br>
#  Your user account is not allowed meeting hosting and scheduling capabilities. <br>
# **Error Code:** `3000` <br>
#  Instant meetings do not support the `schedule_for` parameter, and you can't schedule an instant meeting for another user. <br>
# **Error Code:** `3000` <br>
#  Users in '{userId}' have been blocked from joining meetings and webinars. To unblock them, go to the **Settings** page in the Zoom web portal and update **Block users in specific domains from joining meetings and webinars**. <br>
# **Error Code:** `3000` <br>
#  You cannot schedule a meeting for {userId} <br>
# **Error Code:** `300` <br>
#  The value that you entered in the `schedule_for` field is invalid. Enter a valid value and try again. <br>
# **Error Code:** `300` <br>
#  Invalid `enforce_login_domains`. Separate multiple domains with semicolons. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User does not exist: {userId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function post users/[string userId]/meetings(@http:Payload CreateMeetingRequest payload) returns CreateMeetingResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: 85746065432, uuid: "aDYlohsHRtCd4ii1uC2+hA==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", hostEmail: "jchill@example.com",
            topic: payload.topic, 'type: payload.'type, agenda: payload.agenda, startTime: payload.startTime,
            duration: payload.duration, timezone: payload.timezone, status: "waiting", createdAt: "2026-09-25T09:00:00Z",
            joinUrl: "https://us05web.zoom.us/j/85746065432?pwd=bXlQdHpXa0RaVmI4bkdqZz09",
            startUrl: "https://us05web.zoom.us/s/85746065432?zak=eyJ0eXAiOiJKV1Qi", password: "Rz7kQ2"
        };
    }

    # Create a webinar
    #
    # + userId - The user ID or email address of the user. For user-level apps, pass the `me` value
    # + payload - Details of the webinar to create 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201`  
#  
# Webinar created)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for user {userID} in order to perform this action. <br>
# **Error Code:** `300` <br>
#  The value that you entered for the `schedule_for` field is invalid. Enter a valid value and try again. <br>
# **Error Code:** `300` <br>
#  Can not schedule simulive webinar for others. <br>
# **Error Code:** `300` <br>
#  Account hasn't enabled simulive webinar. <br>
# **Error Code:** `300` <br>
#  Record file does not exist. <br>
# **Error Code:** `3000` <br>
#  You cannot schedule a meeting for {userId}. <br>
# **Error Code:** `200` <br>
#  No permission. <br>
# **Error Code:** `4505` <br>
#  Simulive can't select `No Fixed Time`. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `1001` <br>
#  User {userId} does not exist. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rate-limits/). 
# 
#  )
    resource function post users/[string userId]/webinars(@http:Payload CreateWebinarRequest payload) returns CreateWebinarResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: 96543210987, topic: payload.topic, agenda: payload.agenda,
            uuid: "4Ch1sFPqSUe5m8Y5Qd4UYQ==", hostId: "30R7kT7bTIKSNUFEuH_Qlg", hostEmail: "jchill@example.com",
            'type: payload.'type, startTime: payload.startTime, duration: payload.duration, timezone: "America/Los_Angeles",
            createdAt: "2026-09-22T11:00:00Z", joinUrl: "https://us05web.zoom.us/j/96543210987",
            startUrl: "https://us05web.zoom.us/s/96543210987?zak=eyJ0eXAiOiJKV1Qi"
        };
    }

    # Add a webinar registrant
    #
    # + webinarId - The webinar's ID
    # + occurrenceIds - A comma-separated list of webinar occurrence IDs. Get this value with the [Get a webinar](/docs/api/rest/reference/zoom-api/methods/#operation/webinar) API. Make sure the `registration_type` is 3 if updating multiple occurrences with this API
    # + payload - Details of the registrant to add to the webinar 
    # + return - returns can be any of following types 
    # http:Created (**HTTP Status Code:** `201`   
#  
# Webinar registration created)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3000` <br>
#  This webinar does not have registration as required: {webinarId}. <br>
# **Error Code:** `3027` <br>
#  Host cannot register. <br>
# **Error Code:** `3034` <br>
#  If you have been invited, please input your work email address. <br>
# **Error Code:** `3038` <br>
#  Webinar is over, you cannot register now. If you have any questions, contact the webinar host. <br>
# **Error Code:** `3000` <br>
#  You have reached the limit for the number of attendees you can add. Contact Zoom Support for more information. <br>
# **Error Code:** `3000` <br>
#  The Zoom REST API does not support paid registration. <br>
# **Error Code:** `3000` <br>
#  You have been invited as a panelist for the webinar, please check your email to find more information about this webinar. <br>
# **Error Code:** `200` <br>
#  No permission. <br>
# **Error Code:** `200` <br>
#  Webinar plan is missing. You must subscribe to the webinar plan and enable webinars for this user in order to perform this action. <br>
# **Error Code:** `300` <br>
#  Invalid webinar ID. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Webinar does not exist: {webinarId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](https://developers.zoom.us/docs/api/rest/rate-limits/). 
# 
#  )
    resource function post webinars/[int webinarId]/registrants(@http:Query {name: "occurrence_ids"} string? occurrenceIds, @http:Payload AddWebinarRegistrantRequest payload) returns AddWebinarRegistrantResponse|http:BadRequest|http:NotFound|http:TooManyRequests {
        return {
            id: webinarId, registrantId: "z8yCxjabRdOZ5WHVt5QZyA", topic: "Product launch webinar",
            startTime: "2026-10-10T17:00:00Z", status: "approved",
            joinUrl: "https://us05web.zoom.us/w/96543210987?tk=r3g1str4nt"
        };
    }

    # Update meeting status
    #
    # + meetingId - The meeting's ID. 
    # When storing this value in your database, you must store it as a `long` format integer and not an integer. Meeting IDs can exceed 10 digits
    # + payload - Status action to apply to the meeting 
    # + return - returns can be any of following types 
    # http:NoContent (**HTTP Status Code:** `204`  
#  
# Meeting updated)
    # http:BadRequest (**HTTP Status Code:** `400` <br>
#  Bad Request  
# 
#  **Error Code:** `3000` <br>
#  Cannot access webinar info. <br>
# **Error Code:** `3063` <br>
#  Can not end on-premise user's meeting: {meetingId}. <br>
# **Error Code:** `3161` <br>
#  Meeting hosting and scheduling capabilities are not allowed for your user account. <br>
# )
    # http:NotFound (**HTTP Status Code:** `404` <br>
#  Not Found  
# 
#  **Error Code:** `3001` <br>
#  Meeting does not exist: {meetingId}. <br>
# )
    # http:TooManyRequests (**HTTP Status Code:** `429` <br>
#  Too Many Requests. For more information, see [rate limits](/docs/api/rest/rate-limits/). 
# 
#  )
    resource function put meetings/[int meetingId]/status(@http:Payload UpdateMeetingStatusRequest payload) returns http:NoContent|http:BadRequest|http:NotFound|http:TooManyRequests {
        return http:NO_CONTENT;
    }
}
