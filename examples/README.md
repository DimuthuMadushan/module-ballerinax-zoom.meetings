# Examples

The `ballerinax/zoom.meetings` connector provides practical examples illustrating usage in various scenarios.

1. [Schedule a team meeting](schedule_team_meeting/schedule_team_meeting.md) - Create a meeting with a waiting room, attach a poll, and print the invitation to share with attendees.

2. [Cancel meetings by topic](cancel_meetings_by_topic/cancel_meetings_by_topic.md) - Find every upcoming meeting whose topic contains a phrase and cancel them, with a dry run by default.

## Prerequisites

1. Create a Zoom General App and obtain its client ID, client secret and a user refresh token, as described in the [setup guide](../ballerina/README.md#setup-guide).

2. For each example, create a `Config.toml` file with the configuration listed in that example's guide.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
