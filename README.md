Zazo FriendFinder
===========

[![wercker status](https://app.wercker.com/status/0203b43c52d535dd2af4564f37ac5650/m "wercker status")](https://app.wercker.com/project/bykey/0203b43c52d535dd2af4564f37ac5650)

## Tracking events

- triggered_by (always **ff**)
- initiator (see table below)
- name (see table below)

| initiator    | name                          |
|:-------------|:------------------------------|
| web_client   | { contact added }             |
| web_client   | { contact ignored }           |
|              |                               |
| web_client   | { notification added }        |
| web_client   | { notification ignored }      |
| web_client   | { notification unsubscribed } |
| web_client   | { notification subscribed }   |
|              |                               |
| api          | { contact added }             |
| api          | { contact ignored }           |
|              |                               |
| api          | { notification added }        |
| api          | { notification ignored }      |
|              |                               |
| api          | { setting unsubscribed }      |
| api          | { setting subscribed }        |
|              |                               |
| notification | { email sent }                |
| notification | { email canceled }            |
| notification | { email error }               |
| notification | { email opened }              |
|              |                               |
| notification | { mobile sent }               |
| notification | { mobile canceled }           |
| notification | { mobile error }              |
|              |                               |
