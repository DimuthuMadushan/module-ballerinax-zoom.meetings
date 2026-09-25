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

// Finds every upcoming meeting whose topic contains a given phrase and cancels them,
// notifying the host and alternative hosts. Past and in-progress meetings are never touched.
// Runs as a dry run unless `cancelMeetings` is true.

import ballerina/io;
import ballerina/time;
import ballerinax/zoom.meetings;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string userId = ?;
configurable string topicContains = ?;
// Deletes meetings for real when true. Leave false to only list what would be cancelled.
configurable boolean cancelMeetings = false;

public function main() returns error? {
    meetings:Client zoom = check new ({auth: {clientId, clientSecret, refreshToken}});
    // An empty phrase would match, and cancel, every meeting on the account.
    string needle = topicContains.trim().toLowerAscii();
    if needle == "" {
        return error("topicContains must not be empty");
    }

    // Step 1: collect the IDs of meetings in progress, so they are excluded below.
    int[] liveIds = from meetings:ListMeetingsResponseDetailsMeeting m
        in check listAllMeetings(zoom, "live")
        let int? id = m.id
        where id is int
        select id;

    // Step 2: keep upcoming meetings whose topic matches, that start in the future and are not live.
    time:Utc now = time:utcNow();
    meetings:ListMeetingsResponseDetailsMeeting[] matches = [];
    foreach meetings:ListMeetingsResponseDetailsMeeting m in check listAllMeetings(zoom, "upcoming") {
        int? id = m.id;
        string? startTime = m.startTime;
        if id is () || liveIds.indexOf(id) !is () || startTime is () {
            continue;
        }
        time:Utc|time:Error scheduledStart = time:utcFromString(startTime);
        if scheduledStart is time:Error || time:utcDiffSeconds(scheduledStart, now) <= 0d {
            continue;
        }
        if (m.topic ?: "").toLowerAscii().includes(needle) {
            matches.push(m);
        }
    }
    io:println("Found ", matches.length(), " upcoming meeting(s) whose topic contains \"", topicContains, "\"");

    // Step 3: cancel each match, or report it when running as a dry run.
    int cancelled = 0;
    foreach meetings:ListMeetingsResponseDetailsMeeting m in matches {
        int? id = m.id;
        if id is () {
            continue;
        }
        string label = string `${id} "${m.topic ?: ""}" at ${m.startTime ?: "(no start time)"}`;
        if !cancelMeetings {
            io:println("Would cancel ", label);
            continue;
        }
        check zoom->deleteMeeting(id, scheduleForReminder = true);
        cancelled += 1;
        io:println("Cancelled ", label);
    }
    if cancelMeetings {
        io:println("Cancelled ", cancelled, " meeting(s)");
    } else {
        io:println("Dry run only. Set cancelMeetings = true to cancel these meetings.");
    }
}

// Pages through every meeting of the given type.
function listAllMeetings(meetings:Client zoom, "live"|"upcoming" meetingType)
        returns meetings:ListMeetingsResponseDetailsMeeting[]|error {
    meetings:ListMeetingsResponseDetailsMeeting[] all = [];
    string? pageToken = ();
    while true {
        meetings:ListMeetingsQueries queries = {'type: meetingType, pageSize: 300};
        if pageToken is string {
            queries.nextPageToken = pageToken;
        }
        meetings:ListMeetingsResponse page = check zoom->listMeetings(userId, {}, queries);
        meetings:ListMeetingsResponseDetailsMeeting[] pageMeetings = page.meetings ?: [];
        all.push(...pageMeetings);
        string? next = page.nextPageToken;
        if next is () || next == "" {
            return all;
        }
        pageToken = next;
    }
}
