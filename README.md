# Booking Shiny

**Booking Shiny** is a service appointment app built using **Flutter**. The app allows users to book appointments with various service providers, offering a seamless and user-friendly experience. Currently under development, the app supports **Android** as the primary platform, with plans for cross-platform support in the future.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Folder Structure](#folder-structure)
- [How It Works](#how-it-works)
- [Future Enhancements](#future-enhancements)
- [License](#license)

---

## Features

- **User Authentication**:
  - Secure login and signup system powered by Firebase Authentication.
  
- **Appointment Booking**:
  - Users can browse available services and schedule appointments with providers.

- **Geolocation**:
  - Integration with geolocation services to show providers near the user.

- **Autocomplete Search**:
  - Search functionality with location-based autocomplete for convenience.

- **State Management**:
  - Powered by BLoC and Cubit for efficient state handling.

- **Firebase Integration**:
  - Backend functionality supported by Firebase (Authentication, Database, Storage).

- **Theming and Routing**:
  - Fully customizable app theme with seamless navigation.

---

## Tech Stack

### Frontend:
- **Flutter**
  - Multi-platform framework for mobile, web, and desktop applications.

### Backend:
- **Firebase**
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage

### State Management:
- **BLoC (Business Logic Component)** and **Cubit**
  - Handles the app's state efficiently and predictably.

### Other Libraries:
- **Geolocator**: For geolocation services.
- **Flutter Bloc**: For state management.
- **Etc...**: Comes later.

---

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/le-corp/booking_shiny.git
   cd booking_shiny
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Firebase**:
   - Ensure your Firebase project is configured and the necessary `google-services.json` (for Android) is placed in the `android/app` folder.

4. **Run the App**:
   ```bash
   flutter run
   ```

---

## Folder Structure

```
lib/
├── backend/
│   ├── bloc/               # State management with BLoC
│   ├── cubit/              # Alternative state management using Cubit
│   ├── models/             # Data models
│   ├── providers/          # Data providers
│   ├── repositories/       # Data repositories for Firebase and other services
│   └── services/           # Backend service integrations
├── frontend/
│   ├── screens/            # UI screens
│   ├── widgets/            # Reusable UI components
│   └── themes/             # App theme configurations
├── utils/                  # Utilities like routing and constants
└── main.dart               # App entry point
```

---

## How It Works

### Key Features in Action:
1. **Authentication**:
   - Users can create an account or log in securely using Firebase Authentication.

2. **Service Search and Booking**:
   - Users can search for services near their location using the geolocation feature and schedule appointments.

3. **Geolocation Integration**:
   - Retrieves the user's current location to filter nearby services.

4. **State Management**:
   - The app uses `MultiBlocProvider` to manage states for authentication, booking, profile, geolocation, and more.

5. **Routing and Navigation**:
   - `AppRouter` handles navigation between the app's screens seamlessly.

---

## Future Enhancements

1. **Cross-Platform Support**:
   - Extend support to iOS, web, and desktop platforms.

2. **Push Notifications**:
   - Notify users of upcoming appointments or updates.

3. **Payment Gateway Integration**:
   - Add secure payment options for services.

4. **Service Provider Panel**:
   - A dashboard for service providers to manage appointments and schedules.

5. **Offline Mode**:
   - Allow users to browse services and book appointments offline, syncing later when connected.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---
---