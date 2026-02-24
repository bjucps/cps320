# Brunneus-Ferrum-Malleus
---
## Fine Arts Event Builder & Calendar Manager

### Team Name
**Brunneus-Ferrum-Malleus** Or **BFM** for short

| Role | Requirements | Assigned To |
|---|---|---|
| **Project Manager** | IT major (ideally took Project Mgmt) | _Robert Brown_ |
| **DevOps Engineer** | None | _Joshua Steel_ |
| **Developer** | None | _Joshua Hammer_ |
| **Security Administrator** | None | _Joshua Hammer/Joshua Steel/Robert Brown_ |
---

## What We’re Building
A web app to **create fine-arts events** (recitals, exhibitions, auditions) and to **publish/manage a calendar** for public and internal audiences. Details currently unknown


## Functional Requirements

### 1. Event Management and Display

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| EM-1 | Import events from university calendar of events database | High | consistent event data across platforms |
| EM-2 | Allow administrators to add arts events not in the main calendar | High | Capture all arts events in one location |
| EM-3 | Display event details including time, location, type, and description | High | Provide important information to users |
| EM-4 | Categorize events by type (concerts, recitals, exhibitions, etc.) | Medium | Enable filtering and personalized notifications |
| EM-5 | Include campus map integration showing event locations | Medium | Help users navigate to events |
| EM-6 | Display real-time event status (upcoming, ongoing, canceled) | High | Keep users informed of event status changes |
| EM-7 | Generate the Fine Arts Weekly email from the same data source | Medium | Reduce duplicate work for administrators |

### 2. Attendance Tracking

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| AT-1 | QR code scanning functionality for event attendance | High | Record student attendance at events |
| AT-2 | Track attendance for MU098 (non-music majors, 2 required events) | High | Fulfill academic requirements |
| AT-3 | Track attendance for MU099 (music majors, 5 required events) | High | Fulfill academic requirements |
| AT-4 | Allow students to view which events fulfill their specific requirements | High | Help students plan which events to attend |
| AT-5 | Enable faculty to search attendance records by student | High | Allow faculty to verify attendance |
| AT-6 | Export attendance data (e.g., to Excel) for grade reporting | High | Streamline administrative processes |
| AT-7 | Authenticate students through BJU login framework | High | Ensure accurate attendance tracking |

### 3. Program Content Management

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| PC-1 | Store program information (performers, pieces, notes) in database | High | Centralize program information |
| PC-2 | Allow administrators to upload and edit program details | High | Maintain accurate event information |
| PC-3 | Display digital program/leaflet for each event | High | Reduce printing costs and environmental impact |
| PC-4 | Include optional "dark mode" for viewing programs during performances | Low | Enhance user experience during events |
| PC-5 | Support multimedia content (images, videos, interviews) | Medium | Enrich event information |
| PC-6 | Link to ticketing for paid events | Medium | Facilitate ticket purchases |

### 4. User Experience

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| UX-1 | Push notifications for event updates and reminders | Medium | Keep users informed of relevant events |
| UX-2 | Allow users to follow specific event types for personalized notifications | Medium | Personalize user experience |
| UX-3 | Include welcome section with information for parents and guests | Low | Improve experience for non-student users |
| UX-4 | Support social media sharing of events | Low | Increase event visibility |
| UX-5 | Provide links to livestreams for applicable events | Medium | Expand event accessibility |
| UX-6 | Include donor recognition and giving opportunities | Low | Support fundraising efforts |

## Non-Functional Requirements

### 1. Product Requirements

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| PR-1 | Mobile app must function on both iOS and Android platforms | High | accessibility for all users |
| PR-2 | Web interface must be responsive and work on all major browsers | High | Support administrative functions |
| PR-3 | System must support at least 1000 concurrent users | High | Handle peak usage during major events |
| PR-4 | Database must securely store student attendance records | High | Protect sensitive academic data |

### 2. Security Requirements

| Requirement ID | Description | Priority | Purpose |
| --- | --- | --- | --- |
| SR-1 | Integrate with BJU Login Framework for authentication | High | Leverage existing security infrastructure |
| SR-2 | Implement role-based access control | High | Restrict data access to authorized users |
| SR-3 | Encrypt sensitive data in transit and at rest | High | Protect user information |
| SR-4 | Implement audit logging for all attendance-related operations | Medium | Track system usage for security purposes |
| SR-5 | Comply with university data privacy policies | High | Ensure legal compliance |

## Implementation Recommendations

1. **Development Approach**:
    - First semester: Focus on backend web interface using Django
    - Create a REST API that can be consumed by both web and mobile interfaces
    - Second semester: Develop mobile interfaces for iOS and Android
2. **Technology Stack**:
    - Backend: Django with Python
    - Database: PostgreSQL
    - API: Django REST Framework
    - Mobile: React Native (for cross-platform capability)
    - Authentication: Integrate with BJU Login Framework
3. **Team Structure**:
    - Backend team: Focus on data models, API, and admin interface
    - Frontend team: Focus on web and mobile user interfaces
    - Integration team: Work on BJU Login Framework and calendar integration
4. **Development Phases**:
    - Phase 1: Core event display and program information
    - Phase 2: Attendance tracking functionality
    - Phase 3: User preferences and notifications
    - Phase 4: Guest/parent features and social integration

## Potential Applications

1. Regular university arts events management and promotion
2. Special events such as High School Festival, AACS, and Music Camp
3. Tracking student attendance for academic requirements
4. Generating promotional materials from centralized data
5. Providing digital programs for performances
6. Expanding to include other university departments in the future

## Security Concerns

1. Authentication must be secure to prevent attendance fraud
2. Personal information collected from non-student users requires protection
3. Integration with university systems requires secure API access
4. Push notification permissions must be clearly explained to users


## Conclusion
The Fine Arts Event Builder and Calender App is a solution intended to centralize event information, track student attendence. Through implementing this application in phases, with the recommended technology stack, the university will be capable of significantely reducing manual administrative work while improving event visibility to campus and others. 
