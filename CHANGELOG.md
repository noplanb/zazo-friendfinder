# Changelog

### 0.10.6-wip.1
- :bulb: Added wercker deploy configuration
- :arrow_up: Bumped and updated usage of zazo-tools gem

### 0.10.6
- :arrow_up: Implemented contacts sync before sending notifications

### 0.10.5
- :arrow_up: Changed fake notifications period from 24 hours to 4 days
- :arrow_up: Added owner mkey to mobile notification payload

### 0.10.4
- :hammer: Fixed bug with cron workers wrapper

### 0.10.3
- :bulb: Implemented wrapper for cron workers

### 0.10.2
- :hammer: Enabled logstash http logging

### 0.10.1
- :hammer: Enabled contacts invitations on production
- :hammer: Disabled logstash udp logging

### 0.10.0
- :bulb: Implemented application settings with UI
- :bulb: Updated `FakeUserJoinedNotification` cron worker to use application settings
- :bulb: Implemented contact addition via notification with specific phone number
- :arrow_up: Refactored a lot of code using interactors
- :arrow_up: Refactored cron configuration
- :hammer: Fixed CI specs status by decreasing active_model_serializers gem version

### 0.9.6
- :hammer: Fixed redirect bug with https on production and staging

### 0.9.5
- :arrow_up: Added force ssl to production environment

### 0.9.4
- :arrow_up: Changed API for adding and ignoring contact
- :arrow_up: Added optional phone_number attribute for contact addition via API

### 0.9.3
- :bulb: Added mobile numbers list for contacts suggestions / mobile notification
- :arrow_up: Reduced contacts suggestions count from 100 to 10
- :arrow_up: Refactored code regarding api
- :hammer: Fixed bug with VCR (use old version of webmock)

### 0.9.2
- :hammer: Fixed `Notification::MobileData` (added host attribute for production/staging)

### 0.9.1
- :arrow_up: Updated Dockerfile to use updated base image

### 0.9.0
- :bulb: Implemented real friends addition (`Contact::Invite` service)

### 0.8.1
- :hammer: Updated `zazo-tools` gem (0.2.1)

### 0.8.0
- :bulb: Added `Zazo::Tools::Logger` for centralized logging

### v0.7.3
- :bulb: Added owner name to owners admin page

### v0.7.2
- :hammer: Fixed contact initials on web client page finally
- :hammer: Fixed broken specs

### v0.7.1
- :bulb: Added description area for email notification template
- :arrow_up: Fixed events pushing to keep related data
- :arrow_up: Refactored code for events pushing
- :arrow_up: Changed email notification -from title
- :hammer: Fixed contact initials on web client page

### v0.7.0
- :bulb: Added `Api::V1::SubscriptionsController` for subscribe/unsubscribe actions
- :bulb: Add show information action for `Api::V1::ContactsController`
- :bulb: Add show information action for `Api::V1::NotificationsController`
- :bulb: Added list with all tracking events
- :bulb: Added feature to track emails opening
- :bulb: Implemented events dispatching
- :arrow_up: Updated API documentation

### v0.6.6
- :bulb: Added feature to clean all contacts statuses
- :bulb: Added hidden feature to mark contacts and friends randomly
- :arrow_up: Refactored danger controller actions
- :arrow_up: Added specs for add/ignore contact services

### v0.6.5
- :bulb: Implemented mobile design for web client page
- :arrow_up: Changed assets precompiler from SASS to SCSS

### v0.6.4
- :hammer: Fixed Procfile configuration for Resque workers

### v0.6.3
- :arrow_up: Refactored code and structure regarding Contact and Score services
- :arrow_up: Changed API for mobile client (see documentation)
- :arrow_up: Renamed *reject(ed)* to *ignore(d)* everywhere
- :arrow_up: Moved functionality from `Contact::GetZazoFriends` service to owner `ExternalData` extension
- :arrow_up: Refactored VCR cassettes and related specs
- :arrow_up: Updated logging messages
- :hammer: Fixed specs after updating vcr gem
- :hammer: Fixed `Contact::GetSuggestions` service to return only appropriate contacts

### v0.6.2
- :arrow_up: Disabled saving precompiled content of notification in database

### v0.6.1
- :hammer: Fixed email template small version

### v0.6.0
- :arrow_up: Extended template view data model
- :bulb: Added brand new emails template (new design)
- :arrow_up: Fixed icon for subscribed state

### v0.5.2
- :bulb: Added admin feature to drop all contacts or notifications (danger zone)
- :bulb: Added *People you may know* subtitle to web-client
- :arrow_up: Changed REMOVE to IGNORE button on web-client
- :arrow_up: Changed NewRelic configuration

### v0.5.1
- :hammer: Fixed bug with `unsubscribed?` owner status

### v0.5.0
- :bulb: Added status field for contacts concepts
- :bulb: Implemented filter system for contacts concepts
- :bulb: Implemented feature to ignore any contact on web-client
- :arrow_up: Updated web-client navbar
- :arrow_up: Updated web-client notification messages
- :arrow_up: Refactored whole web-client
- :arrow_up: Created model for storing owner data (unsubscribed status)
- :hammer: Fixed dockerfile assets precompile
- :hammer: Fixed minor bugs

### v0.4.1
- :bulb: Added feature to update all contacts by owner
- :hammer: Fixed images assets

### v0.4.0
- :bulb: Added caching for `marked_as_friend` contact additions
- :bulb: Updated API documentation
- :hammer: Fixed `ZazoActivity` score criteria (calculate all friends, raised ratio)
- :hammer: Fixed `Contact::GetSuggestions` service to return only last non-friend contacts
- :hammer: Changed database type of `notifications.compiled_content` from `string` to `text`
- :hammer: Handle *ignore after adding* contact use case for `WebClient`
- :hammer: Fixed minor bugs
- :hammer: Refactored code

### v0.3.0
- :bulb: Added `NumEmailsSent` score criteria
- :bulb: Added update info button to `contact#show` page
- :bulb: Added links to other services to `contact#show` page
- :hammer: Fixed `ZazoActivity` score criteria
- :hammer: Fixed score calculation (additions caching)
