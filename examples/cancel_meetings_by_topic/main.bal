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

// Finds every scheduled meeting whose topic contains a given phrase and cancels them,
// notifying the host and alternative hosts. Runs as a dry run unless `cancelMeetings` is true.

import ballerina/io;
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
    string needle = topicContains.toLowerAscii();

    // Step 1: page through every scheduled meeting and keep the ones whose topic matches.
    meetings:ListMeetingsResponseDetailsMeeting[] matches = [];
    string? pageToken = ();
    while true {
        meetings:ListMeetingsQueries queries = {'type: "scheduled", pageSize: 300};
        if pageToken is string {
            queries.nextPageToken = pageToken;
        }
        meetings:ListMeetingsResponse page = check zoom->listMeetings(userId, {}, queries);
        foreach meetings:ListMeetingsResponseDetailsMeeting m in page.meetings ?: [] {
            string topic = m.topic ?: "";
            if topic.toLowerAscii().includes(needle) {
                matches.push(m);
            }
        }
        string? next = page.nextPageToken;
        if next is () || next == "" {
            break;
        }
        pageToken = next;
    }
    io:println("Found ", matches.length(), " scheduled meeting(s) whose topic contains \"", topicContains, "\"");

    // Step 2: cancel each match, or report it when running as a dry run.
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

