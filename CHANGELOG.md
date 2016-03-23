# Changelog

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
