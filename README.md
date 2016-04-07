Zazo FriendFinder
===========

[![wercker status](https://app.wercker.com/status/0203b43c52d535dd2af4564f37ac5650/m "wercker status")](https://app.wercker.com/project/bykey/0203b43c52d535dd2af4564f37ac5650)

## Tracking events

| triggered_by    | name                        | initiator (id)      | target (id)         |
|:----------------|:----------------------------|:--------------------|:--------------------|
| ff:web_client   | {contact,added}             | owner (mkey)        | contact (id)        |
| ff:web_client   | {contact,ignored}           | owner (mkey)        | contact (id)        |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:web_client   | {notification,added}        | owner (mkey)        | notification (nkey) |
| ff:web_client   | {notification,ignored}      | owner (mkey)        | notification (nkey) |
| ff:web_client   | {notification,unsubscribed} | owner (mkey)        | notification (nkey) |
| ff:web_client   | {notification,subscribed}   | owner (mkey)        | notification (nkey) |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:api          | {contact,added}             | owner (mkey)        | contact (id)        |
| ff:api          | {contact,ignored}           | owner (mkey)        | contact (id)        |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:api          | {notification,added}        | owner (mkey)        | notification (nkey) |
| ff:api          | {notification,ignored}      | owner (mkey)        | notification (nkey) |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:api          | {setting,unsubscribed}      | owner (mkey)        |                     |
| ff:api          | {setting,subscribed}        | owner (mkey)        |                     |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:notification | {email,sent}                | notification (nkey) | owner (mkey)        |
| ff:notification | {email,canceled}            | notification (nkey) | owner (mkey)        |
| ff:notification | {email,error}               | notification (nkey) | owner (mkey)        |
| ff:notification | {email,opened}              | notification (nkey) | owner (mkey)        |
|-----------------|-----------------------------|---------------------|---------------------|
| ff:notification | {mobile,sent}               | notification (nkey) | owner (mkey)        |
| ff:notification | {mobile,canceled}           | notification (nkey) | owner (mkey)        |
| ff:notification | {mobile,error}              | notification (nkey) | owner (mkey)        |
