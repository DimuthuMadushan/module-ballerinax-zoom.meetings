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

// Schedules a team meeting with a waiting room, attaches a poll to run during the meeting,
// and prints the invitation text to share with attendees.

import ballerina/io;
import ballerinax/zoom.meetings;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string userId = ?;
configurable string meetingTopic = ?;
// ISO 8601 in UTC, for example 2026-10-01T15:00:00Z
configurable string startTime = ?;
configurable int durationMinutes = 60;
configurable string timezone = "UTC";
configurable string pollQuestion = ?;
// Comma-separated, for example "Q3,Q4"
configurable string pollAnswers = ?;

public function main() returns error? {
    string[] answers = from string a in re `,`.split(pollAnswers)
        let string t = a.trim()
        where t != ""
        select t;
    if answers.length() < 2 {
        return error("pollAnswers must list at least two comma-separated answers");
    }
    meetings:Client zoom = check new ({auth: {clientId, clientSecret, refreshToken}});

    // Step 1: create a scheduled meeting that holds attendees in a waiting room until the host admits them.
    meetings:CreateMeetingResponse meeting = check zoom->createMeeting(userId, {
        topic: meetingTopic,
        'type: 2,
        startTime,
        duration: durationMinutes,
        timezone,
        settings: {
            waitingRoom: true,
            joinBeforeHost: false,
            muteUponEntry: true,
            hostVideo: true,
            participantVideo: false
        }
    });
    int? meetingId = meeting.id;
    if meetingId is () {
        return error("Zoom did not return an ID for the new meeting");
    }
    io:println("Created meeting ", meetingId, ": ", meeting.topic ?: meetingTopic);
    io:println("Join URL: ", meeting.joinUrl ?: "(not returned)");

    // Steps 2 and 3 run against the new meeting; if either fails, delete it rather than leave it scheduled.
    string|error text = addPollAndGetInvitation(zoom, meetingId, answers);
    if text is error {
        error? deleted = zoom->deleteMeeting(meetingId);
        if deleted is error {
            return error(string `${text.message()}. Meeting ${meetingId} could not be deleted and is still scheduled; delete it in Zoom.`, text);
        }
        return error(string `${text.message()}. Meeting ${meetingId} was deleted.`, text);
    }
    io:println("\n--- Invitation ---\n", text);
}

function addPollAndGetInvitation(meetings:Client zoom, int meetingId, string[] answers) returns string|error {
    // Step 2: attach a single-choice poll the host can launch during the meeting.
    meetings:CreateMeetingPollResponse poll = check zoom->createMeetingPoll(meetingId, {
        title: pollQuestion,
        pollType: 1,
        questions: [{name: pollQuestion, 'type: "single", answerRequired: true, answers}]
    });
    io:println("Added poll ", poll.id ?: "(no ID)", " with ", answers.length(), " answers");

    // Step 3: fetch the invitation text Zoom generates for the meeting, ready to paste into an email or chat.
    meetings:GetMeetingInvitationResponse invitation = check zoom->getMeetingInvitation(meetingId);
    string? text = invitation.invitation;
    if text is () {
        return error(string `Zoom returned no invitation text for meeting ${meetingId}`);
    }
    return text;
}
