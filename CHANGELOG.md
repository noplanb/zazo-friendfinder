# Changelog

### v0.4.1
- :hammer: Fixed images assets

### v0.4.0
- :buib: Added caching for `marked_as_friend` contact additions
- :buib: Updated API documentation
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
