# TripUpNow Flutter App

A Flutter mobile application for trip planning and exploration, built to complement the Vue.js PWA.

## Features

- **Authentication**: Login, signup, and email verification
- **Home**: Trending places carousel and recommendations
- **Explore**: Interactive map with place search functionality
- **Track**: Nearby places discovery with location services
- **Planner**: Trip planning and itinerary generation
- **Profile**: User profile management and settings

## Getting Started

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development
- Google Maps API key
- Backend API running

### Installation

1. **Clone the repository and navigate to the Flutter app directory:**
   ```bash
   cd flutter_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API keys and backend URL:**
   
   Edit `lib/core/app_config.dart`:
   ```dart
   class AppConfig {
     static const String baseUrl = 'YOUR_BACKEND_URL'; // Replace with your backend URL
     static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key
   }
   ```

4. **Configure Google Maps for Android:**
   
   Edit `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                 # Core configuration and routing
│   ├── app_config.dart   # App configuration and constants
│   ├── router.dart       # App routing configuration
│   └── theme.dart        # App theme configuration
├── models/               # Data models
│   ├── user_model.dart   # User data model
│   └── place_model.dart  # Place data model
├── providers/            # State management (Provider pattern)
│   ├── auth_provider.dart    # Authentication state
│   ├── place_provider.dart   # Places data state
│   └── theme_provider.dart   # Theme state
├── services/             # API and external services
│   ├── api_service.dart      # Backend API integration
│   └── location_service.dart # Location services
├── screens/              # UI screens
│   ├── auth/             # Authentication screens
│   ├── main/             # Main app shell
│   ├── home/             # Home screen
│   ├── explore/          # Explore/map screen
│   ├── track/            # Nearby places screen
│   ├── planner/          # Trip planner screen
│   └── profile/          # Profile screen
├── widgets/              # Reusable UI components
└── main.dart             # App entry point
```

## Key Features Implementation

### Authentication
- JWT token-based authentication with refresh token support
- Secure storage for tokens using `flutter_secure_storage`
- Email verification with OTP

### Location Services
- GPS location access with permission handling
- Nearby places discovery based on user location
- Integration with Google Maps for place visualization

### State Management
- Provider pattern for state management
- Reactive UI updates based on state changes
- Error handling and loading states

### API Integration
- RESTful API integration with Dio HTTP client
- Automatic token refresh on 401 errors
- Cookie-based session management

### UI/UX
- Material Design 3 with custom theming
- Dark/light mode support
- Responsive design for different screen sizes
- Smooth animations and transitions

## API Endpoints

The app integrates with the following backend endpoints:

- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `POST /api/auth/send-otp` - Send OTP for verification
- `POST /api/auth/verify-otp` - Verify OTP
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/logout` - User logout
- `GET /api/places` - Get all places
- `GET /api/trending` - Get trending places
- `GET /api/places/search` - Search places
- `GET /api/places/nearby` - Get nearby places
- `GET /api/places/plans` - Generate trip plans

## Permissions

The app requires the following permissions:

### Android
- `INTERNET` - Network access
- `ACCESS_FINE_LOCATION` - Precise location
- `ACCESS_COARSE_LOCATION` - Approximate location
- `CAMERA` - Camera access for photos
- `READ_EXTERNAL_STORAGE` - Read photos
- `WRITE_EXTERNAL_STORAGE` - Save photos

### iOS
- Location access (when in use)
- Camera access
- Photo library access

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Dependencies

Key dependencies used in this project:

- **UI & Navigation**: `go_router`, `cached_network_image`, `carousel_slider`
- **State Management**: `provider`
- **HTTP & API**: `dio`, `cookie_jar`
- **Storage**: `shared_preferences`, `flutter_secure_storage`
- **Location & Maps**: `geolocator`, `google_maps_flutter`
- **Utils**: `shimmer`, `url_launcher`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.