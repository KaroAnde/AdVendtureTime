# AdVendtureTime

<img src="https://github.com/user-attachments/assets/6a7a8565-2181-4e63-9c87-68802085595e" width= 400, height=400>

Technical assignment for the dream job ✨


This repository contains a simple, scalable iOS app that displays a list of ads fetched from a remote JSON endpoint as well as favourite ads. 
Users can view all ads, mark ads as favorites, and later access those favorites offline. The goal was to implement a clean, maintainable structure with a strong focus on clarity and performance.

---

### How to Run the Project

1. Clone the repository from the main branch
2. Open `AdVendtureTime.xcodeproj`
3. Run the project in an iOS simulator or real device

### Features

- **Remote Fetching:**  
  Ads are fetched from a remote JSON API when the app launches.

- **Ad Display:**  
  Each ad displays the following information:
  - Photo
  - Title
  - Price
  - Location

- **Favorites Support:**  
  Users can favorite ads, which:
  - Saves the ad locally as JSON
  - Stores the image locally
  - Allows offline access from the Favorites tab

- **Offline Mode:**  
  The Favorites tab loads data from local storage, independent of network state.

- **Toggle View Mode:**  
  The user can switch between:
  - All ads (fetched remotely)
  - Favorite ads (stored locally)

---

### Technical Overview

####  Architecture
- An adaption of **Clean Architecture** without a Use Case layer (not needed for the current scope) (https://medium.com/@rudrakshnanavaty/clean-architecture-7c1b3b4cb181)
- Clear separation between:
  - Data layer (networking, local storage)
  - Domain/model logic
  - UI presentation
- Designed for future scalability without premature abstraction

#### Technologies Used
- **Combine** for reactive bindings and state updates
- **URLSession** for networking
- **Codable** for parsing JSON and saving ads
- **FileManager** to persist JSON and image files locally
- **SwiftUI** for declarative UI

#### Testing
- Basic unit testing with mocks to validate:
  - Decoding
  - Local storage handling
  - Networking behavior (mocked API client)

#### Accessibility
- Added accessibility modifiers to core views (e.g. buttons, labels)
- Not yet fully implemented throughout the app

---

### Key Implementation Decisions

- **No use of third-party dependencies** — native tools (Combine, Codable, FileManager) were sufficient for the assignment’s scope.
- **AdCardView** is a reusable component used in both the main list and favorites view.
- **FavouritesPersistenceService** handles local persistence of both JSON and images, simplifying local/remote logic separation.
- **Protocols** used for easier mocking

---

### What I’m Proud Of

- Solving offline support by saving both ad data and images manually to disk
- Clean architecture and modular structure — easy to extend, and test
- Reusable views
- Adding basic accessibility support early in the project

---

### What Could Be Improved

- Add more tests for repository and service layers
- Add a a refresh/pull-to-refresh pattern
- Improve error handling and display user-facing error messages
- Complete accessibility coverage across all UI components
- Launch time...

---

### What I’d Add With More Time

- **Detail View:** A full-screen page showing the full ad and its information
- **Filtering:** Sort or filter by location, price, or category
- **Tab Bar Polish:** Animated interactions or transitions for better UX
- **Shipping Method Labels:** Clear UI indicators for how items can be delivered
- **API Module:** Extract all API-related code into its own framework for reuse and testing
-  **Strings:** No hardcoded strings. Should be stored and localized

### Screenshot from current "To do" in Trello board
<img src="https://github.com/user-attachments/assets/9e35aef7-5933-4e8f-a9a6-6403d441acd1" width=300 height=600>

### Screenshot from first design iteration
<img width="306" alt="Screenshot 2025-06-24 at 01 29 07" src="https://github.com/user-attachments/assets/5a106b79-e66f-48de-b151-3d4f6c277c3d" />




