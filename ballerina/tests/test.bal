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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.zoom.us/v2" : "http://localhost:9090";
final string userId = isLiveServer ? os:getEnv("ZOOM_USER_ID") : "me";
final string clientId = isLiveServer ? os:getEnv("ZOOM_CLIENT_ID") : "mockClientId";
final string clientSecret = isLiveServer ? os:getEnv("ZOOM_CLIENT_SECRET") : "mockClientSecret";
final string refreshToken = isLiveServer ? os:getEnv("ZOOM_REFRESH_TOKEN") : "mockRefreshToken";

final Client zoom = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        return new ({auth: {clientId, clientSecret, refreshToken}}, serviceUrl);
    }
    // The mock is plain HTTP; HTTP/1.1 avoids the h2c upgrade that stalls PATCH requests with a body.
    return new ({auth: {token: "mockAccessToken"}, httpVersion: http:HTTP_1_1}, serviceUrl);
}

// Creates a meeting owned by the test that calls it, so no test depends on another's fixture.
isolated function createFixtureMeeting(string topic) returns int|error {
    CreateMeetingResponse created = check zoom->createMeeting(userId, {
        topic,
        'type: 2,
        startTime: "2030-10-01T15:00:00Z",
        duration: 30,
        timezone: "UTC",
        agenda: "Created by the zoom.meetings connector tests"
    });
    int? id = created.id;
    if id is () {
        return error("createMeeting returned no meeting ID");
    }
    return id;
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateMeeting() returns error? {
    CreateMeetingResponse response = check zoom->createMeeting(userId, {
        topic: "Connector test meeting",
        'type: 2,
        startTime: "2030-10-01T15:00:00Z",
        duration: 45,
        timezone: "UTC"
    });
    test:assertTrue(response.id is int);
    test:assertEquals(response.topic, "Connector test meeting");
    test:assertTrue(response.joinUrl is string);
    if isLiveServer {
        check zoom->deleteMeeting(<int>response.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListMeetings() returns error? {
    ListMeetingsResponse response = check zoom->listMeetings(userId, pageSize = 10);
    test:assertTrue(response.meetings is ListMeetingsResponseDetailsMeeting[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetMeeting() returns error? {
    int meetingId = check createFixtureMeeting("Connector get test");
    GetMeetingResponse response = check zoom->getMeeting(meetingId);
    test:assertEquals(response.id, meetingId);
    test:assertTrue(response.topic is string);
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdateMeeting() returns error? {
    int meetingId = check createFixtureMeeting("Connector update test");
    check zoom->updateMeeting(meetingId, {topic: "Connector update test (renamed)", duration: 50});
    if isLiveServer {
        GetMeetingResponse updated = check zoom->getMeeting(meetingId);
        test:assertEquals(updated.topic, "Connector update test (renamed)");
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteMeeting() returns error? {
    CreateMeetingResponse created = check zoom->createMeeting(userId, {
        topic: "Connector delete test",
        'type: 2,
        startTime: "2030-10-01T15:00:00Z",
        duration: 30
    });
    int meetingId = check created.id.ensureType();
    error? result = zoom->deleteMeeting(meetingId);
    test:assertTrue(result is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUpcomingMeetings() returns error? {
    ListUpcomingMeetingsResponse response = check zoom->listUpcomingMeetings(userId);
    test:assertTrue(response.meetings is ListUpcomingMeetingsResponseMeeting[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetMeetingInvitation() returns error? {
    int meetingId = check createFixtureMeeting("Connector invitation test");
    GetMeetingInvitationResponse response = check zoom->getMeetingInvitation(meetingId);
    test:assertTrue(response.invitation is string);
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["mock_tests"]}
function testUpdateMeetingStatus() returns error? {
    // Ending a meeting only succeeds live while it is in progress, so this runs against the mock only.
    error? result = zoom->updateMeetingStatus(85746065432, {action: "end"});
    test:assertTrue(result is ());
}

@test:Config {groups: ["mock_tests"]}
function testListMeetingRegistrants() returns error? {
    // Registration needs a paid plan and a meeting with registration enabled; mock only.
    ListMeetingRegistrantsResponse response = check zoom->listMeetingRegistrants(85746065432, pageSize = 30);
    ListMeetingRegistrantsResponseRegistrant[]? registrants = response.registrants;
    test:assertTrue(registrants is ListMeetingRegistrantsResponseRegistrant[] && registrants.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testAddMeetingRegistrant() returns error? {
    AddMeetingRegistrantResponse response = check zoom->addMeetingRegistrant(85746065432, {
        firstName: "Jill",
        lastName: "Chill",
        email: "jchill@example.com"
    });
    test:assertTrue(response.registrantId is string);
    test:assertTrue(response.joinUrl is string);
}

@test:Config {groups: ["mock_tests"]}
function testGetMeetingRegistrant() returns error? {
    GetMeetingRegistrantResponse response = check zoom->getMeetingRegistrant(85746065432, "9tboDiHUQAeOnbmudzWa5g");
    test:assertEquals(response.id, "9tboDiHUQAeOnbmudzWa5g");
    test:assertEquals(response.status, "approved");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteMeetingRegistrant() returns error? {
    AddMeetingRegistrantResponse created = check zoom->addMeetingRegistrant(85746065432, {
        firstName: "Ravi",
        email: "rkumar@example.com"
    });
    string? registrantId = created.registrantId;
    if registrantId is () {
        return error("addMeetingRegistrant returned no registrant ID");
    }
    error? result = zoom->deleteMeetingRegistrant(85746065432, registrantId);
    test:assertTrue(result is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateMeetingPoll() returns error? {
    int meetingId = check createFixtureMeeting("Connector poll test");
    CreateMeetingPollResponse response = check zoom->createMeetingPoll(meetingId, {
        title: "Roadmap priorities",
        pollType: 1,
        questions: [{name: "Which quarter should we prioritise?", 'type: "single", answers: ["Q3", "Q4"]}]
    });
    test:assertTrue(response.id is string);
    test:assertEquals(response.title, "Roadmap priorities");
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListMeetingPolls() returns error? {
    int meetingId = check createFixtureMeeting("Connector list polls test");
    ListMeetingPollsResponse response = check zoom->listMeetingPolls(meetingId);
    test:assertTrue(response.polls is ListMeetingPollsResponsePoll[]);
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetMeetingPoll() returns error? {
    int meetingId = check createFixtureMeeting("Connector get poll test");
    CreateMeetingPollResponse created = check zoom->createMeetingPoll(meetingId, {
        title: "Lunch options",
        questions: [{name: "Pizza or salad?", 'type: "single", answers: ["Pizza", "Salad"]}]
    });
    string pollId = check created.id.ensureType();
    GetMeetingPollResponse response = check zoom->getMeetingPoll(meetingId, pollId);
    test:assertEquals(response.id, pollId);
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteMeetingPoll() returns error? {
    int meetingId = check createFixtureMeeting("Connector delete poll test");
    CreateMeetingPollResponse created = check zoom->createMeetingPoll(meetingId, {
        title: "Temporary poll",
        questions: [{name: "Keep this poll?", 'type: "single", answers: ["Yes", "No"]}]
    });
    string pollId = check created.id.ensureType();
    error? result = zoom->deleteMeetingPoll(meetingId, pollId);
    test:assertTrue(result is ());
    if isLiveServer {
        check zoom->deleteMeeting(meetingId);
    }
}

@test:Config {groups: ["mock_tests"]}
function testGetMeetingRecordings() returns error? {
    // Needs a past meeting with a cloud recording; mock only.
    GetMeetingRecordingsResponse response = check zoom->getMeetingRecordings("aDYlohsHRtCd4ii1uC2+hA==");
    test:assertTrue(response.recordingCount is int);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUserRecordings() returns error? {
    ListUserRecordingsResponse response = check zoom->listUserRecordings(userId, 'from = "2026-09-01", to = "2026-09-30");
    test:assertTrue(response.meetings is ListUserRecordingsResponseExtensionMeeting[]);
}

@test:Config {groups: ["mock_tests"]}
function testGetPastMeeting() returns error? {
    GetPastMeetingResponse response = check zoom->getPastMeeting("aDYlohsHRtCd4ii1uC2+hA==");
    test:assertEquals(response.uuid, "aDYlohsHRtCd4ii1uC2+hA==");
    test:assertTrue(response.participantsCount is int);
}

@test:Config {groups: ["mock_tests"]}
function testListPastMeetingParticipants() returns error? {
    ListPastMeetingParticipantsResponse response = check zoom->listPastMeetingParticipants("aDYlohsHRtCd4ii1uC2+hA==");
    ListPastMeetingParticipantsResponseParticipant[]? participants = response.participants;
    test:assertTrue(participants is ListPastMeetingParticipantsResponseParticipant[] && participants.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testGetMeetingSummary() returns error? {
    // Meeting summaries need AI Companion on a paid plan; mock only.
    GetMeetingSummaryResponse response = check zoom->getMeetingSummary("aDYlohsHRtCd4ii1uC2+hA==");
    test:assertTrue(response.summaryContent is string);
}

@test:Config {groups: ["mock_tests"]}
function testGetMeetingTranscript() returns error? {
    GetMeetingTranscriptResponse response = check zoom->getMeetingTranscript("aDYlohsHRtCd4ii1uC2+hA==");
    test:assertEquals(response.canDownload, true);
}

@test:Config {groups: ["mock_tests"]}
function testListWebinars() returns error? {
    // Webinars need a Zoom Webinars licence; the webinar tests run against the mock only.
    ListWebinarsResponse response = check zoom->listWebinars(userId);
    ListWebinarsResponseDetailsWebinar[]? webinars = response.webinars;
    test:assertTrue(webinars is ListWebinarsResponseDetailsWebinar[] && webinars.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testCreateWebinar() returns error? {
    CreateWebinarResponse response = check zoom->createWebinar(userId, {
        topic: "Product launch webinar",
        'type: 5,
        startTime: "2030-10-10T17:00:00Z",
        duration: 90
    });
    test:assertTrue(response.id is int);
    test:assertEquals(response.topic, "Product launch webinar");
}

@test:Config {groups: ["mock_tests"]}
function testGetWebinar() returns error? {
    GetWebinarResponse response = check zoom->getWebinar("96543210987");
    test:assertEquals(response.id, 96543210987);
}

@test:Config {groups: ["mock_tests"]}
function testDeleteWebinar() returns error? {
    CreateWebinarResponse created = check zoom->createWebinar(userId, {topic: "Temporary webinar", 'type: 5});
    int webinarId = check created.id.ensureType();
    error? result = zoom->deleteWebinar(webinarId);
    test:assertTrue(result is ());
}

@test:Config {groups: ["mock_tests"]}
function testListWebinarPanelists() returns error? {
    ListWebinarPanelistsResponse response = check zoom->listWebinarPanelists(96543210987);
    test:assertTrue(response.panelists is ListWebinarPanelistsResponsePanelist[]);
}

@test:Config {groups: ["mock_tests"]}
function testAddWebinarRegistrant() returns error? {
    AddWebinarRegistrantResponse response = check zoom->addWebinarRegistrant(96543210987, {
        firstName: "Jill",
        lastName: "Chill",
        email: "jchill@example.com"
    });
    test:assertTrue(response.registrantId is string);
}

@test:Config {groups: ["mock_tests"]}
function testListTrackingFields() returns error? {
    // Tracking fields are an account-admin feature; mock only.
    ListTrackingFieldsResponse response = check zoom->listTrackingFields();
    test:assertTrue(response.trackingFields is ListTrackingFieldsResponseTrackingField[]);
}

@test:Config {groups: ["mock_tests"]}
function testCreateTrackingField() returns error? {
    CreateTrackingFieldResponse response = check zoom->createTrackingField({
        'field: "Cost center",
        required: false,
        visible: true,
        recommendedValues: ["Engineering", "Sales"]
    });
    test:assertTrue(response.id is string);
    test:assertEquals(response.'field, "Cost center");
}
